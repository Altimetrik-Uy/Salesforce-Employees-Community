@isTest
public class LWCEmployeeCareerPathControllerTest {

    public static Employee_Assignment__c returnEmployeeProjectsStructure(Id eAssigmentId){
        //This method return the fields used by the getEmployeeProjects
          return [SELECT Project__r.Id, Project__r.Name FROM Employee_Assignment__c WHERE Id = :eAssigmentId];
     } 

    @isTest(SeeAllData=True)
    public static void sendMessage(){
        User admin = TestDataFactory.createAdminUser();
        Profile pAdmin = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User manager = TestDataFactory.createAdminManagerUser();
        System.runAs(admin){
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User usr = TestDataFactory.createUser(con.Id);
            
         	Id empAssignmentId = TestDataFactory.createDataForTestProjectsTab('O1',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id projectId = [SELECT Id, Name FROM Opportunity WHERE Name = 'O1' LIMIT 1].Id;
            Managers_Assignment__c mA1 = TestDataFactory.createManagersAssigment(manager.Id, projectId);
            Managers_Assignment__c mA2 = TestDataFactory.createManagersAssigment(manager.Id, projectId);
           
            List<Employee_Assignment__c> empAssignmentList = new List<Employee_Assignment__c>();
            Employee_Assignment__c eA1 = returnEmployeeProjectsStructure(empAssignmentId);
            eA1.Start_Date__c = date.parse('11/12/2020');
            eA1.End_Date__c = date.parse('11/12/2021');
            update eA1;
            empAssignmentList.add(eA1);
            
            Employee_Status__c eS1 = TestDataFactory.createEmployeeStatus(con.Id,'Red', 'Red');
            eS1.Meeting_Date__c =  date.parse('2/17/2021');
            update eS1;

            List<String> lstManagersId = new List<String>();
            lstManagersId.add(manager.Id);
            
            Test.startTest();
            System.assertEquals(LWCEmployeeCareerPathController.getManager(con.Id), lstManagersId, 'You dont have manager assigned');
            System.assertEquals(LWCEmployeeCareerPathController.getUser(con.Id), 'Test Test' , 'Contact do not match');
     		System.assertEquals(LWCEmployeeCareerPathController.sendMessage(lstManagersId, 'Test Test'), true, 'Message error');  
            Test.stopTest();
        }
    }
}
