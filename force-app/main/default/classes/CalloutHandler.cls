/**
*
* Name: 		CalloutHandler
* Description: 	This class allow to make a callout using Callout__mdt and Callout_Properties__mdt
*              	along with the authorization to targate system
*
* Created Date:	04/02/2023 (DD/MM/YYYY)
* Created By:	Harsh Rawat
*
**/
public with sharing class CalloutHandler {
	
	private String calloutName;
	public String recordWhereClause;
	
	/*
	* calloutMetadata to store the Callout__mdt record which has been retrived using the developer name.
	*/
	private Callout__mdt calloutMetadata;
	
	/*
	* calloutProperties to store all the child properties/configuration (i.e. headers, body) for the callout record.
	*/
	private List<Callout_Properties__mdt> calloutProperties;
	
	
	/*
	* The exception class has been added for a case where auth response is not 2XX
	* In such a case developer should throw the CalloutHandlerException so that it can be recognized during the catch block.
	*/
	public class CalloutHandlerException extends Exception {}
	
	/**
	*
	*	Description:
	*  	This constructor accepts just the callout developer name which has been configured in Callout__mdt
	*	This constructor should be used for non-body API requests i.e. GET or DELETE
	*
	*	@param  calloutName  The name of the callout which has been configured in Callout__mdt
	**/
	public CalloutHandler(String calloutName){
		this.calloutName = calloutName;
		getCalloutInfo();
	}
	
	/**
	*
	*	Description:
	*  	This constructor accepts the callout developer name which has been configured in Callout__mdt 
	*	and where clause for a record which has to be utilized to generate JSON
	*	This constructor should be used for body API requests i.e. POST or PUT
	*
	*	@param  calloutName  		The name of the callout which has been configured in Callout__mdt
	*	@param  recordWhereClause  	A where clause to identify a record to generate JSON
	*
	**/
	public CalloutHandler(String calloutName, String recordWhereClause){
		this.calloutName = calloutName;
		this.recordWhereClause = recordWhereClause;
		getCalloutInfo();
	}


	/**
	*
	*	Description:
	*  	This is the only method exposed as public and providing the HTTP response variable in response.
	*	Firstly the method validates if this is not and Authentication callout and a pre auth callout validation has been added.
	*		if pre auth callout validation has been added, it calls the method and validates if the auth callout has to be executed.
	*	Second if the auth callout has to be executed, the framework makes the auth callout using Auth Callout from Callout__mdt.
	*		After the response of auth callout, the framework calls the AuthCalloutHandler, as auth response cannot be generic and requires custom management.
	*	Third the system validates if the caonfiguration has custom callout configuration, for such a case, where information cannot be configured.
	*	Finally, the system makes the HTTP request and return the response to the source.
	*
	*	For the for First, Second and Third steps, the developer has to implement the PreAuthCalloutValidation, AuthCalloutHandler, CustomCalloutExecution
	*		interfaces and configure the class name in Callout__mdt
	*
	*	@return  HttpResponse  The method return a HTTPResponse variable which can be utilized further as needed.
	*
	**/
    public HttpResponse execute(){
		Http http = new Http();
		HttpRequest request = generateRequest();
		if(String.isNotEmpty(calloutMetadata.Auth_Callout__c)){
			Boolean executeAuthCallout = true;
            
			/*validates if this is not and Authentication callout and a pre auth callout validation has been added*/
			if(!calloutMetadata.Is_Auth_Callout__c && String.isNotEmpty(calloutMetadata.Pre_Auth_Callout_Validation__c)){
				/*if pre auth callout validation has been added, it calls the method and validates if the auth callout has to be executed.*/
				CalloutInterfaces.PreAuthCalloutValidation calloutValidation = (CalloutInterfaces.PreAuthCalloutValidation) Type.forName(calloutMetadata.Pre_Auth_Callout_Validation__c).newInstance();
				executeAuthCallout = calloutValidation.executeValidation(request);
			}
			
			/*if the auth callout has to be executed, the framework makes the auth callout using Auth Callout from Callout__mdt.*/
			if(executeAuthCallout){
				HttpResponse authResponse = new CalloutHandler(calloutMetadata.Auth_Callout__c).execute();
				/*After the response of auth callout, the framework calls the AuthCalloutHandler, as auth response cannot be generic and requires custom management.*/
				CalloutInterfaces.AuthCalloutHandler authInterface = (CalloutInterfaces.AuthCalloutHandler) Type.forName(calloutMetadata.Auth_Callout_Handler__c).newInstance();
				authInterface.handleAuthResponse(authResponse, request);
			}
		}
		
		/*the system validates if the caonfiguration has custom callout configuration, for such a case, where information cannot be configured.*/
        if(String.isNotEmpty(calloutMetadata.Custom_Callout_Execution__c)){
            CalloutInterfaces.CustomCalloutExecution customExecution = (CalloutInterfaces.CustomCalloutExecution) Type.forName(calloutMetadata.Custom_Callout_Execution__c).newInstance();
			customExecution.setupCallout(request);
        }
		return http.send(request);
	}
	
	
	/**
	*
	*	Description:
	*  	The generates the HTTPRequest to make the callout.
	*	It also setup the Endpoint as well as the Method of the callout from Callout__mdt record.
	*
	*	@return  HttpRequest  The method return a HTTPRequest variable which will be utilized to make HTTP request.
	*
	**/
	private HttpRequest generateRequest(){
		HttpRequest req = new HttpRequest();
		req.setEndpoint(calloutMetadata.Base_URL__c + calloutMetadata.Path__c);
		req.setMethod(calloutMetadata.Method__c);
        setRequestParameters(req);
		return req;
	}
	
	/**
	*
	*	Description:
	*  	The method takes the HTTPRequest and setup all the Callout_Properties__mdt in HTTPRequest
	*
	*	@param  req		The HTTP Request variable to configure the headers and body
	*
	**/
	private void setRequestParameters(HttpRequest req){
		for(Callout_Properties__mdt prop : calloutProperties){
			if(prop.Type__c == 'Header'){
				if(String.isNotEmpty(prop.Value__c))
					req.setHeader(prop.Key__c, prop.Value__c);
				else if(String.isNotEmpty(prop.Custom_Property__c))
					req.setHeader(prop.Key__c, this.getCustomValue(prop.Custom_Property__c));
			}else if(prop.Type__c == 'Body'){
				/* 	
				*	If body has been configured in Callout_Properties__mdt the process will call the 
				*	JSONGeneratorHandler and generate the JSON as per the configuration in JSON_Generator__mdt.
				*/
				if(String.isNotEmpty(prop.Value__c))
					req.setBody(new JSONGeneratorHandler(prop.Value__c, this.recordWhereClause).getJSON());
				else if(String.isNotEmpty(prop.Custom_Property__c))
					req.setBody(this.getCustomValue(prop.Custom_Property__c));
			}
		}
	}

	private String getCustomValue(String customProperty){
		CalloutInterfaces.CustomPropertyValue customProp = (CalloutInterfaces.CustomPropertyValue) Type.forName(customProperty).newInstance();
		return customProp.getValue();
	}
	
	/**
	*
	*	Description:
	*  	The method gets the Callout__mdt record using developer name along with callout properties (i.e. headers, body)
	*
	**/
	private void getCalloutInfo(){
		calloutMetadata = Callout__mdt.getInstance(this.calloutName);
		calloutProperties = [SELECT Id, Type__c, Key__c, Value__c, Custom_Property__c FROM Callout_Properties__mdt WHERE Callout__r.DeveloperName = :this.calloutName AND Is_Disabled__c = false];
	}
	
}