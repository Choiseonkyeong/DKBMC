/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 07-20-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
public with sharing class CopyCaseController {

    @AuraEnabled 
    public static CopyCase__c createCcase(CopyCase__c  ccaseData) {
        try {
            
            System.debug('확인1 + ' + ccaseData);
            // CopyCase__c getValue = (CopyCase__c) JSON.deserialize(ccaseData,CopyCase__c.class);
            
            // customWapper getValue = (customWapper) JSON.deserialize(accountData,customWapper.class);
            
            CopyCase__c newCcase = new CopyCase__c();
            newCcase.Name = ccaseData.Name;
            newCcase.CaccountId__c = ccaseData.CaccountId__c;
            newCcase.Type__c = ccaseData.Type__c;
            newCcase.CopyCaseReason__c = ccaseData.CopyCaseReason__c;
            newCcase.Status__c = ccaseData.Status__c;
            newCcase.Priority__c =ccaseData.Priority__c ;
            newCcase.CcontactPhone__c =ccaseData.CcontactPhone__c ;
            newCcase.CcontactEmail__c = ccaseData.CcontactEmail__c;
            newCcase.CopyCaseOrigin__c= ccaseData.CopyCaseOrigin__c;
            newCcase.Subject__c= ccaseData.Subject__c;

            System.debug('확인 22+ ' + newCcase);
            insert newCcase;
            System.debug('확인 33+ ' + newCcase);
            return newCcase;
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred while creating the Caccount__c record: ' + e.getMessage());
        }
    }
    
    
  
    @AuraEnabled (cacheable=true) 
    public static List<CopyCase__c> getCaseList(String searchValue){
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

    @AuraEnabled 
    public static void deleteCopyCase(String recordId){
        // 삭제할 CopyCase__c 레코드 가져오기
        CopyCase__c copyDeleteList = [SELECT Id FROM CopyCase__c WHERE Id =: recordId];
        
            delete copyDeleteList;
        
    }


    @AuraEnabled 
    public static void updateCopyCase(String jsonStr) {
        System.debug('11111'+ jsonStr);
        // JSON 문자열을 파싱하여 필드 값 추출
        Map<String, Object> fields = (Map<String, Object>) JSON.deserializeUntyped(jsonStr);
        String copyCaseId = (String) fields.get('Id');
        String subject = (String) fields.get('Subject__c');
        System.debug('2222'+ subject);
        String status = (String) fields.get('Status__c');
        System.debug('3333'+status);
        // 필요한 경우 다른 필드 값 추출

        // 업데이트할 CopyCase 레코드 검색
        CopyCase__c copyCase = [SELECT Id, Subject__c, Status__c FROM CopyCase__c WHERE Id = :copyCaseId];
        System.debug('4444'+copyCase);
        // 새로운 값으로 필드 업데이트
        if (subject != null) {
            copyCase.Subject__c = subject;
            System.debug('5555'+copyCase.Subject__c);
        }
        if (status != null) {
            copyCase.Status__c = status;
            System.debug('6666'+copyCase.Status__c);
        }
        System.debug('6677'+copyCase);
        
        // 업데이트된 레코드 저장
        try {
            update copyCase;
            System.debug('7777'+copyCase);
            

            System.debug('Update success! CopyCase: ' + copyCaseId + 'Subject: ' + subject + ', Status: ' + status);

            // 필요한 경우 추가 로직 수행 또는 응답 반환
        } catch (Exception e) {
            // 업데이트 과정에서 발생한 예외 또는 오류 처리
            // 사용자 정의 예외를 발생시키거나 요구에 따라 오류 메시지 반환

            System.debug('Update failed! Error: ' + e.getMessage());
        }
    }
  
    
    @AuraEnabled (cacheable=true) 
    public static Map<String , List<options>> picklistOptions(String recordId) {


        List<String> picklistAPINames = new List<String>();
        Map<String, List<options>> caccPickList = new Map<String,List<options>>();

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
           
            List<String> lableList = new List<String>();

            List<options> apioptions = new List<options>();
            Schema.DescribeFieldResult customFieldDescribe = customObjectDescribe.fields.getMap().get(picklistAPINames[i]).getDescribe();
            // Custom_Field__c 필드의 DescribeFieldResult 객체를 가져옵니다.

            // Custom_Field__c 필드의 Picklist 값을 가져옵니다.
            List<Schema.PicklistEntry> picklistValues = customFieldDescribe.getPicklistValues();

            // 각 Picklist 값을 출력합니다.
            for(Schema.PicklistEntry p : picklistValues) {
                options op = new options(); 
                op.label = p.getValue();
                op.value = p.getValue();
                

                apioptions.add(op);
                System.debug(picklistAPINames[i] +'//' + p.getValue());
                

            }
            caccPickList.put(picklistAPINames[i] , apioptions);

            System.debug('caccPickList : ' + caccPickList);

        }

        return caccPickList;
    }

    public class options {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String value {get; set;}
    }

}