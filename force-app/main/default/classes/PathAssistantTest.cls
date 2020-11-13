@isTest
public with sharing class PathAssistantTest {
    @testSetup static void setupData() {
        // Profile p = [Select id from Profile where Name = 'Community Employee Profile' limit 1];
        Profile p = [Select id from Profile where Name = 'System Administrator' limit 1];

        User user = new User(Alias = 'user', Email='test@test.com', 
                               EmailEncodingKey='UTF-8', LastName='USR RM', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='usrRM@bradescobatch.com.aaa');
        insert user;        
    }

    static testMethod void dataCareerPathComponent() {
        User usrRunAs = [SELECT ID, Name FROM USER WHERE ALIAS = 'user'];
        Account objAccount = new Account();
        objAccount.Name = 'Account Test';
        insert objAccount;

        Contact objContact = new Contact();
        objContact.FirstName='Contact';
        objContact.LastName='Test';
        objContact.AccountId = objAccount.Id;
        objContact.Role__c = 'Salesforce Trainee';
        objcontact.Email = 'test@test.com';
        insert objContact;
        
        Test.startTest();
        System.RunAs(usrRunAs){
            List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath();
            System.assertEquals(lstWrpcolumns[0].strColumn, '1');
            System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 2);
        }
        Test.stopTest();
    }
}