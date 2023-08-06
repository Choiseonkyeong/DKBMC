/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 07-31-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
trigger CopyCaseOwner on CopyCase__c  (before insert,before update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            insertCheck(Trigger.new);
        }
        when BEFORE_UPDATE {
            updateCheck(Trigger.new, Trigger.newMap, Trigger.oldMap);
        }
    }
    
    private static void insertCheck(List<CopyCase__c> newData) {
        System.debug('Trigger.new: ' + newData); 
        Map<String, Id> originmap = new Map<String, Id>();

        List<CaseOwner__c > ownelist = [SELECT Id,  Name, User__c, Origin__c FROM CaseOwner__c ];
        for (CaseOwner__c ow : ownelist) {
            originmap.put(ow.Origin__c, ow.User__c);
        }
        System.debug('originmap: ' + originmap); 
        System.debug('originmap: ' + originmap.get('Email')); 
        
        for (CopyCase__c nw : newData) {
            if (nw.CopyCaseOrigin__c == 'Email') {
                nw.OwnerId = originmap.get('Email');
            }else if(nw.CopyCaseOrigin__c == 'Web'){
                nw.OwnerId = originmap.get('Web');
            }
        }
    }
    private static void updateCheck(List<CopyCase__c> newData, Map<Id, CopyCase__c> newMap, Map<Id, CopyCase__c> oldMap) {
        System.debug('updateCheck copyList' + newData);
        System.debug('updateCheck newMap' + newMap);
        System.debug('updateCheck oldMap' + oldMap);
        Map<String, Id> originmap = new Map<String, Id>();

        List<CaseOwner__c> ownerList = [SELECT Id, Name, User__c, Origin__c FROM CaseOwner__c];
        for (CaseOwner__c owner : ownerList) {
            originmap.put(owner.Origin__c, owner.User__c);
        }
        for (CopyCase__c cc : newData) {
            CopyCase__c oldcc = oldMap.get(cc.Id);
            if (cc.CopyCaseOrigin__c != oldcc.CopyCaseOrigin__c) {
                if (cc.CopyCaseOrigin__c == 'Email') {
                    cc.OwnerId = originmap.get('Email');
                } else if (cc.CopyCaseOrigin__c == 'Web') {
                    cc.OwnerId = originmap.get('Web');
                }
            }
        }
    }
}