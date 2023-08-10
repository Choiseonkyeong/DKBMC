/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 07-11-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
public with sharing class CustomDataTableController {

    @AuraEnabled (cacheable=true) 
    public static CopyCase__c createCcase(String ccaseData) {
        try {
            
            System.debug('확인1 + ' + ccaseData);
            CopyCase__c getValue = (CopyCase__c) JSON.deserialize(ccaseData,CopyCase__c.class);
            // customWapper getValue = (customWapper) JSON.deserialize(accountData,customWapper.class);
            System.debug('확인 2+ ' + getValue);

            CopyCase__c newCcase = new CopyCase__c();
            newCcase.Name = getValue.Name;
            newCcase.CaccountId__c = getValue.CaccountId__c;
            newCcase.Type__c = getValue.Type__c;
            newCcase.CopyCaseReason__c = getValue.CopyCaseReason__c;
            newCcase.Status__c = getValue.Status__c;
            newCcase.Priority__c =getValue.Priority__c ;
            newCcase.CcontactPhone__c =getValue.CcontactPhone__c ;
            newCcase.CcontactEmail__c = getValue.CcontactEmail__c;
            newCcase.CopyCaseOrigin__c= getValue.CopyCaseOrigin__c;
            newCcase.Subject__c= getValue.Subject__c;

            insert newCcase;
            System.debug('newCcase 1+ ' + newCcase);
            return newCcase;
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred while creating the Caccount__c record: ' + e.getMessage());
        }
    }
    
    
  
    @AuraEnabled (cacheable=true) 
    public static List<CopyCase__c> getCopyCaseList(String searchValue){
        if (String.isBlank(searchValue)) {
            List<CopyCase__c> copyList = [SELECT id, name, Subject__c, Status__c, CreatedDate, OwnerId, Owner.Name, CaccountId__c, CaccountId__r.Name FROM CopyCase__c];
            system.debug('copyList ----->' + copyList);
            return copyList;
        } else {
            List<CopyCase__c> copyList = [SELECT id, name, Subject__c, Status__c, CreatedDate, OwnerId, Owner.Name, CaccountId__c, CaccountId__r.Name FROM CopyCase__c WHERE Status__c LIKE :('%' + searchValue + '%') OR Subject__c LIKE :('%' + searchValue + '%') OR name LIKE :('%' + searchValue + '%') ];
            system.debug('copyList ----->' + copyList);
            return copyList;
        }
    }
  
    @AuraEnabled (cacheable=true) 
    public static List<CopyCase__c> getOpenCases() {
        List<CopyCase__c> openCases = [SELECT Id, Name, Subject__c, Status__c, CreatedDate, OwnerId,Owner.Name,CaccountId__c, CaccountId__r.Name FROM CopyCase__c WHERE Status__c != 'Closed'];
        return openCases;
    }
    
    @AuraEnabled (cacheable=true) 
    public static List<CopyCase__c> getClosedCases() {
        List<CopyCase__c> closedCases = [SELECT Id, Name, Subject__c, Status__c, CreatedDate, OwnerId,Owner.Name,CaccountId__c, CaccountId__r.Name FROM CopyCase__c WHERE Status__c = 'Closed'];
        return closedCases;
    }

    @AuraEnabled (cacheable=true) 
    public static void deleteCopyCase(String recordId){
        // 삭제할 CopyCase__c 레코드 가져오기
        List<CopyCase__c> copyDeleteList = [SELECT Id FROM CopyCase__c WHERE Id =: recordId];
        if(!copyDeleteList.isEmpty()){
            delete copyDeleteList;
        }
    }


    @AuraEnabled (cacheable=true) 
    public static void updateCopyCase(String jsonStr) {
        // JSON 문자열을 파싱하여 필드 값 추출
        Map<String, Object> fields = (Map<String, Object>) JSON.deserializeUntyped(jsonStr);
        String copyCaseId = (String) fields.get('Id');
        String subject = (String) fields.get('Subject__c');
        String status = (String) fields.get('Status__c');
        // 필요한 경우 다른 필드 값 추출

        // 업데이트할 CopyCase 레코드 검색
        CopyCase__c copyCase = [SELECT Id, Subject__c, Status__c FROM CopyCase__c WHERE Id = :copyCaseId];

        // 새로운 값으로 필드 업데이트
        if (subject != null) {
            copyCase.Subject__c = subject;
        }
        if (status != null) {
            copyCase.Status__c = status;
        }
        // 업데이트된 레코드 저장
        try {
            update copyCase;

            System.debug('Update success! CopyCase: ' + copyCaseId + 'Subject: ' + subject + ', Status: ' + status);

            // 필요한 경우 추가 로직 수행 또는 응답 반환
        } catch (Exception e) {
            // 업데이트 과정에서 발생한 예외 또는 오류 처리
            // 사용자 정의 예외를 발생시키거나 요구에 따라 오류 메시지 반환

            System.debug('Update failed! Error: ' + e.getMessage());
        }
    }


    @AuraEnabled (cacheable=true) 
    public static List<options> picklistOptions1() {


        List<String> picklistAPINames = new List<String>();
        Map<String, List<options>> caccPickList = new Map<String,List<options>>();
        
        List<options> cCasePicklist = new List<options>();




        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.CopyCase__c.fields.getMap();
        for (Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                picklistAPINames.add(fieldDescribe.getName());
              }
        }

        // Custom_Object__c 오브젝트의 DescribeSObjectResult 객체를 가져옵니다.
        Schema.DescribeSObjectResult customObjectDescribe = Schema.describeSObjects(new List<String>{'CopyCase__c'})[0];
        
        for (Integer i = 0; i < picklistAPINames.size(); i++) {
           
            if (picklistAPINames[i] == 'Status__c') {
                List<String> lableList = new List<String>();

                // List<options> apioptions = new List<options>();
                Schema.DescribeFieldResult customFieldDescribe = customObjectDescribe.fields.getMap().get(picklistAPINames[i]).getDescribe();
                // Custom_Field__c 필드의 DescribeFieldResult 객체를 가져옵니다.
    
                // Custom_Field__c 필드의 Picklist 값을 가져옵니다.
                List<Schema.PicklistEntry> picklistValues = customFieldDescribe.getPicklistValues();
    
                // 각 Picklist 값을 출력합니다.
                for(Schema.PicklistEntry p : picklistValues) {
                    options op = new options(); 
                    op.label = p.getValue();
                    op.value = p.getValue();
                    
    
                    cCasePicklist.add(op);
                    System.debug(picklistAPINames[i] +'//' + p.getValue());
                
                }
            }

          
            // caccPickList.put(picklistAPINames[i] , apioptions);

            System.debug('caccPickList : ' + caccPickList);

        }

        return cCasePicklist;
    }
  

    
    public class options {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String value {get; set;}
    }

    

}