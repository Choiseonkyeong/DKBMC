/**
 * @description       :
 * @author            : sunkyung.choi@dkbmc.com
 * @group             :
 * @last modified on  : 05-26-2022
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
trigger TriggerEdu on Opportunity(before insert, before update, before delete) {

    switch on Trigger.operationType {
            when BEFORE_INSERT {
                nameCheck(Trigger.new);
            }
            when BEFORE_UPDATE {
                nameCheck(Trigger.new);
                checkUpdate(Trigger.new);
                stageCheck(Trigger.new, Trigger.newMap, Trigger.oldMap);

            }

            when BEFORE_DELETE {
                deleteCheck(Trigger.old);
            }
    }
    private static void nameCheck(List<Opportunity> opptyList) {
        System.debug('nameCheck start....');
        // 1. 중복 체크 하기 위해 SELECT문 검색 이름을 선정
        Set<String> opptyNames = new Set<String>();
        Set<Id> opptyIds = new Set<Id>();
        for (Opportunity oppty : opptyList) {
            opptyNames.add(oppty.Name);
            opptyIds.add(oppty.Id);
        }
        // 2. 선정된 이름으로 데이터 Select
        List<Opportunity> namesOpptyList = [SELECT Id, Name FROM Opportunity WHERE Name IN: opptyNames AND Id NOT IN: opptyIds];

        // name을 담기 위한 리스트 c
        List<String> namesCheckList = new List<String>();
        if (namesOpptyList.size() > 0) {
            System.debug('sizeCheck start....');
            for (Opportunity oppty : namesOpptyList) {
                namesCheckList.add(oppty.Name);
            }
            // 3. 비교
            for (Opportunity oppty : opptyList) {
                if (namesCheckList.contains(oppty.Name)) {
                    // 4. 에러 띄우기 .name,.closeDate 어디에 오류 메시지를 띄울지 선택
                    oppty.addError('Name Check');
                }
            }
        }
    }

    // Stage가 "Need Analysis" 단계로 변경될 때 Amount의 값이 100000이상 입력되어있어야함.
    private static void checkUpdate(List<Opportunity> opptyList) {
        System.debug('checkUpdate start....');
        for (Opportunity oppty : opptyList) {
            if (oppty.StageName == 'Needs Analysis') {
                if (oppty.Amount < 100000 || oppty.Amount == null) {
                    oppty.addError('Amount Value check');
                }
            }
        }
    }
    private static void stageCheck(List<Opportunity> opptyList,Map<Id, Opportunity> newOpptyMap,Map<Id, Opportunity> oldOpptyMap) {
        System.debug('stageCheck start....');
        // stage 단계 map에 저장 
        Map<String, Integer> stageValue = new Map<String, Integer> {
            'Prospecting' => 1,
            'Qualification' => 2,
            'Needs Analysis' => 3,
            'Value Proposition' => 4,
            'Id. Decision Makers' => 5,
            'Perception Analysis' => 6,
            'Proposal/Price Quote' => 7,
            'Negotiation/Review' => 8,
            'Closed Won' => 9,
            'Closed Lost' => 9
        };
        for (Opportunity oppty : opptyList) {
            // 이전 단계로 이동 방지
            if (stageValue.get(newOpptyMap.get(oppty.Id).StageName)<stageValue.get(oldOpptyMap.get(oppty.Id).StageName)) {
                oppty.addError('Unable to stage backwards');
            // 건너뛰어서 진행하는거 방지     
            }else if(stageValue.get(newOpptyMap.get(oppty.Id).StageName)-1 != stageValue.get(oldOpptyMap.get(oppty.Id).StageName)){
                oppty.addError('Stage can move step by step');
            }
        }
    }
    // "Needs Analysis" 이상의 단계로 진행되었을 경우 Record 삭제가 불가능함.
    private static void deleteCheck(List<Opportunity> opptyList) {
        System.debug('deleteCheck start....');
        set<String> stageCheckList = new set<String>();
        stageCheckList.add('Prospecting');
        stageCheckList.add('Qualification');
        for (Opportunity oppty : opptyList) {
            if (!(stageCheckList.contains(oppty.StageName))) {
                oppty.addError('Unable to Delete');
            }
        }
    }
}