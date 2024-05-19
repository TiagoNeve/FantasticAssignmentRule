public without sharing class CustomLookup {
    @AuraEnabled
    public static List<SObject> searchRecords(String objectName, String searchString) {
        String searchKey = searchString + '%';
        String objectApiName = objectName.toLowerCase();
        List<SObject> records = new List<SObject>();
        
        Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
        
        if (objDescribe.isSearchable()) {

            String soqlQuery = 'SELECT Id, Name FROM ' + objectApiName + ' WHERE Name LIKE \'' + searchKey + '\' LIMIT 5';
            
            records.addAll(Database.query(soqlQuery));
        }
        
        return records;
    }
}