
@isTest
public class LWCPerformanceEvaluationControllerTest {
    
    public static Employee_Assignment__c returnEmployeeProjectsStructure(Id eAssigmentId){
       //This method return the fields used by the getEmployeeProjects
         return [SELECT Project__r.Id, Project__r.Name FROM Employee_Assignment__c WHERE Id = :eAssigmentId];
    } 
    public static Employee_Status__c returnEmployeeStatusesStructure(Id currentId){
       //This method return the fields used by the getEmployeeStatuses
         return [SELECT Status__c, CreatedDate, Comments__c, CreatedBy.Name FROM Employee_Status__c WHERE Id = :currentId];
    } 
    @isTest
public static void getEmployeeStatuses(){
     //System Admin
    User admin = TestDataFactory.createAdminUser();
    System.runAs(admin){
        //Account
        Account acc = TestDataFactory.createAccount();
        //Contact
        Contact con = TestDataFactory.createContact(acc.Id);
        //User
        User usr = TestDataFactory.createUser(con.Id);
        Id OppO1Id = TestDataFactory.createDataForTestProjectsTab('O1',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'), '');
        Id OppO2Id = TestDataFactory.createDataForTestProjectsTab('O2',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'), '');
        Id OppO3Id = TestDataFactory.createDataForTestProjectsTab('O3',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'), '');
        List<Employee_Assignment__c> empAssignmentList = new List<Employee_Assignment__c>();
           empAssignmentList.add(returnEmployeeProjectsStructure(OppO1Id));
        empAssignmentList.add(returnEmployeeProjectsStructure(OppO2Id));
        empAssignmentList.add(returnEmployeeProjectsStructure(OppO3Id));
        Employee_Status__c eS1 = TestDataFactory.createEmployeeStatus(con.Id,'Red', 'Red'); 
        update eS1;
        List<Employee_Status__c> status = new List<Employee_Status__c>();
        status.add(returnEmployeeStatusesStructure(eS1.Id));

        Test.startTest();
          System.assertEquals(LWCEmployeeStatusController.getEmployeeStatuses(con.Id, 0).get(0).Status__c, status.get(0).Status__c, 'One or more Statuses do not match');         
          LWCPerformanceEvaluationController.getEmployeeReview(con.Id, 'Reviews about me',null);         
          LWCPerformanceEvaluationController.getEmployeeReview(con.Id, 'Reviews done',null);         
          LWCPerformanceEvaluationController.getEmployeeReview(con.Id, 'Reviews to do',null);         
          LWCPerformanceEvaluationController.getEmployeeReviewCount(con.Id, 'Reviews to do');         
          LWCPerformanceEvaluationController.getEmployeeReviewCount(con.Id, 'Reviews done');         
          LWCPerformanceEvaluationController.getEmployeeReviewCount(con.Id, 'Reviews about me');         
        Test.stopTest();
    }
}

@isTest
public static void submittedByEvaluatorTest(){
  //System Admin
  User admin = TestDataFactory.createAdminUser();
  System.runAs(admin) {
      Account acc = TestDataFactory.createAccount();
      Contact con = TestDataFactory.createContact(acc.Id);
      Opportunity project = TestDataFactory.createOpportunity('Test', acc.Id);
      Review__c review = TestDataFactory.createReview(con.Id, project.Id, 'Open');
      Review_Assignment__c reviewAssignment = TestDataFactory.createReviewAssignment(review.Id, con.Id);
      
      Test.startTest();
      LWCPerformanceEvaluationController.updateSubmittedByEvaluator(reviewAssignment.Id);
      Test.stopTest();
      Review_Assignment__c reviewAssignmentUpdate = [ SELECT Submitted_By_Evaluator__c FROM Review_Assignment__c WHERE Id = :reviewAssignment.Id ];
      System.assertEquals(true, reviewAssignmentUpdate.Submitted_By_Evaluator__c);
  }
}


}