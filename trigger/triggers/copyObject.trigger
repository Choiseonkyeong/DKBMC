/**
 * @description       :
 * @author            : sunkyung.choi@dkbmc.com
 * @group             :
 * @last modified on  : 05-24-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/

trigger copyObject on Ccontact__c (after insert, after update, after delete) {
    switch on trigger.operationType {
        when AFTER_INSERT {
            createCheck(Trigger.new);
        }
        when AFTER_UPDATE {
            updateCheck(Trigger.new,Trigger.oldMap);
        }
        when AFTER_DELETE {
            deleteCheck(Trigger.old);
        }
       
    }
    
    private static void createCheck(List<Ccontact__c> copyList) {
        System.debug('createCheck strat>>>>>>>>>> ');
        Set<String> copyname = new Set<String>();
        Set<String> accMap = new Set<String>();
        
        // Ccontact__c Name을 넣어줌 
        for (Ccontact__c copy : copyList) {
            System.debug('copy.ContactId__c => ' + copy.ContactId__c);
            if(copy.ContactId__c == null){
                copyname.add(copy.Name);
                accMap.add(copy.CaccountId__c);
            }
        }

        List<Caccount__c> caccList = [SELECT id,accId__c FROM caccount__c WHERE Id IN: accMap ];
        Map<String, String> caccMap = new Map<String, String>();
        for (Caccount__c cacc: caccList) {
            caccMap.put(cacc.id,cacc.accId__c);
        }

        // 현재 생성된 Ccontact__c data의 정보를 가져와 Contact에 들어가 있는 이름 data와 비교 중복되지 않으면 생성
        List<Contact> newContacts = new List<Contact>();
        for (Ccontact__c c : copyList) {
            System.debug('c.ContactId__c => ' + c.ContactId__c);
            if(c.ContactId__c == null){
                Contact newContact = new Contact(
                    Email = c.Email__c,
                    Phone = c.Phone__c != null ? c.Phone__c : '',
                    LastName = c.Name != null ? c.Name : '',
                    CconId__c = c.Id != null ? c.Id : '',
                    AccountId =  caccMap.get(c.CaccountId__c)
                );
                
                // if (c.CaccountId__c != null) {
                //     String accountId = getMatchingAccountId(c.CaccountId__c);
                //     if (accountId != null) {
                //         newContact.AccountId = accountId;
                //     }
                // }
                
                newContacts.add(newContact);
            }
        }
        
        System.debug('newContacts => ' + newContacts);
        
        if (!newContacts.isEmpty()) {
            insert newContacts;
        }
    }
    private static void updateCheck(List<Ccontact__c> updatedList, Map<Id, Ccontact__c> oldMap) {
        // System.debug('updateCheck start => ' + updatedList);
        Set<Id> copyIds = new Set<Id>();
        for (Ccontact__c cp : updatedList) {
            copyIds.add(cp.Id);
        }
    
        List<Contact> contactsToUpdate = [SELECT Id, LastName, Email, Phone, AccountId, CconId__c FROM Contact WHERE CconId__c IN :copyIds];
    
        List<Contact> contactsToUpdateList = new List<Contact>(); // Added this line
    
        for (Ccontact__c cp : updatedList) {
            Contact contToUpdate = null;
            for (Contact cont : contactsToUpdate) {
                if (cont.CconId__c == cp.Id) {
                    contToUpdate = new Contact(Id = cont.Id); // Create a new instance for each Contact
                    contToUpdate.LastName = cont.LastName;
                    contToUpdate.Email = cont.Email;
                    contToUpdate.Phone = cont.Phone;
                    contToUpdate.AccountId = cont.AccountId;
                    contToUpdate.CconId__c = cont.CconId__c; // Retrieve CconId__c field
                    break;
                }
            }
    
            if (contToUpdate != null) {
                Ccontact__c oldCopy = oldMap.get(cp.Id);
    
                // 필드 비교 및 업데이트
                if (cp.Name != oldCopy.Name) {
                    contToUpdate.LastName = cp.Name != null ? cp.Name : contToUpdate.LastName;
                }
    
                if (cp.Email__c != oldCopy.Email__c) {
                    contToUpdate.Email = cp.Email__c != null ? cp.Email__c : contToUpdate.Email;
                }
    
                if (cp.Phone__c != oldCopy.Phone__c) {
                    contToUpdate.Phone = cp.Phone__c != null ? cp.Phone__c : contToUpdate.Phone;
                }
    
                // CaccountId__c가 변경되었을 때, AccountId__c를 업데이트
                if (cp.CaccountId__c != oldCopy.CaccountId__c) {
                    String accountId = getMatchingAccountId(cp.CaccountId__c);
                    if (accountId != null) {
                        contToUpdate.AccountId = accountId;
                    }
                }
    
                contactsToUpdateList.add(contToUpdate);
            }
        }
    
        if (!contactsToUpdateList.isEmpty()) {
            update contactsToUpdateList;
        }
    }
    
    
    
    
    
    
    private static void deleteCheck(List<Ccontact__c> deletedList) {
        Set<String> deletedIds = new Set<String>();
        
        for (Ccontact__c deleted : deletedList) {
            deletedIds.add(deleted.Id);
        }
        
        List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE CconId__c IN :deletedIds];
        System.debug('삭제>>>>>>>>>>>');
        if (!contactsToDelete.isEmpty()) {
            delete contactsToDelete;
        }
    }
    
    private static String getMatchingAccountId(String accId) {
        String accountId = null;
        
        List<Account> matchingAccounts = [SELECT Id FROM Account WHERE CaccId__c = :accId LIMIT 1];
        if (!matchingAccounts.isEmpty()) {
            accountId = matchingAccounts[0].Id;
        }
        
        return accountId;
    }
}