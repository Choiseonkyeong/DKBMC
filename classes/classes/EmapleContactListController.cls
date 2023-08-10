/**
 * @description       : 
 * @author            : yejoo00.lee@partner.samsung.com
 * @group             : 
 * @last modified on  : 02-08-2023
 * @last modified by  : yejoo00.lee@partner.samsung.com
**/
public with sharing class EmapleContactListController {

    
    @AuraEnabled
    public static List<Contact> getContactList(){

        List<Contact> contactList = [SELECT Id, Name, Phone FROM Contact];

        return contactList;
    }

    /* XXX : 위에 Method로 List를 불러오고 익숙해지시면, sortBy, sortDirection 을 사용해서 lwc 의 list 를 sort 하는 기능 여유되시면*/
    @AuraEnabled
    public static List<Contact> getContactListSorted(String sortBy, String sortDirection){

        List<Contact> contactList = System.Database.query(
            ' SELECT ' +
                ' Id, Name, Phone ' +
            ' FROM Contact' +
            ' ORDER BY ' + sortBy + ' ' + sortDirection
        );

        return contactList;
    }

}