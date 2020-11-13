@isTest
public with sharing class PathAssistantTest {
    @testSetup static void setupData() {
        Profile p = [Select id from Profile where Name = 'System Administrator' limit 1];

        User user = new User(Alias = 'user', Email='test@test.com', 
                               EmailEncodingKey='UTF-8', LastName='USR RM', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='usrRM@bradescobatch.com.aaa');
        insert user;        
    }

    static testMethod void dataCareerPathComponent() {
        User usrRM = [SELECT ID, Name FROM USER WHERE ALIAS = 'user'];
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

        Salesforce_Career_Path_Settings__mdt mdtCareerPath1 = new Salesforce_Career_Path_Settings__mdt();
        mdtCareerPath1.MasterLabel = 'Trainee';
        mdtCareerPath1.Position__c = 11;

        Salesforce_Career_Path_Settings__mdt mdtCareerPath2 = new Salesforce_Career_Path_Settings__mdt();
        mdtCareerPath2.MasterLabel = 'Developer';
        mdtCareerPath2.Position__c = 12;
        
        Test.startTest();
        System.RunAs(usrRM){
            PathAssistant.getPath();
        }
        Test.stopTest();
    }
}