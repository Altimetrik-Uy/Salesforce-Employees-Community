@isTest
public with sharing class PathAssistantTest {
    @isTest
    static void dataCareerPathComponent() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'Salesforce Trainee';
            update con;
            User usr = TestDataFactory.createUser(con.Id);
            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id);         
                System.assertEquals(lstWrpcolumns[0].strColumn, '1');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 2);
            }
            Test.stopTest();
        }
    }
}