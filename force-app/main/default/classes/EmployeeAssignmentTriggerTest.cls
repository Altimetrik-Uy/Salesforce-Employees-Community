/**
 * @date 16/06/2020
 * @author Altimetrik
 *
 * Test class for EmployeeAssignmentTrigger
 */
@isTest
public with sharing class EmployeeAssignmentTriggerTest {
    /**
     * @given EmployeeAssignmentTrigger
     * @when Employees are assigned to Projects
     * @then Employees gain access to the Projects they are assigned to
     */
    @isTest
    static void testShareOpportunities() {
        createdTestData();
        List<Contact> employees = getEmployees();
        List<Opportunity> projects = getProjects();

        Test.startTest();
        createEmployeeAssignments(projects, employees);
        Test.stopTest();

        List<OpportunityShare> shareRecords = getManualShareRecords();

        System.assertEquals(10, shareRecords.size(), 'OpportunityShare table should contain 10 new rows.');
    }

    /**
     * @given EmployeeAssignmentTrigger
     * @when Employees are removed from Projects
     * @then Employees access to the Projects are revoked
     */
    @isTest
    static void testRevokeAccessToOpportunities() {
        createdTestData();
        List<Contact> employees = getEmployees();
        List<Opportunity> projects = getProjects();
        
        List<Employee_Assignment__c> assignments = createEmployeeAssignments(projects, employees);

        Test.startTest();
        delete assignments;
        Test.stopTest();

        List<OpportunityShare> shareRecords = getManualShareRecords();

        System.assert(shareRecords.isEmpty(), 'OpportunityShare table should not contain any manual shared record.');
    }

    private static void createdTestData() {
        Account acc = createAccounts(1, true)[0];
        List<Opportunity> projects = createProjects(5, acc.Id, RecordTypeHelper.PROJECTS.BILLABLE, true);
        List<Contact> employees = createEmployees(5, acc.Id, true);

        List<User> users;
        System.runAs(getAdminUser()) {
            Profile portalProfile = getPortalProfile();
            users = new List<User>{
                new User(
                    ProfileId = portalProfile.Id,
                    FirstName = 'test',
                    LastName = 'last1',
                    Email = 'testUser1@test.com',
                    Username = 'testUser1@test.com' + +System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    ContactId = employees[0].Id,
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    CommunityNickname = 'testUser1',
                    IsActive = true
                ),
                new User(
                    ProfileId = portalProfile.Id,
                    FirstName = 'test',
                    LastName = 'last2',
                    Email = 'testUser2@test.com',
                    Username = 'testUser2@test.com' + +System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    ContactId = employees[1].Id,
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    CommunityNickname = 'testUser2',
                    IsActive = true
                )
            };
            insert users;
        }
    }

    private static List<Account> createAccounts(Integer amount, Boolean doInsert) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < amount; i++) {
            accounts.add(new Account(Name = '[TEST] Account ' + i));
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

    private static List<Contact> createEmployees(Integer amount, Id accountId, Boolean doInsert) {
        List<Contact> employees = new List<Contact>();
        for (Integer i = 0; i < amount; i++) {
            employees.add(new Contact(LastName = '[TEST] Employee ' + i, AccountId = accountId, Email =  i + '@test.com'));
        }

        if (doInsert) {
            insert employees;
        }

        return employees;
    }

    private static List<Employee_Assignment__c> createEmployeeAssignments(List<Opportunity> projects, List<Contact> employees) {
        List<Employee_Assignment__c> assignments = new List<Employee_Assignment__c>();
        for (Opportunity project : projects) {
            for (Contact employee : employees) {
                Employee_Assignment__c assignment = new Employee_Assignment__c(
                    Employee__c = employee.Id,
                    Project__c = project.Id
                );
                assignments.add(assignment);
            }
        }

        insert assignments;

        return assignments;
    }

    /**
     * @return user with profile 'System Administrator'
     */
    private static User getAdminUser() {
        return [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
    }

    private static Profile getPortalProfile() {
        return [SELECT Id FROM Profile WHERE Name = 'Partner Community Login User' LIMIT 1];
    }

    private static List<Contact> getEmployees() {
        return [SELECT Id FROM Contact];
    }

    private static List<Opportunity> getProjects() {
        return [SELECT Id FROM Opportunity];
    }

    private static List<OpportunityShare> getManualShareRecords() {
        return [SELECT Id FROM OpportunityShare WHERE RowCause = :Constants.ROW_CAUSE.MANUAL];
    }
}