/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 05-06-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
public class AccountTriggerHelper {
    public static Boolean isTriggerExecuting = false;
    
    public static void updateRelatedCaccounts(List<Account> accounts) {
        Set<Id> cAccountIdSet = new Set<Id>();
        for (Account acc : accounts) {
            if (acc.CaccId__c != null) {
                cAccountIdSet.add(acc.CaccId__c);
            }
        }
        
        List<Caccount__c> cAccountsToUpdate = [SELECT Id, AccId__c, Type__c, Rating__c, Ownership__c, Industry__c, Phone__c, Name FROM Caccount__c WHERE Id IN :cAccountIdSet];
        List<Account> accountsToUpdateList = new List<Account>();
        
        for (Caccount__c cAcc : cAccountsToUpdate) {
            for (Account acc : accounts) {
                if (cAcc.Id == acc.CaccId__c) {
                    cAcc.AccId__c = acc.Id;
                    accountsToUpdateList.add(acc);
                    break;
                }
            }
        }
        
        if (!cAccountsToUpdate.isEmpty()) {
            update cAccountsToUpdate;
        }
        
        if (!accountsToUpdateList.isEmpty()) {
            update accountsToUpdateList;
        }
    }
}