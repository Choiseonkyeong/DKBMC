/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 08-02-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
trigger CaseOwnerTrigger on CaseOwner__c (after update) {
    switch on Trigger.operationType {
        when AFTER_UPDATE {
            updateCheck(Trigger.new, Trigger.newMap, Trigger.oldMap);
        }
    }

    private static void updateCheck(List<CaseOwner__c> newData, Map<Id, CaseOwner__c> newMap, Map<Id, CaseOwner__c> oldMap) {
         System.debug('updateCheck copyList' + newData);
        System.debug('updateCheck newMap' + newMap);
        System.debug('updateCheck oldMap' + oldMap);
        List<CopyCase__c> casesToUpdate = new List<CopyCase__c>();

        

        // CopyCase_c 레코드에서 새 OwnerId를 사용하여 업데이트 수행
    }
}