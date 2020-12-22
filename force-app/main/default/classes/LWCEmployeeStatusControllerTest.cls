@isTest
public class LWCEmployeeStatusControllerTest {
    
    public static Employee_Assignment__c returnEmployeeProjectsStructure(Id eAssigmentId){
       //This method return the fields used by the getEmployeeProjects
         return [SELECT Project__r.Id, Project__r.Name FROM Employee_Assignment__c WHERE Id = :eAssigmentId];
    } 
    public static Employee_Status__c returnEmployeeStatusesStructure(Id projectId){
       //This method return the fields used by the getEmployeeStatuses
         return [SELECT Status__c, Meeting_Date__c, Comments__c, CreatedBy.Name, Project__r.Name FROM Employee_Status__c WHERE Id = :projectId];
    } 
       
    @isTest
    public static void getEmployeeProjects(){
        //System Admin
    	User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User usr = TestDataFactory.createUser(con.Id);
            Id OppO1Id = TestDataFactory.createDataForTestProjectsTab('O1',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id OppO2Id = TestDataFactory.createDataForTestProjectsTab('O2',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id OppO3Id = TestDataFactory.createDataForTestProjectsTab('O3',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            List<Employee_Assignment__c> empAssignmentList = new List<Employee_Assignment__c>();
           	empAssignmentList.add(returnEmployeeProjectsStructure(OppO1Id));
            empAssignmentList.add(returnEmployeeProjectsStructure(OppO2Id));
            empAssignmentList.add(returnEmployeeProjectsStructure(OppO3Id));
           	System.assertEquals(LWCEmployeeStatusController.getEmployeeProjects(con.Id).get(1).Project__r.Name, empAssignmentList.get(1).Project__r.Name,'One or more Projects do not match');
        }
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
            Id OppO1Id = TestDataFactory.createDataForTestProjectsTab('O1',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id OppO2Id = TestDataFactory.createDataForTestProjectsTab('O2',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id OppO3Id = TestDataFactory.createDataForTestProjectsTab('O3',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            List<Employee_Assignment__c> empAssignmentList = new List<Employee_Assignment__c>();
           	empAssignmentList.add(returnEmployeeProjectsStructure(OppO1Id));
            empAssignmentList.add(returnEmployeeProjectsStructure(OppO2Id));
            empAssignmentList.add(returnEmployeeProjectsStructure(OppO3Id));
        	Employee_Status__c eS1 = TestDataFactory.createEmployeeStatus(con.Id,'Red', 'Red');
            eS1.Project__c = empAssignmentList.get(1).Project__r.Id; 
            update eS1;
            eS1.Meeting_Date__c =  date.parse('2/17/2021');
            List<Employee_Status__c> status = new List<Employee_Status__c>();
			status.add(returnEmployeeStatusesStructure(eS1.Id));
          	System.assertEquals(LWCEmployeeStatusController.getEmployeeStatuses(empAssignmentList.get(1).Project__r.Id, con.Id, false).get(0).Status__c, status.get(0).Status__c, 'One or more Statuses do not match'); 
          	System.assertEquals(LWCEmployeeStatusController.getEmployeeStatuses('000000000000000000', con.Id, true).get(0).Status__c, status.get(0).Status__c, 'One or more Statuses do not match');        
        }
    }
    
    @isTest(SeeAllData=True)
    public static void statusTabTests(){
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
            
         	Id OppO1Id = TestDataFactory.createDataForTestProjectsTab('O1',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id ProjectId = [SELECT Id, Name FROM Opportunity LIMIT 1].Id;
            Managers_Assignment__c mA1 = TestDataFactory.createManagersAssigment(manager.Id, ProjectId);
            Managers_Assignment__c mA2 = TestDataFactory.createManagersAssigment(manager.Id, ProjectId);
           
            List<Employee_Assignment__c> empAssignmentList = new List<Employee_Assignment__c>();
            Employee_Assignment__c eA1 = returnEmployeeProjectsStructure(OppO1Id);
            eA1.Start_Date__c = date.parse('11/12/2020');
            eA1.End_Date__c = date.parse('11/12/2021');
            update eA1;
            System.debug([SELECT Active__c, Start_Date__c, End_Date__c, Project__r.Name, Employee__r.Name FROM Employee_Assignment__c WHERE Employee__c=:con.Id]);
            System.debug(con.Id);
            System.debug(ProjectId);
            empAssignmentList.add(eA1);
            
            Employee_Status__c eS1 = TestDataFactory.createEmployeeStatus(con.Id,'Red', 'Red');
            eS1.Meeting_Date__c =  date.parse('2/17/2021');
            update eS1;

            List<String> lstManagersId = new List<String>();
            lstManagersId.add(manager.Id);
            List<Employee_Status__c> status = new List<Employee_Status__c>();
            status.add(returnEmployeeStatusesStructure(eS1.Id));
 			
            
            Test.startTest();
            System.assertEquals(LWCEmployeeStatusController.getManager(ProjectId), lstManagersId, 'Project Manager do not match');
            System.assertEquals(LWCEmployeeStatusController.getUser(con.Id), 'Test Test' , 'Contact do not match');
     		System.assertEquals(LWCEmployeeStatusController.getProjectActiveStauts(con.Id, ProjectId), true , 'Active do not match');
     		System.assertEquals(LWCEmployeeStatusController.sendMessage(lstManagersId, LWCEmployeeStatusController.getUser(con.Id)), true, 'Message error');  
            Test.stopTest();
            }
        }
}