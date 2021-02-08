@isTest
public with sharing class SalesforcePathByRoleTest {
<<<<<<< HEAD
    @testSetup static void setupData() {
        Profile p = [Select id from Profile where Name = 'Community Employee Profile' limit 1];

        User user = new User(Alias = 'user', Email='test@test.com', 
                               EmailEncodingKey='UTF-8', LastName='USR RM', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='usr@test.com.aaa');
        insert user;        
    }

    static testMethod void dataCertificationsTableComponent() {
        User usrRunAs = [SELECT ID, Name FROM USER WHERE ALIAS = 'user'];
=======
    static testMethod void dataCertificationsTableComponent() {
>>>>>>> 0fa926657dbbdbc7c8d9d73a8d9050303c8b9e0f
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
<<<<<<< HEAD
        
        List<ta_User_Info__c> lstUserInfo = [SELECT Name, Role__c, Email__c FROM ta_User_Info__c WHERE Email__c = 'test@test.com'];
        ta_User_Info__c objUserInfo = lstUserInfo[0];
=======

        Profile p = [Select id from Profile where Name = 'Community Employee Profile' limit 1];

        User usrRunAs = new User(Alias = 'user', Email='test@test.com', 
                               EmailEncodingKey='UTF-8', LastName='USR RM', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               contactId = objContact.Id,
                               TimeZoneSidKey='America/Los_Angeles', UserName='usr@test.com.aaa');
        insert usrRunAs;  
        
        ta_User_Info__c objUserInfo = new ta_User_Info__c (Name = 'AnyName', 
        Role__c = 'Developer', 
        Email__c = 'test1@test.com');
        insert objUserInfo;
>>>>>>> 0fa926657dbbdbc7c8d9d73a8d9050303c8b9e0f

        ta_Certification__c  objCertification = new ta_Certification__c();
        objCertification.Name = 'Administrator';
        insert objCertification;
        
        ta_User_Certification__c objUserCertification = new ta_User_Certification__c();
        objUserCertification.Certification__c = objCertification.Id;
        objUserCertification.User_Info__c = objUserInfo.Id;
        insert objUserCertification;
        
        Salesforce_Career_Path__c objSfCareerPath = new Salesforce_Career_Path__c();
        objSfCareerPath.Certification__c = objCertification.Id;
        objSfCareerPath.Role__c = 'Salesforce Trainee';
        objSfCareerPath.Possible_Next_Role__c = 'Salesforce Developer; Salesforce Apex Specialist';
        objSfCareerPath.Required__c = true;
        insert objSfCareerPath;

        Salesforce_Career_Path__c objSfCareerPath2 = new Salesforce_Career_Path__c();
        objSfCareerPath2.Certification__c = objCertification.Id;
        objSfCareerPath2.Role__c = 'Salesforce Trainee';
        objSfCareerPath2.Possible_Next_Role__c = 'Salesforce Developer; Salesforce Apex Specialist';
        objSfCareerPath2.Required__c = false;
        insert objSfCareerPath2;

        Salesforce_Career_Path__c objSfCareerPath3 = new Salesforce_Career_Path__c();
        objSfCareerPath3.Certification__c = objCertification.Id;
        objSfCareerPath3.Role__c = 'Salesforce Developer';
<<<<<<< HEAD
        objSfCareerPath3.Possible_Next_Role__c = 'Salesforce  Apex Specialist';
=======
        objSfCareerPath3.Possible_Next_Role__c = 'Salesforce Apex Specialist';
>>>>>>> 0fa926657dbbdbc7c8d9d73a8d9050303c8b9e0f
        objSfCareerPath3.Required__c = true;
        insert objSfCareerPath3;

        Salesforce_Career_Path__c objSfCareerPath4 = new Salesforce_Career_Path__c();
        objSfCareerPath4.Certification__c = objCertification.Id;
        objSfCareerPath4.Role__c = 'Salesforce Developer';
        objSfCareerPath4.Possible_Next_Role__c = 'Salesforce Apex Specialist';
        objSfCareerPath4.Required__c = false;
        insert objSfCareerPath4;

        Salesforce_Career_Path__c objSfCareerPath5 = new Salesforce_Career_Path__c();
        objSfCareerPath5.Certification__c = objCertification.Id;
        objSfCareerPath5.Role__c = 'Salesforce Apex Specialist';
        objSfCareerPath5.Possible_Next_Role__c = 'Salesforce Senior Apex Specialist';
        objSfCareerPath5.Required__c = true;
        insert objSfCareerPath5;

        Salesforce_Career_Path__c objSfCareerPath6 = new Salesforce_Career_Path__c();
        objSfCareerPath6.Certification__c = objCertification.Id;
        objSfCareerPath6.Role__c = 'Salesforce Apex Specialist';
        objSfCareerPath6.Possible_Next_Role__c = 'Salesforce Senior Apex Specialist';
        objSfCareerPath6.Required__c = false;
        insert objSfCareerPath6;

        Test.startTest();
        System.RunAs(usrRunAs){
            List<SalesforcePathByRole.wrpRolesSalesforce> lstWrpRolesSalesforce = (List<SalesforcePathByRole.wrpRolesSalesforce>) SalesforcePathByRole.getSalesforcePath();
            System.assertEquals(lstWrpRolesSalesforce.size(), 3);
        }
        Test.stopTest();
    }
}