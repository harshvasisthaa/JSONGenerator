public with sharing class CalloutHandler {
	
	private String calloutName;
	public String recordWhereClause;
	
	private Callout__mdt calloutMetadata;
	private List<Callout_Properties__mdt> calloutProperties;
	
	public CalloutHandler(String calloutName){
		this.calloutName = calloutName;
		getCalloutInfo();
	}
	
	public CalloutHandler(String calloutName, String recordWhereClause){
		this.calloutName = calloutName;
		this.recordWhereClause = recordWhereClause;
		getCalloutInfo();
	}

    public HttpResponse execute(){
		Http http = new Http();
		HttpRequest request = generateRequest();
		if(String.isNotEmpty(calloutMetadata.Auth_Callout__c)){
			Boolean executeAuthCallout = true;
            
			if(!calloutMetadata.Is_Auth_Callout__c && String.isNotEmpty(calloutMetadata.Pre_Auth_Callout_Validation__c)){
				CalloutInterfaces.PreAuthCalloutValidation calloutValidation = (CalloutInterfaces.PreAuthCalloutValidation) Type.forName(calloutMetadata.Pre_Auth_Callout_Validation__c).newInstance();
				executeAuthCallout = calloutValidation.executeValidation(request);
			}
			if(executeAuthCallout){
				HttpResponse authResponse = new CalloutHandler(calloutMetadata.Auth_Callout__c).execute();
				CalloutInterfaces.AuthCalloutHandler authInterface = (CalloutInterfaces.AuthCalloutHandler) Type.forName(calloutMetadata.Auth_Callout_Handler__c).newInstance();
				authInterface.handleAuthResponse(authResponse, request);
			}
		}
        if(String.isNotEmpty(calloutMetadata.Custom_Callout_Execution__c)){
            CalloutInterfaces.CustomCalloutExecution customExecution = (CalloutInterfaces.CustomCalloutExecution) Type.forName(calloutMetadata.Custom_Callout_Execution__c).newInstance();
			return customExecution.executeCallout(request);
        }
		return http.send(request);
	}
	
	private HttpRequest generateRequest(){
		HttpRequest req = new HttpRequest();
		req.setEndpoint(calloutMetadata.Base_URL__c + calloutMetadata.Path__c);
		req.setMethod(calloutMetadata.Method__c);
        setRequestParameters(req);
		return req;
	}
	
	private void setRequestParameters(HttpRequest req){
		for(Callout_Properties__mdt prop : calloutProperties){
			if(prop.Type__c == 'Header'){
				req.setHeader(prop.Key__c, prop.Value__c);
			}else if(prop.Type__c == 'Body'){
                System.debug(prop.Value__c);
                System.debug(this.recordWhereClause);
				req.setBody(new JSONGeneratorHandler(prop.Value__c, this.recordWhereClause).getJSON());
			}
		}
	}
	
	private void getCalloutInfo(){
		calloutMetadata = Callout__mdt.getInstance(this.calloutName);
		calloutProperties = [SELECT Id, Type__c, Key__c, Value__c, Custom_Property__c FROM Callout_Properties__mdt WHERE Callout__r.DeveloperName = :this.calloutName AND Is_Disabled__c = false];
	}
	
}