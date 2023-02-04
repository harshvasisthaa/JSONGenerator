public class ValidateJSONCreation {

    @AuraEnabled(cacheable=true)
    public static List<String> getCalloutNames(){
        Set<String> calloutNames = new Set<String>();
        calloutNames.add('qweqweqweqwe');
        calloutNames.add('asdasdasd');
        for(JSON_Generator__mdt jsonGenerator: [SELECT Callout_Name__c FROM JSON_Generator__mdt WHERE Is_Disabled__c = false AND Is_Start__c = true]){
            calloutNames.add(jsonGenerator.Callout_Name__c);
        }
        return new List<String>(calloutNames);
    }

    @AuraEnabled
    public static String generateJSON(String calloutName, String whereClause){
        JSONGeneratorHandler jsonHandler = new JSONGeneratorHandler(calloutName, whereClause);
        jsonHandler.isBeautifiedJSON = true;
        jsonHandler.includeNullValues = true;
        return jsonHandler.getJSON();
    }

}