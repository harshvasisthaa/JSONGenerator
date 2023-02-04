# Custom Objects

## Callout (Callout__mtd)

- Custom Metadata Record Name (DeveloperName)
- Auth Callout (Auth_Callout__c)
-- The Developer name of Callout__mtd record which has been marked as Is_Auth_Callout__c true.

- Auth Callout Handler (Auth_Callout_Handler__c)
-- The class name which implements CalloutInterfaces.AuthCalloutHandler interface, to handle the response of auth callout and setup parameters in the current HTTP request.

- Pre-Auth Callout Validation (Pre_Auth_Callout_Validation__c)
-- The class name which implements CalloutInterfaces.PreAuthCalloutValidation interface, to validate if the authorization HTTP request has to be executed.

- Is Auth Callout (Is_Auth_Callout__c)
-- The flag indicates this is an authorization HTTP request.

- Base URL (Base_URL__c)
-- The base URL of the HTTP request.

- Path (Path__c)
-- The relative path of the HTTP request.

- Method (Method__c)
-- This value indicates the HTTP method GET, PUT, POST, DELETE

- Custom Callout Execution
-- The class name which implements CalloutInterfaces.CustomCalloutExecution interface, to handle the current HTTP request and setup any information which cannot be configured in the framework.

## Callout Properties (Callout_Properties__mdt)

- Custom Metadata Record Name (DeveloperName)

- Callout (Callout__c)
-- The master-detail relationship to Callout (Callout__mtd) object.

- Custom Property (Custom_Property__c)
-- The class name which implements CalloutInterfaces.AuthCalloutHandler interface, to handle the response of auth callout and setup parameters in the current HTTP request.

- Key (Key__c)
-- This value should contain the header name if the type is the header.

- Type (Type__c)
-- The picklist value identifies if the configuration is for header or for the body.

- Value (Value__c)
-- The value should contain a static value if the type is the header, if the type value is the body, this value should be the callout name configured in JSON Generator(JSON_Generator__mdt) object records.

- Is Disabled (Is_Disabled__c)
-- To indicate the property has been disabled and will not be utilized by the framework.


## JSON Generator (JSON_Generator__mdt)

- Custom Metadata Record Name (DeveloperName)
- Callout Name(Callout_Name__c)
- Parent JSON Generator (Parent_JSON_Generator__c)
- Is Start (Is_Start__c)
- sObject Name (sObject_Name__c)
- Object Field API Name (Object_Field_API_Name__c)
- Property Name (Property_Name__c)
- Property Type (Property_Type__c)
- Static Value (Static_Value__c)
- Data Type (Data_Type__c)
- Apex Class API Name (Apex_Class_API_Name__c)
- Is Disabled (Is_Disabled__c)
-- To indicate the property has been disabled and will not be utilized by the framework.