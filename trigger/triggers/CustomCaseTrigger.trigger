/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 08-02-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
trigger CustomCaseTrigger on CopyCase__c (before update,after delete) {
    // switch on trigger.operationType {
    //     when BEFORE_UPDATE {
    //         updateCheck(Trigger.new, Trigger.oldMap); // 수정 시엔 updateCheck 호출
    //     }
    //     when AFTER_DELETE {
    //         handleAfterDelete(Trigger.old);
    //     }
    // }
    
    // private static void updateCheck(List<CopyCase__c> newCases, Map<Id, CopyCase__c> oldCasesMap) {
    //     for(CopyCase__c caseRecord : newCases) {
    //         Id recordOwnerId = caseRecord.OwnerId;
    //         System.debug('recordOwnerId????'+ recordOwnerId);
    //         Id currentUserId = UserInfo.getUserId();
    //         System.debug('currentUserId????'+ currentUserId);
    //         if(recordOwnerId != currentUserId) { // 소유자가 아닌 경우
    //             // 팀 멤버를 조회한다
    //             List<CopyCaseTeamMember__c> teamMembers = [
    //                 SELECT User__c
    //                 FROM CopyCaseTeamMember__c
    //                 WHERE CopyCase__c = :caseRecord.Id
    //             ];
    //             Boolean isTeamMember = false;

    //             for(CopyCaseTeamMember__c member : teamMembers) {
    //                 if(member.User__c == currentUserId) {
    //                     isTeamMember = true;
    //                     break;
    //                 }
    //             }

    //             if(!isTeamMember) { // 팀 멤버가 아닌 경우
    //                 CopyCase__c oldCase = oldCasesMap.get(caseRecord.Id); // 이전 레코드 가져오기
    //                 caseRecord.Name = oldCase.Name; // 변경 사항 되돌리기
    //                 caseRecord.Description__c = oldCase.Description__c;
    //                 // 여기에 다른 필드 초기화 추가하기

    //                 // 오류 메시지를 표시한다
    //                 caseRecord.addError('Only Owner and Team Members can edit this record');

    //             }
    //         }
    //     }
    // }
    // private static void handleAfterDelete(List<CopyCase__c> deletedCases) {
    //     Set<Id> caseIds = new Set<Id>();
    //     System.debug('handleAfterDelete method is called');
    
    //     for (CopyCase__c caseRecord : deletedCases) {
    //         caseIds.add(caseRecord.Id);
    //     }
    
    //     List<CopyCase__Share> caseSharesToDelete = [SELECT Id, UserOrGroupId, ParentId FROM CopyCase__Share WHERE ParentId IN :caseIds];
    
    //     List<CopyCase__Share> caseSharesToDeleteFiltered = new List<CopyCase__Share>();
    
    //     for (CopyCase__Share share : caseSharesToDelete) {
    //         for (CopyCaseTeamMember__c teamMember : [SELECT Id, User__c FROM CopyCaseTeamMember__c WHERE CopyCase__c = :share.ParentId]) {
    //             if (teamMember.User__c == share.UserOrGroupId || teamMember.User__c == share.UserOrGroupId.getSObjectType().getDescribe().getKeyPrefix()) {
    //                 caseSharesToDeleteFiltered.add(share);
    //                 System.debug('Share added to caseSharesToDeleteFiltered: ' + share.Id);
    //                 break;
    //             }
    //         }
    //     }
    
    //     if (!caseSharesToDeleteFiltered.isEmpty()) {
    //         System.debug('caseSharesToDeleteFiltered size: ' + caseSharesToDeleteFiltered.size());
    //         delete caseSharesToDeleteFiltered;
    //     } else {
    //         System.debug('caseSharesToDeleteFiltered is empty');
    //     }
    // }
    
    
}