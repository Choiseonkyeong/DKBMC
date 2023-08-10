/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 07-11-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
public class AccountDataController {
     
    @AuraEnabled (cacheable=true)
    public static List<Account> fetchAccounts(){
        return [SELECT Id, Name, Type, Phone 
                FROM Account WHERE Type !='' LIMIT 10];       
    }
}