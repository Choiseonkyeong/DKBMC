/**
 * @description       : 0
 * @author            : sunkyung.choi@dkbmc.com
 * @group             :
 * @last modified on  : 05-23-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
trigger copyAccountObject on Caccount__c (after insert, after update,after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            createCheck(Trigger.new);
        } else if (Trigger.isUpdate) {
            updateCheck(Trigger.new, Trigger.newMap, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            deleteCheck(Trigger.old);
        }
    }
    
    private static void createCheck(List<Caccount__c> copyList) {
        System.debug('createCheck start....');
        System.debug('createCheck copyList....' + copyList);
        // Set<String> copyNames = new Set<String>();
        // for (Caccount__c copy : copyList) {
        //     copyNames.add(copy.Name);
        // }
        // System.debug('copyNames>>>>>>>'+copyNames);

        List<Account> newAccounts = new List<Account>();
        

        Set<String> batchAccId = new Set<String>();
        Map<String, String> batchAccIdMap = new Map<String, String>();
            
            for (caccount__c cacc : copyList) {
                if (cacc.AccId__c == null) {
                    Account acc = new Account();
                    acc.Name = cacc.Name;
                    acc.caccId__c = cacc.Id;
                    acc.Type = cacc.Type__c != null ? cacc.Type__c : '';
                    acc.Rating = cacc.Rating__c != null ? cacc.Rating__c : '';
                    acc.Ownership = cacc.Ownership__c != null ? cacc.Ownership__c : '';
                    acc.Industry = cacc.Industry__c != null ? cacc.Industry__c : '';
                    acc.Phone = cacc.Phone__c != null ? cacc.Phone__c : '';
                    acc.Website = cacc.Website__c != null ?cacc.Website__c :'';
                    // acc.AnnualRevenue = cacc.AnnualRevenue__c != null ? cacc.AnnualRevenue__c :'';
                    // acc.NumberOfEmployees = cacc.NumberOfEmployees__c != null ?cacc.NumberOfEmployees__c:'';
                    acc.AccountNumber  =cacc.CaccountNumber__c   != null ? cacc.CaccountNumber__c: '';  
                    newAccounts.add(acc);
                }else{
                    System.debug('이거 탐?');
                    batchAccId.add(cacc.AccId__c);
                    batchAccIdMap.put(cacc.AccId__c , cacc.Id);
                }
               
            }
            System.debug('batchAccId ' + batchAccId);
            
            if (newAccounts.size() > 0) {
                insert newAccounts;
            }
            if (batchAccId.size() > 0) {

                List<Account> updateAccList = [SELECT id, caccId__c FROM Account WHERE Id IN :batchAccId];
                for (Account acc : updateAccList) {
                    
                    acc.CaccId__c = batchAccIdMap.get(acc.Id);
                    
                }
                update updateAccList;
            }
    }

    private static void updateCheck(List<Caccount__c> copyList, Map<Id, Caccount__c> newMap, Map<Id, Caccount__c> oldMap) {

        System.debug('updateCheck copyList' + copyList);
        System.debug('updateCheck newMap' + newMap);
        System.debug('updateCheck oldMap' + oldMap);

        Set<Id> copyIds = new Set<Id>();
        for (Caccount__c cp : copyList) {
            copyIds.add(cp.Id);
        }
            
        if (copyIds.size() > 0) {
            
            List<Account> accountsToUpdate = [SELECT Id, CaccId__c, Type, Rating, Ownership, Industry, Phone, Name,Website FROM Account WHERE CaccId__c IN :copyIds];
            // List<Account> accountsToUpdate = [SELECT Id, CaccId__c, Type, Rating, Ownership, Industry, Phone, Name,Website,AnnualRevenue,NumberOfEmployees,AccountNumber FROM Account WHERE CaccId__c IN :copyIds];
        
            List<Account> accountsToUpdateList = new List<Account>(); // Added this line
    
            System.debug('accountsToUpdate' + accountsToUpdate);

            for (Caccount__c cp : copyList) {
                Account acctToUpdate = null;
                for (Account acct : accountsToUpdate) {
                    if (acct.CaccId__c == cp.Id) {
                        acctToUpdate = acct;
                        break;
                    }
                }
                

                System.debug('acctToUpdate' + acctToUpdate);
                if (acctToUpdate != null) {
                    Caccount__c oldCopy = oldMap.get(cp.Id);
        
                    // 필드 비교 및 업데이트
                    if (cp.Type__c != oldCopy.Type__c) {
                        acctToUpdate.Type = cp.Type__c;
                    }
        
                    if (cp.Rating__c != oldCopy.Rating__c) {
                        acctToUpdate.Rating = cp.Rating__c;
                    }
        
                    if (cp.Ownership__c != oldCopy.Ownership__c) {
                        acctToUpdate.Ownership = cp.Ownership__c;
                    }
        
                    if (cp.Industry__c != oldCopy.Industry__c) {
                        acctToUpdate.Industry = cp.Industry__c;
                    }
        
                    if (cp.Phone__c != oldCopy.Phone__c) {
                        acctToUpdate.Phone = cp.Phone__c;
                    }
        
                    if (cp.Name != oldCopy.Name) {
                        acctToUpdate.Name = cp.Name;
                    }  
                    if (cp.Website__c   != oldCopy.Website__c  ) {
                        acctToUpdate.Website  = cp.Website__c;
                    }
                    // if (cp.AnnualRevenue__c   != oldCopy.AnnualRevenue__c  ) {
                    //     acctToUpdate.AnnualRevenue  = cp.AnnualRevenue__c;
                    // }
                    // if (cp.NumberOfEmployees__c  != oldCopy.NumberOfEmployees__c  ) {
                    //     acctToUpdate.NumberOfEmployees  = cp.NumberOfEmployees__c;
                    // }
                    // if (cp.CaccountNumber__c   != oldCopy.CaccountNumber__c  ) {
                    //     acctToUpdate.AccountNumber  = cp.CaccountNumber__c;
                    // }
        
        
                    accountsToUpdateList.add(acctToUpdate);
                }
            }
        

            if (!accountsToUpdateList.isEmpty()) {
                update accountsToUpdateList;
            }
        }
    }

        private static void deleteCheck(List<Caccount__c> copyList) { 

            System.debug('얘도 타나?');
            
            Set<Id> copyIds = new Set<Id>();
            for (Caccount__c cp : copyList) {
                copyIds.add(cp.Id);
            }
        
            List<Account> accountsToDelete = [SELECT Id FROM Account WHERE CaccId__c IN :copyIds];
            System.debug('삭제제제제'+accountsToDelete );
            if (!accountsToDelete.isEmpty()) {
                delete accountsToDelete;
            }
        }
}