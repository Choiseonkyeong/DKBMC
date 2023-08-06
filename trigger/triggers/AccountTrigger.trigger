/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 05-10-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/

trigger AccountTrigger on Account (after insert, after update, after delete) {
    Set<Id> accountIds = new Set<Id>();
    Map<String, String> accIdMap = new Map<String,String>();
    if(Trigger.isInsert){
        for (Account acc : Trigger.new) {
            accountIds.add(acc.CaccId__C);
            accIdMap.put(acc.CaccId__C , acc.Id);
        }

        if (accountIds.size() > 0) {
            List<Caccount__c> cAccountsToUpdate = [SELECT Id, AccId__c FROM Caccount__c WHERE Id IN :accountIds];
            for (Caccount__c cacc : cAccountsToUpdate) {
                cacc.accId__c = accIdMap.get(cacc.Id);
            }
    
    
            update cAccountsToUpdate;
        }    
    }
    else if(Trigger.isDelete){
        for (Account acc : Trigger.old) {
            accountIds.add(acc.CaccId__C);
        }
    }
   
    
    
}