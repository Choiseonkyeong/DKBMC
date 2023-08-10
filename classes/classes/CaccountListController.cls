/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 06-20-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
public with sharing class CaccountListController {
    @AuraEnabled
    public static Caccount__c createAccount(String accountData) {
        try {
            
            System.debug('확인1 + ' + accountData);
            caccount__c getValue = (caccount__c) JSON.deserialize(accountData,caccount__c.class);
            // customWapper getValue = (customWapper) JSON.deserialize(accountData,customWapper.class);
            System.debug('확인2 + ' + getValue);

            Caccount__c newAccount = new Caccount__c();
            newAccount.name = getValue.Name;
            newAccount.Site__c = getValue.Site__c;
            newAccount.Phone__c = getValue.Phone__c;
            newAccount.Fax__c = getValue.Fax__c;
            newAccount.Website__c = getValue.Website__c;
            newAccount.TickerSymbol__c =getValue.TickerSymbol__c ;
            newAccount.NumberOfEmployees__c = Integer.valueOf(getValue.NumberOfEmployees__c);
            newAccount.Sic__c = getValue.Sic__c;
            
            newAccount.Type__c = getValue.Type__c ;
            newAccount.Rating__c = getValue.Rating__c;
            newAccount.Industry__c = getValue.Industry__c;
            newAccount.Ownership__c = getValue.Ownership__c;


            // newAccount.Name = accountData.Name;
                // // Number__c = accountData.Number__c,
                // // Site__c = accountData.Site__c,
                // Phone__c = accountData.Phone,
                // Fax__c= accountData.Fax,
                // Website__c = accountData.Website,
                // TickerSymbol__c = accountData.TickerSymbol,
                // NumberOfEmployees__c = accountData.NumberOfEmployees,
                // Sic__c = accountData.Sic
            

            insert newAccount;


            return newAccount;
            // return newAccount;
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred while creating the Caccount__c record: ' + e.getMessage());
        }
    }


    // @AuraEnabled
    // public static String getDetailId() {
    //     caccount__c newDetail = [SELECT ID FROM caccount__c ORDER BY CreatedDate DESC LIMIT 1];

    //     String recordId = newDetail.Id;

    //  return recordId;
    //  }
     
  
   @AuraEnabled
   public static Caccount__c getAccList(String recordId) {
    System.debug('cacc account recordId debug ----->' + recordId);
    Caccount__c account = [SELECT Id, Name, Owner.name, CaccountNumber__c, 
        Site__c, Type__c, Industry__c,AnnualRevenue__c, 
        Rating__c, Phone__c, Fax__c, Website__c,TickerSymbol__c, 
        Ownership__c, NumberOfEmployees__c, Sic__c
        FROM Caccount__c WHERE Id = :recordId ];
        account.Type__c = account.Type__c ==null? 'None' : account.Type__c;
        account.Rating__c = account.Rating__c ==null? 'None' : account.Rating__c;
        account.Industry__c = account.Industry__c ==null? 'None' : account.Industry__c;
        account.Ownership__c = account.Ownership__c ==null? 'None' : account.Ownership__c;
    return account;
    }
    
    @AuraEnabled
    public static void updateAccList(String recordId,String Namevalue , String Numbervalue, String Sitevalue, String Phonevalue
        , String Faxvalue , String Websitevalue , String TickerSymbolvalue , String NumberOfEmployeesvalue, String Sicvalue,String typeValue,
        String industryValue,String ratingValue, String ownerShipValue) {


            System.debug( 'ratingValue++' + ratingValue );
            System.debug( 'typeValue++' + typeValue );
            System.debug( 'industryValue++' + industryValue );
            System.debug( 'ownerShipValue++' + ownerShipValue );

        Caccount__c account = new Caccount__c();
        account.Id = recordId;
        
        account.Name = Namevalue;
        account.CaccountNumber__c = Numbervalue;
        account.Site__c=Sitevalue;
        account.Phone__c = Phonevalue;
        account.Fax__c = Faxvalue;
        account.Website__c = Websitevalue;
        account.TickerSymbol__c= TickerSymbolvalue;
        // account.NumberOfEmployees__c = Integer.valueOf(NumberOfEmployeesvalue);
        account.Sic__c= Sicvalue;
        account.Type__c = typeValue == 'None' ? '' : typeValue;
        account.Industry__c = industryValue == 'None' ? '' : industryValue;
        account.Rating__c = ratingValue == 'None' ? '' : ratingValue;
        account.Ownership__c = ownerShipValue == 'None' ? '' : ownerShipValue;

      
        update account;
    }




    @AuraEnabled
    public static Map<String , List<options>> picklistOptions(String recordId) {


        List<String> picklistAPINames = new List<String>();
        Map<String, List<options>> caccPickList = new Map<String,List<options>>();

        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Caccount__c.fields.getMap();
        for (Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                picklistAPINames.add(fieldDescribe.getName());
              }
        }

        // Custom_Object__c 오브젝트의 DescribeSObjectResult 객체를 가져옵니다.
        Schema.DescribeSObjectResult customObjectDescribe = Schema.describeSObjects(new List<String>{'caccount__c'})[0];
        
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


    // public class customWapper {
    //     @AuraEnabled
    //     public String Phone {get; set;}
    //     @AuraEnabled
    //     public String Fax {get; set;}
    //     @AuraEnabled
    //     public String Website {get; set;}
    // }


    @AuraEnabled
    public static List<Ccontact__c> caccCconRelatedList(String recordId) {
        system.debug('recordId' + recordId);

        List<Ccontact__c> getCconList = [SELECT  Name, Phone__c,Email__c,Title__c FROM Ccontact__c WHERE CaccountId__c =: recordId];

        system.debug('getCconList' + getCconList);

        return getCconList;

          
    }

    @AuraEnabled
    public static void deleteCcontact(String CconId) {
       
        Ccontact__c deleCcon = [SELECT CaccountId__c FROM Ccontact__c WHERE Id =: CconId];

        delete deleCcon;

    }



}