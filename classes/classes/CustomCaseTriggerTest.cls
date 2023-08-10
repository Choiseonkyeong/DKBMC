/**
 * @description       : 
 * @author            : sunkyung.choi@dkbmc.com
 * @group             : 
 * @last modified on  : 06-30-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
@isTest private class CustomCaseTriggerTest {
    @isTest static void testCustomCaseTrigger() {
        // 사용자 이름을 고유하게 생성하기 위해 날짜와 시간 포맷을 변경합니다.
        Datetime currentTime = Datetime.now();
        String timeStamp = currentTime.format('yyyyMMddHHmmssSSS');

        // 테스트 사용자 생성
        User owner = new User(
            LastName = 'owner',
            Alias = 'owner',  // 필수 필드: Alias
            Email = 'owner' + timeStamp + '@example.com', // 필수 필드: Email
            UserName = 'owner' + timeStamp + '@example.com',
            CommunityNickname = 'owner',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            TimeZoneSidKey = 'GMT', // 필수 필드: TimeZoneSidKey
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id
        );
        insert owner;

        // 다른 테스트 사용자 생성
        User otherUser = new User(
            LastName = 'other',
            Alias = 'other',  // 필수 필드: Alias
            Email = 'other' + timeStamp + '@example.com', // 필수 필드: Email
            UserName = 'other' + timeStamp + '@example.com',
            CommunityNickname = 'other',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            TimeZoneSidKey = 'GMT', // 필수 필드: TimeZoneSidKey
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id
        );
        insert otherUser;

        // 생성한 사용자로 테스트 실행
        Test.startTest();
        System.runAs(owner) {
            // 테스트 수행에 필요한 로직 작성
        }
        Test.stopTest();
    }
}