@isTest
public class ProjectControllerTest {

    /**
     * @given existing Project
     * @when a user retrieves Project through Current Projects component
     * @then user should see all his/her Projects with last Status
     */
    @isTest
    static void testProjectWithLastStatusForFirstUser() {
        createTestData();
        String username = 'testUser1@test.com';
        User firstUser = getUserByUsername(username+'%');
        
        List<ProjectController.ProjectWrapper> projects;
        Test.startTest();
        System.runAs(firstUser) {
            projects = ProjectController.getProjectWithLastStatus();
        }
        Test.stopTest();
        
        System.assertEquals(3, projects.size(), 'First user should see 3 projects');
    }
    
    /**
     * @given existing Project
     * @when a user retrieves Project through Current Projects component
     * @then user should see all his/her Projects with last Status
     */
    @isTest
    static void testProjectWithLastStatusForSecondUser() {
        createTestData();
        String username = 'testUser2@test.com';
        User secondUser = getUserByUsername(username+'%');
        
        List<ProjectController.ProjectWrapper> projects;
        Test.startTest();
        System.runAs(secondUser) {
            projects = ProjectController.getProjectWithLastStatus();
        }
        Test.stopTest();
        
        System.assertEquals(2, projects.size(), 'Second user should see 2 projects');
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
        createProjectStatus(projects);
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
    
    private static void createProjectStatus(List<Opportunity> projects) {
        List<Project_Status__c> projectStatus = new List<Project_Status__c>();

        Integer index = 0;
        for (Opportunity project : projects) {
            if (index == 0 && index != 3) { //make sure some projects show status and some others don't
                projectStatus.add(
                    new Project_Status__c(
                        Project__c = project.Id,
                        Status__c = Constants.PROJECT_STATUS.STATUS_GREEN,
                        Comments__c = '[TEST] Comment',
                        Meeting_Date__c = Date.today()
                    )
                );
            }
            index++;
        }
        
        insert projectStatus;
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
    
    private static List<Project_Status__c> getAllProjectStatus() {
        return [SELECT Id FROM Project_Status__c];
    }
}