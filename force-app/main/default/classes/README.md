# Callout Handler and JSON Generator
## _These set of classes will allow Salesforce developer to make a HTTP request using the configuration with the help of Callout__mdt, Callout_Properties__mdt, and JSON_Generator__mdt custom metadata types_

##
##
##

### Classes
##
#### CalloutHandler

- One constructor accepts the developer name of Callout__mdt record to make GET callouts
- Second constructor accepts the developer name of Callout__mdt record as well as where clause to identify the record which has to be utilized to generate JSON. This constructor should be used for body API requests i.e. POST or PUT

We can execute a callout as shown below:
```java
CalloutHandler createCallout = new CalloutHandler('TestCalloutDeveloperName');
createCallout.execute();
``` 

```java
CalloutHandler createCallout = new CalloutHandler('TestCalloutDeveloperName', 'id = \'0012w00001JTMvzAAH\'');
createCallout.execute();
``` 

```java
CalloutHandler createCallout = new CalloutHandler('TestCalloutDeveloperName', '(Name = \'Xyz\' AND Type=\'Date\') OR Status=\'Closed\'');
createCallout.execute();
``` 