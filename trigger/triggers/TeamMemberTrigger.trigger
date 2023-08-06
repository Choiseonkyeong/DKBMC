/**
 * @description       :
 * @author            : sunkyung.choi@dkbmc.com
 * @group             :
 * @last modified on  : 07-05-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
trigger TeamMemberTrigger on CopyCaseTeamMember__c(after insert,after delete ) {
    switch on trigger.operationType {
            when AFTER_INSERT {
                createCheck(Trigger.new);
            }
            when AFTER_DELETE  {
                deleteCheck(Trigger.old);
            }
    }

    private static void createCheck(List<CopyCaseTeamMember__c> newMembers) {
        List<CopyCase__Share> shareList = new List<CopyCase__Share>();

        for (CopyCaseTeamMember__c member : newMembers) {
            // CopyCaseTeamMember__c의 필드 값을 이용하여 CopyCase__Share 레코드를 생성한다
            CopyCase__Share share = new CopyCase__Share();
            share.ParentId = member.CopyCase__c; // CopyCase__c의 Id를 설정한다
            share.UserOrGroupId = member.User__c; // User__c의 Id를 설정한다
            // AccessLevel__c 값을 설정한다
            if (member.AccessLevel__c == 'Read Only') {
                share.AccessLevel = 'Read';
            }else if (member.AccessLevel__c == 'Read/Write') {
                share.AccessLevel = 'Edit';
            }
            // share.RowCause = 'Team member';  RowCause 값을 'Team member'로 설정한다 (원하는 값을 설정할
            // 수 있음)

            shareList.add(share);
        }

        if (!shareList.isEmpty()) {
            insert shareList;
        }
    }
    private static void deleteCheck(List<CopyCaseTeamMember__c> deletedMembers) {
        Set<Id> caseIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
    
        // 삭제된 CopyCaseTeamMember__c 레코드들의 Case Id와 User Id를 수집합니다
        for (CopyCaseTeamMember__c deletedMember : deletedMembers) {
            caseIds.add(deletedMember.CopyCase__c);
            userIds.add(deletedMember.User__c);
        }
    
        // 삭제된 CopyCaseTeamMember__c 레코드와 관련된 CopyCase__Share 레코드를 조회합니다
        List<CopyCase__Share> caseSharesToDelete = [
            SELECT Id
            FROM CopyCase__Share
            WHERE ParentId IN :caseIds AND UserOrGroupId IN :userIds
        ];
    
        // 조회된 CopyCase__Share 레코드들을 삭제합니다
        delete caseSharesToDelete;
    }
    
}