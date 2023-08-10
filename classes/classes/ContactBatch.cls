/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 05-09-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
global class ContactBatch implements Database.Batchable<Contact>{
    global Iterable<Contact> start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name, Email, Phone, CconId__c, AccountId FROM Contact';
        return (Iterable<Contact>)Database.query(query);
    }
    global void execute(Database.BatchableContext bc, List<Contact> scope) {
        Map<Id, Ccontact__c> existingcustomContacts = new Map<Id, Ccontact__c>();
        
        
        List<Contact> orgContact = [SELECT Id, Name, LastName,Email, Phone, CconId__c, AccountId FROM Contact WHERE CconId__c = null];
        System.debug('orgContact' + orgContact);
        

        //   Ccontact__c ContactId__c 넣어줌 
        Set<String> accIdSet = new Set<String>();
        System.debug('accIdSet' + accIdSet);

        for ( Contact copy : orgContact) {
            accIdSet.add(copy.AccountId);
        }

        
        Map<String, String> caccMap = new Map<String, String>();
        System.debug('caccMap' + caccMap);
        
        if (accIdSet.size() > 0) {
            List<Account> accList = [SELECT id,CaccId__c FROM Account WHERE Id IN: accIdSet ];
            for (Account ccon: accList) {
                caccMap.put(ccon.id,ccon.CaccId__c);
            }
            System.debug('accList' + accList);
        }
      

        List<Ccontact__c> createCcontact = new List<Ccontact__c>();
        System.debug('createCcontact' + createCcontact);
        
        for (Contact cont : orgContact) {
            Ccontact__c ccon = new Ccontact__c();
            ccon.Name = cont.LastName;
            ccon.Email__c = cont.Email;
            ccon.Phone__c = cont.Phone;
            ccon.ContactId__c = cont.Id;
            if (caccMap.size() > 0) {
                ccon.CaccountId__c   = caccMap.get(cont.AccountId);
            }
                

            createCcontact.add(ccon);

        }

        System.debug('새로 생성될 copy' + createCcontact);

        insert createCcontact;



        Set<String> CheckConSet = new Set<String>();
       
        
        for (Contact con : scope) {
            CheckConSet.add(con.Id);
        }


        //cacc 전체 조회
        // List<caccount__c> addCaccountList = [SELECT id, accId__c FROM caccount__c WHERE accId__c IN :CheckConSet];
        List<Ccontact__c> addCcontactList = [SELECT id, ContactId__c FROM Ccontact__c];

        Set<String> deleteCconId = new Set<String>();


        for (Ccontact__c ccon : addCcontactList) {
            if (!CheckConSet.contains(ccon.ContactId__c)) {
                deleteCconId.add(ccon.Id);
            }
        }


      

        system.debug('delete check ' + deleteCconId);
        List<Ccontact__c> cconDeleteList = [SELECT id FROM Ccontact__c WHERE Id  IN :deleteCconId];

        //삭제
        delete cconDeleteList;

        // List<Ccontact__c> updateList = new List<Ccontact__c>();

        // for (Contact acc : scope) {
        //     if (caccMap.get(acc.Id) == acc.CconId__c) {
        //         Ccontact__c caccupdate = new Ccontact__c();
        //         caccupdate.Id = acc.CconId__c;
        //         caccupdate.name = acc.Name;
        //         caccupdate.phone__c = acc.phone;
        //         caccupdate.CaccountId__c = acc.AccountId;



        //         updateList.add(caccupdate);
        //     }
        // }

        // update updateList;
        

        // for (Ccontact__c cp : [SELECT Id, ContactId__c FROM Ccontact__c ]) {
        //     existingCustomAccounts.put(cp.ContactId__c, cp);
        // }
        // List<Caccount__c> customAccountsToUpdate = new List<Caccount__c>();
        // Set<Id> existingAccIds = new Set<Id>(existingCustomAccounts.keySet());
        // for (Contact stdCont : scope) {
        //     if (existingCustomAccounts.containsKey(stdCont.CconId__c)) {
        //         // Update an existing Caccount__c record
        //         customContact = existingCustomAccounts.get(stdCont.CconId__c);
        //         customContact.Email__c = stdCont.Type;
        //         customContact.Phone__c = stdCont.Rating;
        //         customContact.ContactId__c = stdCont.Rating;
        //         customContact.CaccountId__c  =stdCont.AccountId;
        //         customContact.name = stdCont.Name;
        //         customAccountsToUpdate.add(customContact);
        //     }
        // }
        // if (!customAccountsToUpdate.isEmpty()) {
        //     update customAccountsToUpdate;
        // }

        
    }
    global void finish(Database.BatchableContext bc) {
        
    }
}