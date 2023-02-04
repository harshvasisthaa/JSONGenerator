public with sharing class CalloutInterfaces {
	
	public interface AuthCalloutHandler{
		void handleAuthResponse(HttpResponse authResponse, HttpRequest request);
	}
	
	public interface PreAuthCalloutValidation{
		boolean executeValidation(HttpRequest request);
	}
	
	public interface CustomCalloutExecution{
		HttpResponse executeCallout(HttpRequest request);
	}
	
}