@isTest
public class LWCEmployeeProjectsControllerTest {
    
    public static Employee_Assignment__c returnProjectStatusStructure(Id eAssigmentId){
       //This method return the fields used by the getEmployeeProjects
         return [SELECT Project__r.Name, Project__r.End_Date__C, CreatedDate FROM Employee_Assignment__c WHERE Id = :eAssigmentId];
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
            empAssignmentList.add(returnProjectStatusStructure(OppO1Id));
            empAssignmentList.add(returnProjectStatusStructure(OppO2Id));
            empAssignmentList.add(returnProjectStatusStructure(OppO3Id));

            //Run LWCEmployeeProjectsController
            System.assertEquals(LWCEmployeeProjectsController.getEmployeeProjects(con.Id,0).get(1).Project__r.Name, empAssignmentList.get(1).Project__r.Name,'One or more Projects do not match');
        }  
    }

    @isTest
    public static void getEmployeeProjectsOffsetNull(){
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
 			Id OppO2Id = TestDataFactory.createDataForTestProjectsTab('O1',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/22/2021'));
            Id OppO3Id = TestDataFactory.createDataForTestProjectsTab('O2',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            List<Employee_Assignment__c> empAssignmentList = new List<Employee_Assignment__c>();
            empAssignmentList.add(returnProjectStatusStructure(OppO1Id));
            empAssignmentList.add(returnProjectStatusStructure(OppO2Id));
            empAssignmentList.add(returnProjectStatusStructure(OppO3Id));

            //Run LWCEmployeeProjectsController
            System.assertEquals(empAssignmentList.get(0).Project__r.Name, LWCEmployeeProjectsController.getEmployeeProjects(con.Id,null).get(0).Project__r.Name, 'One or more Projects do not match');
        }  
    }

    @isTest
    public static void getEmployeeProjectsCount(){
    	//System Admin
    	User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            Id OppO1Id = TestDataFactory.createDataForTestProjectsTab('O1',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id OppO2Id = TestDataFactory.createDataForTestProjectsTab('O1',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/22/2021'));
            Id OppO3Id = TestDataFactory.createDataForTestProjectsTab('O2',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2021'));
            List<Employee_Assignment__c> empAssignmentList = new List<Employee_Assignment__c>();
            empAssignmentList.add(returnProjectStatusStructure(OppO1Id));
            empAssignmentList.add(returnProjectStatusStructure(OppO2Id));
            empAssignmentList.add(returnProjectStatusStructure(OppO3Id));

            //Run LWCEmployeeProjectsController
            System.assertEquals(2, LWCEmployeeProjectsController.getEmployeeProjectsCount(con.Id));
        }  
    }
}