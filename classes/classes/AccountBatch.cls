/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 05-09-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
global class AccountBatch implements Database.Batchable<Account> {
    global Iterable<Account> start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Type, Rating, Ownership, Industry, Phone, Name, CaccId__c FROM Account';
            
        return (Iterable<Account>)Database.query(query);
    }

global void execute(Database.BatchableContext bc, List<Account> scope) {
        // Get the existing Caccount__c records and map them by AccId__c

        Map<Id, Caccount__c> existingCustomAccounts = new Map<Id, Caccount__c>();
        

        List<Account> orgAccount = [SELECT Id, Type, Rating, Ownership, Industry, Phone, Name, CaccId__c FROM Account WHERE CaccId__c = null AND Sic = null];

        System.debug('새로 생성된 standard' + orgAccount);
        System.debug('새로 생성된 standard size' + orgAccount.size());

        List<caccount__c> createCaccount = new List<caccount__c>();

        for (Account acc : orgAccount) {
            caccount__c cacc = new caccount__c();
            cacc.Name = acc.Name;
            cacc.Type__c = acc.Type != null ? acc.Type : '' ;
            cacc.Rating__c = acc.Rating != null ? acc.Rating : '';
            cacc.Ownership__c = acc.Ownership != null ? acc.Ownership : '';
            cacc.Industry__c = acc.Industry != null ? acc.Industry : '';
            cacc.Phone__c = acc.Phone != null ? acc.Phone : '';
            cacc.AccId__c = acc.Id;

            createCaccount.add(cacc);

        }

        System.debug('새로 생성될 copy' + createCaccount);

        insert createCaccount;



        // Map<List<String>, List<object>> updateAccMapList = new Map<List<String>, List<object>>();
     
        







        Set<String> CheckAccSet = new Set<String>();
       
        //update시에 사용
        Map<String, String> accMap = new Map<String, String>();

        for (Account acc : scope) {
            CheckAccSet.add(acc.Id);
        }

        List<caccount__c> addCaccountList = [SELECT id, accId__c FROM caccount__c];

        //cacc 전체 조회
        // List<caccount__c> addCaccountList = [SELECT id, accId__c FROM caccount__c WHERE accId__c IN :CheckAccSet];
        

        Set<String> deleteCaccId = new Set<String>();


        for (caccount__c cacc : addCaccountList) {
            if (!CheckAccSet.contains(cacc.accId__c)) {
                deleteCaccId.add(cacc.Id);
            }
            //update 시에 사용
            accMap.put(cacc.accId__c, cacc.id);
        }


        //acc와 cacc의 값을 저장하기 위한 map 선언

        // //기준이 될 cacc의 전체 데이터를 map에 저장
        // for (caccount__c cacc : addCaccountList) {
        //     CheckAccMap.put(cacc.accId__c, cacc.Id);
        // }


        // //삭제 시킬 cacc 아이디 저장
        // Set<String> deleteCaccId = new Set<String>();

        // //전체 acc 조회
        // for (Account acc : scope) {
        //     //해당 map에 포함 되어 있지 않는 cacc Id를 찾아서
        //     if (!CheckAccMap.containsKey(acc.Id)) {
        //         deleteCaccId.add(acc.caccId__c);
        //     }
        // }

        system.debug('delete check ' + deleteCaccId);
        List<caccount__c> caccDeleteList = [SELECT id FROM caccount__c WHERE Id  IN :deleteCaccId];

        //삭제
        delete caccDeleteList;

        
        

        List<caccount__c> updateList = new List<caccount__c>();

        for (Account acc : scope) {
            if (accMap.get(acc.Id) == acc.caccId__c) {
                caccount__c caccupdate = new caccount__c();
                caccupdate.Id = acc.caccId__c;
                caccupdate.name = acc.name;
                caccupdate.phone__c = acc.phone;

                updateList.add(caccupdate);
            }
        }

        update updateList;


        /*
        for (Caccount__c c : [SELECT Id, AccId__c FROM Caccount__c]) {
            existingCustomAccounts.put(c.AccId__c, c);
        }
    
        List<Caccount__c> customAccountsToInsert = new List<Caccount__c>();
        List<Caccount__c> customAccountsToUpdate = new List<Caccount__c>();
        List<Caccount__c> customAccountsToDelete = new List<Caccount__c>();
    
        // Create a set to store the AccId__c values of existing Caccount__c records
        Set<Id> existingAccIds = new Set<Id>(existingCustomAccounts.keySet());
    
        for (Account stdAccount : scope) {
            // Account's CaccId__c field is empty or doesn't match the AccId__c value
            if (String.isBlank(stdAccount.CaccId__c) || !existingAccIds.contains(stdAccount.CaccId__c)) {
                // Caccount__c record needs to be created or updated
                Caccount__c customAccount;
    
                if (existingCustomAccounts.containsKey(stdAccount.CaccId__c)) {
                    // Update an existing Caccount__c record
                    customAccount = existingCustomAccounts.get(stdAccount.CaccId__c);
                    customAccount.Type__c = stdAccount.Type;
                    customAccount.Rating__c = stdAccount.Rating;
                    customAccount.Ownership__c = stdAccount.Ownership;
                    customAccount.Industry__c = stdAccount.Industry;
                    customAccount.Phone__c = stdAccount.Phone;
                    customAccount.Name = stdAccount.Name;
                    customAccountsToUpdate.add(customAccount);
                } else {
                    // Check if the AccId__c value is already used in existing Caccount__c records
                    if (!existingAccIds.contains(stdAccount.CaccId__c)) {
                        // Create a new Caccount__c record
                        customAccount = new Caccount__c(
                            AccId__c = stdAccount.CaccId__C,
                            Type__c = stdAccount.Type,
                            Rating__c = stdAccount.Rating,
                            Ownership__c = stdAccount.Ownership,
                            Industry__c = stdAccount.Industry,
                            Phone__c = stdAccount.Phone,
                            Name = stdAccount.Name
                        );
                        customAccountsToInsert.add(customAccount);
    
                        // Add the AccId__c value to the existing AccIds set
                        existingAccIds.add(stdAccount.CaccId__c);
                    }
                }
            }
        }
    
        for (Caccount__c existingCustomAccount : existingCustomAccounts.values()) {
            // Check if the AccId__c value exists in the scope of accounts
            Boolean existsInScope = false;
            for (Account stdAccount : scope) {
                if (stdAccount.CaccId__c == existingCustomAccount.AccId__c) {
                    existsInScope = true;
                    break;
                }
            }

            if (!existsInScope) {
                // Add the existing Caccount__c record to the deletion list
                customAccountsToDelete.add(existingCustomAccount);
            }
        }

        if (!customAccountsToInsert.isEmpty()) {
            insert customAccountsToInsert;
        }
        if (!customAccountsToUpdate.isEmpty()) {
            update customAccountsToUpdate;
        }
        if (!customAccountsToDelete.isEmpty()) {
            delete customAccountsToDelete;
        }
        */
    }


    global void finish(Database.BatchableContext bc) {
        // 배치 작업이 완료될 때 실행되는 로직을 추가합니다.
        // 원하는 완료 로직을 구현하세요.
       
    }

}