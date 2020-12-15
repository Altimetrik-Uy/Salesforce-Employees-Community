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
            eS1.Meeting_Date__c =  date.parse('2/17/2021');
            List<Employee_Status__c> status = new List<Employee_Status__c>();
			status.add(returnEmployeeStatusesStructure(eS1.Id));
            System.debug('eS1.Project__r.Id ' + eS1.Project__r.Id);
            System.assertEquals(LWCEmployeeStatusController.getEmployeeStatuses(eS1.Project__r.Id, con.Id).get(0).Status__c, status.get(0).Status__c, 'One or more Statuses do not match');           
        }
    }
    
    @isTest 
    public static void statusTabTests(){
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User usr = TestDataFactory.createUser(con.Id);
         	Id OppO1Id = TestDataFactory.createDataForTestProjectsTab('O1',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            List<Employee_Assignment__c> empAssignmentList = new List<Employee_Assignment__c>();
            Employee_Assignment__c eA1 = returnEmployeeProjectsStructure(OppO1Id);
            eA1.Start_Date__c = date.parse('11/12/2020');
            eA1.End_Date__c = date.parse('11/12/2021');
            update eA1;
            empAssignmentList.add(eA1);
            Employee_Status__c eS1 = TestDataFactory.createEmployeeStatus(con.Id,'Red', 'Red');
            eS1.Meeting_Date__c =  date.parse('2/17/2021');
            update eS1;
            List<Employee_Status__c> status = new List<Employee_Status__c>();
            status.add(returnEmployeeStatusesStructure(eS1.Id));
            System.assertEquals(LWCEmployeeStatusController.getManager(eS1.Project__r.Id), admin.ID, 'Project Manager do not match');
            System.assertEquals(LWCEmployeeStatusController.getUser(con.Id), 'Test Test' , 'Contact do not match');
            System.assertEquals(LWCEmployeeStatusController.getProjectActiveStauts(con.Id, eS1.Project__r.Id), false , 'Active do not match');
            System.assertEquals(LWCEmployeeStatusController.sendMessage(admin.ID, 'Test Test'), false, 'Message error');  
            }
        }
}