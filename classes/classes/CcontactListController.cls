/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 06-20-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
public with sharing class CcontactListController {

    @AuraEnabled
    public static Ccontact__c createCcont(String cccontData) {
        try {
            
            System.debug('확인1 + ' + cccontData);
            Ccontact__c getValue = (Ccontact__c) JSON.deserialize(cccontData,Ccontact__c.class);
            // customWapper getValue = (customWapper) JSON.deserialize(accountData,customWapper.class);
            System.debug('확인 2+ ' + getValue);

            Ccontact__c newCcont = new Ccontact__c();
            newCcont.Name = getValue.Name;
            newCcont.CaccountId__c = getValue.CaccountId__c;
            newCcont.Title__c = getValue.Title__c;
            newCcont.Department__c = getValue.Department__c;
            newCcont.Birthdate__c = getValue.Birthdate__c;
            newCcont.Phone__c =getValue.Phone__c ;
            newCcont.HomePhone__c =getValue.HomePhone__c ;
            // newCcont.NumberOfEmployees__c = Integer.valueOf(getValue.NumberOfEmployees__c);
            newCcont.Mobile__c = getValue.Mobile__c;
            newCcont.OtherPhone__c = getValue.OtherPhone__c ;
            newCcont.Fax__c = getValue.Fax__c;
            newCcont.Email__c = getValue.Email__c;
            newCcont.Assistant__c = getValue.Assistant__c;
            newCcont.AssistantPhone__c = getValue.AssistantPhone__c;
            newCcont.CaccountId__c = getValue.CaccountId__c;
            insert newCcont;
            System.debug('newCcont 1+ ' + newCcont);
            return newCcont;
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred while creating the Caccount__c record: ' + e.getMessage());
        }
    }
  
    @AuraEnabled
    public static Ccontact__c getCcontList(String recordId){
        System.debug('getCcontList ccont recordId debug ----->' + recordId);
        Ccontact__c ccont = [SELECT 
        id, Owner.name, Salutation__c, Name,CaccountId__c,
        Title__c, Department__c, 
        Birthdate__c, ReportsToId__c, Lead_Source__c, Phone__c, 
        HomePhone__c, Mobile__c, OtherPhone__c, Fax__c, Email__c, 
        Assistant__c, AssistantPhone__c,CaccountId__r.Name FROM Ccontact__c WHERE Id = :recordId ] ;
        ccont.Lead_Source__c = ccont.Lead_Source__c ==null ? 'None' : ccont.Lead_Source__c;
        ccont.Salutation__c = ccont.Salutation__c ==null ? 'None' : ccont.Salutation__c;

        return ccont;
    }

     @AuraEnabled
     public static void updateAccList(String recordId, String lastNameValue,String firstNameValue,
     string caccountNameValue ,String titleValue, String deparValue, String reportValue , 
     String phoneValue , String homePhoneValue , String mobileValue, String otherPhoneValue,
     String faxValue,String emailValue,String assistantValue,String assPhoneValue, String caccountId ) {
        System.debug(' update' +recordId);
        System.debug(' update phoneValue' +phoneValue);
        
         Ccontact__c ccont = new Ccontact__c();
        //  Caccount__c cacc= [SElect id,name FROM Caccount__c WHERE id = ccont.CaccountId__c];
         ccont.Id = recordId;
        //  ccont.Name = firstNameValue;
         ccont.Name = lastNameValue;
         ccont.Title__c = titleValue;
         ccont.Department__c=deparValue;
        //  ccont.ReportsToId__c = reportValue;
         ccont.Phone__c = phoneValue;
         ccont.HomePhone__c	 = homePhoneValue;
        //  ccont.CaccountId__c = caccountNameValue;
         ccont.Mobile__c = mobileValue;
         ccont.OtherPhone__c= otherPhoneValue;
          ccont.Fax__c = faxValue;
         ccont.Email__c= emailValue;
         ccont.Assistant__c= assistantValue;
         ccont.AssistantPhone__c= assPhoneValue;
         ccont.caccountId__c = caccountId;
         
         update ccont;
         
     }

   

     @AuraEnabled
     public static Map<String , List<options>> picklistOptions(String recordId) {
         List<String> picklistAPINames = new List<String>();  // 필드의 API 이름을 저장하는 리스트
         Map<String, List<options>> caccPickList = new Map<String,List<options>>();  // 필드의 API 이름과 해당 필드의 Picklist 값들을 저장하는 맵
         Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Ccontact__c.fields.getMap();  // Ccontact__c 오브젝트의 필드 맵을 가져옴
     
         for (Schema.SObjectField field : fieldMap.values()) {  // 필드 맵의 각 필드에 대해 반복
             Schema.DescribeFieldResult fieldDescribe = field.getDescribe();  // 필드의 DescribeFieldResult를 가져옴
             if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {  // 필드의 타입이 Picklist인지 확인
                 picklistAPINames.add(fieldDescribe.getName());  // Picklist 필드의 API 이름을 리스트에 추가
             }
         }
     
         // Custom_Object__c 오브젝트의 DescribeSObjectResult 객체를 가져옴
         Schema.DescribeSObjectResult customObjectDescribe = Schema.describeSObjects(new List<String>{'Ccontact__c'})[0];
         
         for (Integer i = 0; i < picklistAPINames.size(); i++) {  // picklistAPINames 리스트의 각 요소에 대해 반복
            
            //  List<String> lableList = new List<String>(); 
     
             List<options> apioptions = new List<options>();  // options 객체의 리스트
             Schema.DescribeFieldResult customFieldDescribe = customObjectDescribe.fields.getMap().get(picklistAPINames[i]).getDescribe();  // Custom_Field__c 필드의 DescribeFieldResult를 가져옴
     
             // Custom_Field__c 필드의 Picklist 값을 가져옴
             List<Schema.PicklistEntry> picklistValues = customFieldDescribe.getPicklistValues();
     
             // 각 Picklist 값을 출력함
             for(Schema.PicklistEntry p : picklistValues) {
                 options op = new options(); 
                 op.label = p.getValue();
                 op.value = p.getValue();
                 apioptions.add(op);  // options 객체를 리스트에 추가
                 System.debug(picklistAPINames[i] +'//' + p.getValue());  // API 이름과 Picklist 값 출력
             }
     
             caccPickList.put(picklistAPINames[i] , apioptions);  // 필드의 API 이름과 options 리스트를 caccPickList 맵에 추가
             System.debug('caccPickList : ' + caccPickList);  // caccPickList 맵 출력
         }
     
         return caccPickList;  // caccPickList 맵 반환
     }
     

     @AuraEnabled
     public static void isnertccont(String jsonStr, String recordId) {
         List<Ccontact__c> newRecord = (List<Ccontact__c>) JSON.deserialize(jsonStr, List<Ccontact__c>.class);
        //  Set<String> existingNames = new Set<String>();
      
        System.debug('newRecord : ' + newRecord);

        List<Ccontact__c> newCconList = new List<Ccontact__c>();
        for (Ccontact__c ccon : newRecord) {
            if (ccon.Name != null) {
                newCconList.add(ccon);
            }
        }

        insert newCconList;

        //  // 기존에 존재하는 이름을 Set에 저장
        //  for (Ccontact__c existingRecord : [SELECT Name FROM Ccontact__c]) {
        //      existingNames.add(existingRecord.Name);
        //  }
     
        //  List<Ccontact__c> validRecords = new List<Ccontact__c>();
     
        //  // 중복 데이터를 걸러내고 유효한 데이터만 추가
        //  for (Ccontact__c newRecord : newRecords) {
        //      if (!existingNames.contains(newRecord.Name) && !String.isBlank(newRecord.Name)) {
        //          validRecords.add(newRecord);
        //          existingNames.add(newRecord.Name); // 새로운 이름 추가
        //      }
        //  }
     
        //  if (!validRecords.isEmpty()) {
        //      insert validRecords;
        //  }
     }
     
     @AuraEnabled
     public static void updateccont(String jsonStr) {
        List<Ccontact__c> upRecords = (List<Ccontact__c>) JSON.deserialize(jsonStr, List<Ccontact__c>.class);
        
        System.debug('upRecords : ' + upRecords);
        List<Ccontact__c> newCconList = new List<Ccontact__c>();
        for (Ccontact__c ccon : upRecords) {
            if (ccon.Id != null) {
                newCconList.add(ccon);
            }
        }

        update newCconList;

     }


    @AuraEnabled
    public static void deleteCcont(List<String> caccId){
        
        System.debug('caccId check ' + caccId );
        System.debug('deleteCcont start ' );
        List<Ccontact__c > ccontList = [SELECT Id,Name FROM Ccontact__c WHERE id =: caccId];
        System.debug('ccontList check ' +ccontList );
        if (!ccontList.isEmpty()) {
            System.debug('ccontList : >>'+ ccontList );
            delete ccontList;
        }
    }
    public class options {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String value {get; set;}
    }
}