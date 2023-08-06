/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 06-29-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
trigger CopyCaseAccessLevel on CopyCaseTeamMember__c (after insert) {
    switch on trigger.operationType {
        when AFTER_INSERT {
            createCheck(Trigger.new);
        }
    }

    private static void createCheck(List<CopyCaseTeamMember__c> copyList) {
        List<CopyCase__Share> sharesToCreate = new List<CopyCase__Share>();

        for (CopyCaseTeamMember__c tm : copyList) {
            CopyCase__Share newShare = new CopyCase__Share();
            // ParentId 설정
            newShare.ParentId = tm.CopyCase__c;
            // UserOrGroupId 설정
            newShare.UserOrGroupId = tm.User__c;
            // AccessLevel 설정 ('Read' 또는 'ReadWrite')
            newShare.AccessLevel = tm.AccessLevel__c == 'Read/Write' ? 'Edit' : 'Read';

            sharesToCreate.add(newShare);
        }

        // 생성할 목록의 데이터를 삽입합니다.
        if (sharesToCreate.size() > 0) {
            insert sharesToCreate;
        }
    }
}