@isTest
public class LWCReviewPlanItemsControllerTest {

    @isTest
    public static void getPlanItemsTest(){
        User admin = TestDataFactory.createAdminUser();
        List<Plan_Item__c> planItemList = new List<Plan_Item__c>();
        System.runAs(admin){
        	Account acc = TestDataFactory.createAccount();
           	Contact con = TestDataFactory.createContact(acc.Id);
            User usr = TestDataFactory.createUser(con.Id);
            Opportunity project = TestDataFactory.createOpportunity('Test', acc.Id);
            Review__c review = TestDataFactory.createReview(con.Id, project.Id, 'Open');
            Review__c review2 = TestDataFactory.createReview(con.Id, project.Id, 'Open');
            Plan_Item__c pi1 = TestDataFactory.createPlanItem(review.Id, 'Started', Date.Today());
            Plan_Item__c pi2 = TestDataFactory.createPlanItem(review.Id, 'Started', Date.Today());
            Plan_Item__c pi3 = TestDataFactory.createPlanItem(review.Id, 'Started', Date.Today());
            Plan_Item__c pi4 = TestDataFactory.createPlanItem(review2.Id, 'Started', Date.Today());
            Test.startTest();
            planItemList = LWCReviewPlanItemsController.getPlanItems(review.Id);
            Test.stopTest();
            System.assertEquals(3, planItemList.size(), 'Returned plan items do not match');
        }
    } 
}
