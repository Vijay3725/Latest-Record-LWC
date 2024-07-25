public with sharing class StatusCalculator {

    public class StatusCount {
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public Integer count { get; set; }

        public StatusCount(String status, Integer count) {
            this.status = status;
            this.count = count;
        }
    }
    @AuraEnabled(cacheable = true)
    public static List<StatusCount> getStatus(){
        List<Entity__c> allRecords = [
            SELECT Name, Status__c 
            FROM Entity__c 
            ORDER BY Name, CreatedDate DESC];

        Map<String, Entity__c> latestRecordsMap = new Map<String, Entity__c>();

        for (Entity__c record : allRecords) {
            if (!latestRecordsMap.containsKey(record.Name)) {
                latestRecordsMap.put(record.Name, record);
            }
        }

        Map<String, Integer>  statusCounts = new Map<String,Integer>();

        for (Entity__c latestRecord : latestRecordsMap.values()) {
            String status = latestRecord.Status__c;
            if (!statusCounts.containsKey(status)) {
                statusCounts.put(status, 0);
            }
            statusCounts.put(status, statusCounts.get(status) + 1);
        }
        List<StatusCount> result = new List<StatusCount>();
        for (String status : statusCounts.keySet()) {
            result.add(new StatusCount(status, statusCounts.get(status)));
        }
        return result;
    }
}
