@isTest
public class EmployeeControllerTest {
    
    /**
     * @given existing Employee
     * @when a user retrieves Employee through Current Employees component
     * @then user should see all his/her Employees with last Status
     */
    @isTest
    static void testEmployeeWithLastStatusForFirstUser() {
        createTestData();
        String username = 'testUser1@test.com';
        User firstUser = getUserByUsername(username+'%');
        
        List<EmployeeController.EmployeeWrapper> employees;
        Test.startTest();
        System.runAs(firstUser) {
            employees = EmployeeController.getEmployeeWithLastStatus();
        }
        Test.stopTest();
        
        System.assertEquals(3, employees.size(), 'First user should see 3 employees');
    }
    
    /**
     * @given existing Employee
     * @when a user retrieves Employee through Current Employees component
     * @then user should see all his/her Employees with last Status
     */
    @isTest
    static void testEmployeeWithLastStatusForSecondUser() {
        createTestData();
        String username = 'testUser2@test.com';
        User secondUser = getUserByUsername(username+'%');
        
        List<EmployeeController.EmployeeWrapper> employees;
        Test.startTest();
        System.runAs(secondUser) {
            employees = EmployeeController.getEmployeeWithLastStatus();
        }
        Test.stopTest();
        
        System.assertEquals(2, employees.size(), 'Second user should see 2 employees');
    }
    
    private static void createTestData() {
        List<User> users;
        System.runAs(getAdminUser()) {
            users = new List<User>{
                new User(
                    ProfileId = [SELECT Id FROM Profile LIMIT 1].Id,
                    FirstName = 'test',
                    LastName = 'last1',
                    Email = 'testUser1@test.com',
                    Username = 'testUser1@test.com' + + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US'
                ),
                new User(
                    ProfileId = [SELECT Id FROM Profile LIMIT 1].Id,
                    FirstName = 'test',
                    LastName = 'last2',
                    Email = 'testUser2@test.com',
                    Username = 'testUser2@test.com' + + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US'
                )
            };
            insert users;
        }
        
        Account acc = createAccounts(1, true)[0];
        List<Opportunity> projects = createProjects(5, acc.Id, RecordTypeHelper.PROJECTS.BILLABLE, true);
        List<Managers_Assignment__c> assignments = createAssignments(users, projects);
        List<Contact> employees = createEmployees(5, acc.Id, true);
        createEmployeeAssignments(projects, employees);
        createEmployeeStatus(employees);
    }
    
    private static List<Account> createAccounts(Integer amount, Boolean doInsert) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < amount; i++) {
            accounts.add(
                new Account(Name = '[TEST] Account ' + i)
            );
        }
        
        if (doInsert) {
            insert accounts;
        }
        
        return accounts;
    }
    
    private static List<Opportunity> createProjects(Integer amount, Id accountId, Id recordTypeId, Boolean doInsert) {
        List<Opportunity> projects = new List<Opportunity>();
        for (Integer i = 0; i < amount; i++) {
            projects.add(
                new Opportunity(
                    Name = '[TEST] Project ' + i,
                    RecordTypeId = recordTypeId,
                    AccountId = accountId,
                    CloseDate = Date.today(),
                    StageName = Constants.PROJECTS.STAGE_PROSPECTING
                )
            );
        }
        if (doInsert) {
        	insert projects;
        }
        
        return projects;
    }
    
    private static List<Managers_Assignment__c> createAssignments(List<User> users, List<Opportunity> projects) {
        List<Managers_Assignment__c> assignments = new List<Managers_Assignment__c>();
        Integer index = 0;
        for (Opportunity project : projects) {
            Managers_Assignment__c assignment;
            if (index < 3) {
                assignment = new Managers_Assignment__c(
                    User__c = users[0].Id,
                    Project__c = project.Id
                );
            } else {
                assignment = new Managers_Assignment__c(
                    User__c = users[1].Id,
                    Project__c = project.Id
                );
            }
            assignments.add(assignment);
            index++;
        }
        
        insert assignments;
        return assignments;
    }
    
    private static List<Contact> createEmployees(Integer amount, Id accountId, Boolean doInsert) {
        List<Contact> employees = new List<Contact>();
        for (Integer i = 0; i < amount; i++) {
            employees.add(
                new Contact(
                    LastName = '[TEST] Employee ' + i,
                    AccountId = accountId
                )
            );
        }
        
        if (doInsert) {
            insert employees;
        }
        
        return employees;
    }
    
    private static void createEmployeeAssignments(List<Opportunity> projects, List<Contact> employees) {
        List<Employee_Assignment__c> assignments = new List<Employee_Assignment__c>();
        Integer index = 0;
        for (Opportunity project : projects) {
            Employee_Assignment__c assignment;
            if (index < 3) {
                assignment = new Employee_Assignment__c(
                    Employee__c = employees[index].Id,
                    Project__c = project.Id
                );
            } else {
                assignment = new Employee_Assignment__c(
                    Employee__c = employees[index].Id,
                    Project__c = project.Id
                );
            }
            assignments.add(assignment);
            index++;
        }
        
        insert assignments;
    }
    
    private static void createEmployeeStatus(List<Contact> employees) {
        List<Employee_Status__c> employeeStatus = new List<Employee_Status__c>();
        Integer index = 0;
        for (Contact employee : employees) {
            if (index < 3) {
                employeeStatus.add(
                    new Employee_Status__c(
                        Employee__c = employee.Id,
                        Status__c = Constants.EMPLOYEE_STATUS.STATUS_GREEN,
                        Comments__c = '[TEST] Comment',
                        Certification_Status__c = Constants.EMPLOYEE_STATUS.CERTIFICATION_STATUS_GREEN,
                        Certification_Comments__c = '[TEST] Certification Comment'
                    )
                );
            }
            index++;
        }
        
        insert employeeStatus;
    }
    
    /**
     * @return user with profile 'System Administrator'
     */
    public static User getAdminUser() {
        return [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
    }
    
    private static User getUserByUsername(String username) {
        return [SELECT Id FROM User WHERE Username LIKE :username];
    }

}