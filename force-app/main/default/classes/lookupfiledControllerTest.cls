@isTest
public class lookupfiledControllerTest {
    
    @isTest
    static void testAccountLookupField() {
        createTestData(false);
        List<string> returnFields = new List<string> {'Name'};
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        lookupfieldController.objectDetails details;
        List<Account> accounts;
        List<Account> searchedAccounts;
        List<Account> singleAccount;
        Test.startTest();
        details = lookupfieldController.getObjectDetails('Account');
        accounts = (List<Account>) lookupfieldController.GetRecentRecords('Account', returnFields, 5);
        searchedAccounts = (List<Account>) lookupfieldController.SearchRecords(
            'Account', returnFields, returnFields, '', 'Name', 'ASC', 5, 'CreatedDate > 2001-01-01T00:00:01Z'
        );
        singleAccount = (List<Account>) lookupfieldController.GetRecord('Account', returnFields, acc.Id);
        Test.stopTest();
        
        System.assertEquals('Account', details.label);
        System.assertEquals(1, accounts.size(), 'All Accounts should have been retrieved');
        System.assertEquals(1, accounts.size(), 'All Accounts should have been retrieved');
        System.assertEquals(1, accounts.size(), 'An Account should have been retrieved');
    }
    
    @isTest
    static void testProjectLookupField() {
        createTestData(false);
        List<string> returnFields = new List<string> {'Name', 'CloseDate'};
        Opportunity project = [SELECT Id FROM Opportunity LIMIT 1];
        
        lookupfieldController.objectDetails details;
        List<Opportunity> projects;
        List<Opportunity> searchedProjects;
        List<Opportunity> singleProject;
        
        Test.startTest();
        details = lookupfieldController.getObjectDetails('Opportunity');
        projects = (List<Opportunity>) lookupfieldController.GetRecentRecords('Opportunity', returnFields, 5);
        searchedProjects = (List<Opportunity>) lookupfieldController.SearchRecords('Opportunity', returnFields, returnFields, '', 'Name', 'ASC', 5, 'CreatedDate > 2001-01-01T00:00:01Z');
        singleProject = (List<Opportunity>) lookupfieldController.GetRecord('Opportunity', returnFields, project.Id);
        Test.stopTest();
        
        System.assertEquals('Project', details.label);
        System.assertEquals(5, projects.size(), 'All Projects should have been retrieved');
        System.assertEquals(5, searchedProjects.size(), 'All Projects should have been retrieved');
        System.assertEquals(1, singleProject.size(), 'A Project should have been retrieved');
    }
    
    @isTest
    static void testEmployeeLookupField() {
        createTestData(false);
        List<string> returnFields = new List<string> {'Name'};
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        
        lookupfieldController.objectDetails details;
        List<Contact> employees;
        List<Contact> searchedEmployees;
        List<Contact> singleEmployee;
        
        Test.startTest();
        details = lookupfieldController.getObjectDetails('Contact');
        employees = (List<Contact>) lookupfieldController.GetRecentRecords('Contact', returnFields, 5);
        searchedEmployees = (List<Contact>) lookupfieldController.SearchRecords('Contact', returnFields, returnFields, '', 'Name', 'ASC', 5, 'CreatedDate > 2001-01-01T00:00:01Z');
        singleEmployee = (List<Contact>) lookupfieldController.GetRecord('Contact', returnFields, employee.Id);
        Test.stopTest();
        
        System.assertEquals('Employee', details.label);
        System.assertEquals(3, employees.size(), '3 Employees should have been retrieved');
        System.assertEquals(3, searchedEmployees.size(), '3 Employees should have been retrieved');
        System.assertEquals(1, singleEmployee.size(), 'An Employee should have been retrieved');
    }
    
    private static void createTestData(Boolean withProjectStatus) {
        Account acc = new Account(Name = '[TEST] Account');
        insert acc;
        
        List<Opportunity> projects = new List<Opportunity>();
        for (Integer i = 0; i < 5; i++) {
            projects.add(
                new Opportunity(
                    AccountId = acc.Id,
                    RecordTypeId = RecordTypeHelper.PROJECTS.BILLABLE,
                    Name = '[TEST] Opportunity ' + i,
                    StageName = Constants.PROJECTS.STAGE_PROSPECTING,
                    CloseDate = Date.today()
                )
            );
        }
        
        insert projects;
        
        List<Contact> employees = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            employees.add(
                new Contact(
                    AccountId = acc.Id,
                    LastName = '[TEST] Employee ' + i
                )
            );
        }
        insert employees;
        
        List<Employee_Assignment__c> employeeAssignments = new List<Employee_Assignment__c>();
        for (Integer i = 0; i < 3; i++) {
            employeeAssignments.add(
                new Employee_Assignment__c(
                    Project__c = projects.get(i).Id,
                    Employee__c = employees.get(i).Id
                )
            );
        }
        insert employeeAssignments;
        
        List<Managers_Assignment__c> assignments = new List<Managers_Assignment__c>();
        for (Opportunity project : projects) {
            assignments.add(
                new Managers_Assignment__c(
                    Project__c = project.Id,
                    User__c = UserInfo.getUserId()
                )
            );
        }
        
        insert assignments;
        
        if (withProjectStatus) {
            List<Project_Status__c> projectStatus = new List<Project_Status__c>();
            for (Opportunity project : projects) {
                projectStatus.add(
                    new Project_Status__c(
                        Project__c = project.Id,
                        Status__c = Constants.PROJECT_STATUS.STATUS_GREEN,
                        Comments__c = '[TEST] Comment',
                        Meeting_Date__c = Date.today()
                    )
                );
            }
            
            insert projectStatus;
        }
    }
}