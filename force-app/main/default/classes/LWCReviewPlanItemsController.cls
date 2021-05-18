public class LWCReviewPlanItemsController {
    @AuraEnabled(cacheable=true)
    public static List<Plan_Item__c> getPlanItems(String reviewId){
        List<Plan_Item__c> planItemList = [SELECT Name, State__c, End_Date__c, Plan__c
                                                FROM Plan_Item__c
                                            WHERE Review__r.Id = :reviewId];
            return planItemList;
    }
}
