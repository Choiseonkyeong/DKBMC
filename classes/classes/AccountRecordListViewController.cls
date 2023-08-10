/**
 * @description       : 
 * @author            : dawon.kim@dkbmc.com
 * @group             : 
 * @last modified on  : 02-17-2023
 * @last modified by  : dawon.kim@dkbmc.com
**/
public with sharing class AccountRecordListViewController {

    //CHECK :: 왜 객체를 만들어서 하셨을까요? 이유가 있나요?
    //Answer:: 삼성에서 종길 과장님께서 주셨던 과제에 사용했었던 적이 있어서 한번 복습 차 사용해봤습니다. 수정해놓겠습니다.
    // public class getAccountRecord { 
    //     public String Id {get; set;}
    //     public String Name {get; set;}
    //     public String Phone {get; set;}
    //     public String BillingState {get; set;}
    //     public String Type {get; set;}
    // }

    @AuraEnabled
    public static List<Account> getAccountList(){
        List<Account> accountList = [SELECT Id, Name, BillingState, Type, Phone, Site FROM Account];
        
        System.debug('accountList debug ----->' + accountList);
        return accountList;

        // List<getAccountRecord> accountRecordList = new List<getAccountRecord>(); 

        // for(Account acc : accountList){
        //     getAccountRecord ar = new getAccountRecord();
        //     ar.Id = String.valueOf(acc.get('Id'));
        //     ar.Name = String.valueOf(acc.get('Name'));
        //     ar.Phone = String.valueOf(acc.get('Phone'));
        //     if(ar.Phone == 'null'){
        //         ar.Phone = '';
        //     }
        //     ar.BillingState = String.valueOf(acc.get('BillingState'));
        //     if(ar.BillingState == 'null'){
        //         ar.BillingState = '';
        //     }
        //     ar.Type = String.valueOf(acc.get('Type'));
        //     if(ar.Type == 'null'){
        //         ar.Type = '';
        //     }
        //     accountRecordList.add(ar);
        // }

        // System.debug('accountRecordList debug ----->' + accountRecordList);
        
        // return JSON.serialize(accountRecordList);
    }

    @AuraEnabled
    public static void deleteAccountRecord(String recordId){
        System.debug('delete account recordId debug ----->' + recordId);

        Account getDeleteAccount = [SELECT Id, Name, Type, Phone, Site, BillingState FROM Account WHERE Id =: recordId];

        System.debug('delete account record debug ----->' + getDeleteAccount);

        delete getDeleteAccount;
    }
}