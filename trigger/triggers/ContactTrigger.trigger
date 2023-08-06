/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 05-09-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
trigger ContactTrigger on Contact (after insert, after update) {
    Set<Id> contactIds = new Set<Id>();
    Map<String,String> conIdMap = new Map<String,String>();

    if (Trigger.isInsert ) {
        for (Contact con :  Trigger.new) {
            contactIds.add(con.CconId__c );
            conIdMap.put(con.CconId__c, con.Id);
            
        }
        if (contactIds.size()>0) {
            List<Ccontact__c> conList = [SELECT Id,ContactId__c  FROM Ccontact__c WHERE Id IN : contactIds]; 
            for (Ccontact__c ccon : conList) {
                ccon.ContactId__c = conIdMap.get(ccon.Id);
            }
            update conList;
        }
    } 

    // Contact의 ContactId__c 필드 값이 Ccontact__c 레코드의 Id와 일치하는 Ccontact__c 레코드들을 가져옵니다.
    // List<Ccontact__c> relatedCcontacts = [SELECT Id, ContactId__c FROM Ccontact__c WHERE ContactId__c IN :contactIds];

    // for (Ccontact__c ccon : relatedCcontacts) {
    //     // Ccontact__c 레코드의 ContactId__c 필드 값을 현재 Contact 레코드의 Id로 업데이트합니다.
    //     ccon.ContactId__c = ccon.Id;
    //     ccontactsToUpdate.add(ccon);
    // }

    // if (!ccontactsToUpdate.isEmpty()) {
    //     // Ccontact__c 레코드들을 업데이트합니다.
    //     update ccontactsToUpdate;
    // }
}