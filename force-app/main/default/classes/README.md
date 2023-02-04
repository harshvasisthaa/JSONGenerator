
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