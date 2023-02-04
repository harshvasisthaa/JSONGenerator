/**
*
* Name: 		CalloutInterfaces
* Description: 	This class provides the fisiblity to perform custom operations during a callout
*
* Created Date:	04/02/2023 (DD/MM/YYYY)
* Created By:	Harsh Rawat
*
**/
public with sharing class CalloutInterfaces {
	
	/**
	*	Description:
	*	The interface has to be implemented to handle the authorization response and setup the auth header in current request
	*	As this handling cannot be generic, but this class can be implemented once and utilized in multiple callouts.
	**/
	public interface AuthCalloutHandler{
		/**
		*	Description:
		*	Any class implements the AuthCalloutHandler interface it has to have the handleAuthResponse method.
		*	This method should be utilized to parse the auth response and setup the auth header to current HTTPRequest
		*	If the auth response is unsuccessful, the developer should throw CalloutHandler.CalloutHandlerException
		*
		*	@param  authResponse  		The response of the authorization callout, so that developer can process the response.
		*	@param  request  			Current HTTP request, so that developer can add the required configuration(header).
		**/
		void handleAuthResponse(HttpResponse authResponse, HttpRequest request);
	}
	
	/**
	*	Description:
	*	The interface has to be implemented to validate if the authorization callout should happen
	*	This is very specific to the case if the developer want to store the previous auth response in cache, custom setting record, or custom object record.
	*	This interface will be utilized to validate if previously stored auth response is still valid or it has expired.
	*	If the previously stored auth response has been expired the auth callout will be executed again in CalloutHandler class.
	**/
	public interface PreAuthCalloutValidation{
		/**
		*	Description:
		*	Any class implements the PreAuthCalloutValidation interface it has to have the executeValidation method.
		*	This method should be utilized to validate if the previously stored auth response is valid.
		*	If the auth response is valid the method should setup the auth header in current request and return false
		*	If the auth response is invalid the method return true, and auth header setup should be handeled in AuthCalloutHandler.handleAuthResponse method.
		*
		*	@param  request  	Current HTTP request, so that developer can add the required configuration(header).
		*	@return	boolean		True if the auth response is in-valid, false if auth response is valid
		**/
		boolean executeValidation(HttpRequest request);
	}
	
	/**
	*	Description:
	*	The interface has to be implemented if there are some parametes in the HTTP request which cannot be configured (i.e. headers, custom body)
	*	As existing configuration allow only JSON request body with the parsing of single record.
	*	This intercace allow framework to handele all the unexpected behaviour of a HTTP request.
	**/
	public interface CustomCalloutExecution{
		/**
		*	Description:
		*	Any class implements the CustomCalloutExecution interface it has to have the setupCallout method.
		*	This method should be utilized to setup any unexpected HTTP request behaviour.
		*
		*	@param  request  	Current HTTP request, so that developer can do the required.
		**/
		void setupCallout(HttpRequest request);
	}
	
}