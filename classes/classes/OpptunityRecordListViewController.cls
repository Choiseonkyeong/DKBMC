/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-17-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
public with sharing class OpptunityRecordListViewController {
    // @AuraEnabled
    // public static List<Opportunity> getOpptyList(){
    //     List<Opportunity> opptyList = [SELECT Id,Name,AccountId,Account.name,StageName,CloseDate FROM Opportunity];
    //     return opptyList;
    // }      
    // public class getAccountRecord {
    //     public String Id {get;set;}
    //     public String Name {get;set;}
    //     public String Phone {get;set;}
    //     public String BillingState {get;set;}
    //     public String Type {get;set;}
    // }
   



    // @AuraEnabled 
    // public static String getAccountList() {
    //     List<Account> accountList = [SELECT Id,Name,BillingState,Type,Phone
    //     FROM Account];

    //     System.debug('accountList debug ----->' + accountList);

    //     List<getRecord> accountRecordList = new List<getRecord>();

    //     for (Account acc : accountList) {
    //         getRecord ar = new getRecord();
    //         ar.AcctId = String.valueOf(acc.get('Id'));
    //         ar.AcctName = String.valueOf(acc.get('Name'));
    //         ar.Phone = String.valueOf(acc.get('Phone'));
    //         if (ar.Phone == 'null') {
    //             ar.Phone = '';
    //         }
    //         ar.BillingState = String.valueOf(acc.get('BillingState'));
    //         if (ar.BillingState == 'null') {
    //             ar.BillingState = '';
    //         }
    //         ar.Type = String.valueOf(acc.get('Type'));
    //         if (ar.Type == 'null') {
    //             ar.Type = '';
    //         }
    //         accountRecordList.add(ar);
    //     }

    //     System.debug('accountRecordList debug ----->' + accountRecordList);

    //     return JSON.serialize(accountRecordList);
    // }
    @AuraEnabled 
    public static List<getRecord> getOpptyList() {
        List <Opportunity> opptyList = [SELECT Id,Name,AccountId, Account.Name,StageName,CloseDate FROM Opportunity];
        Set<Id> idSet = new Set<Id>();
        
        System.debug('opptyList debug ----->' + opptyList);

        List<getRecord> oppttRecordList = new List<getRecord>();

        //.get < Map 형태에서 쓰는 형태 or 


        for (Opportunity oppty : opptyList) {
            getRecord pty = new getRecord();
            pty.Id = Id.valueOf(oppty.Id);
            pty.Name = String.valueOf(oppty.Name);
            pty.AcctId = String.valueOf(oppty.AccountId);
            pty.StageName = String.valueOf(oppty.StageName);
            pty.CloseDate = String.valueOf(oppty.CloseDate);
            idSet.add(pty.AcctId);
            oppttRecordList.add(pty);
        }
        System.debug('oppttRecordList debug ----->' + oppttRecordList);

        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id,Name FROM Account WHERE id=:idSet]);
        System.debug('accMap debug ----->' + accMap);
        
       for (getRecord grd : oppttRecordList) {
            if (accMap.get(grd.AcctId) !=null) {
                grd.AcctId = accMap.get(grd.AcctId).Id;
                grd.AcctName = accMap.get(grd.AcctId).name;                   
            }
       }
       System.debug('oppttRecordList222 debug ----->' + oppttRecordList);
        return null;
    
    }
   @AuraEnabled
   public static void deleteOppty(String recordId){
        Opportunity getDeleteOppty =[SELECT Id,Name,AccountId,Account.name,StageName,CloseDate FROM Opportunity WHERE Id =: recordId ];
        delete getDeleteOppty;
   }
   @AuraEnabled
   public static List<Opportunity> methodName(String recordId){
    List<Opportunity> aassss = [SELECT Id,Name,AccountId,Account.name,StageName,CloseDate FROM Opportunity];
    return aassss;
   }

   public class getRecord {
        public String Id {get;set;}
        public String Name {get;set;}
        public String AcctId {get;set;}
        public String AcctName {get;set;}
        public String StageName {get;set;}
        public String CloseDate {get;set;}
        public String Phone {get;set;}
        public String BillingState {get;set;}
        public String Type {get;set;}
}
}