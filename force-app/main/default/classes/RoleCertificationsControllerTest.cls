@isTest
public with sharing class RoleCertificationsControllerTest {

    @TestSetup
    static void setup(){

        Contact testCont = new Contact();
        testCont.FirstName = 'FirstName 1';
        testCont.LastName = 'LastName 1';
        testCont.Email = 'test@testemail.com';
        testCont.Role__c = 'Developer';
        insert testCont;

        List<ta_Certification__c> testCertificationList = new List<ta_Certification__c>();
        ta_Certification__c testCertification = new ta_Certification__c();
        testCertification.Name = 'app builder';
        testCertificationList.add(testCertification);
        insert testCertificationList;

        ta_User_Info__c uInfoList = new ta_User_Info__c();
        uInfoList.Name = 'Test User Info';
        uInfoList.Email__c = 'test@testemail.com';
        uInfoList.Role__c = 'Developer';
        insert uInfoList;

        ta_User_Certification__c testUserCertification = new ta_User_Certification__c();
        testUserCertification.Certification__c = testCertification.Id;
        testUserCertification.User_Info__c = uInfoList.Id;
        insert testUserCertification;

        List<Salesforce_Career_Path__c> testPAthList = new List<Salesforce_Career_Path__c>();
        Salesforce_Career_Path__c testPath1 = new Salesforce_Career_Path__c();
        testPath1.Certification__c = testCertification.Id;
        testPath1.Role__c = 'Developer';
        testPath1.Possible_Next_Role__c = 'Salesforce Apex Specialist';
        testPath1.Required__c = true;
        testPathList.add(testPath1);
        Salesforce_Career_Path__c testPath2 = new Salesforce_Career_Path__c();
        testPath2.Certification__c = testCertification.Id;
        testPath2.Role__c = 'Salesforce Apex Specialist';
        testPath2.Possible_Next_Role__c = 'Salesforce Lightning Specialist';
        testPath2.Required__c = true;
        testPathList.add(testPath2);
        insert testPathList;

        
    
    }

    @isTest 
    static void noUserTest() {
        
        List<RoleCertificationsController.rolesCertificacionesWrapper> wrapperResultList;
        
        Test.startTest();
            wrapperResultList = RoleCertificationsController.getPercentages('1111111111111111111');
        Test.stopTest();
        System.assertEquals('No user record is associated with this contact.',wrapperResultList[0].role);
    }

    @isTest 
    static void noContactRoleTest() {
        
        List<RoleCertificationsController.rolesCertificacionesWrapper> wrapperResultList;

        List<Contact> contactList = [
            SELECT Id,
            Role__c
            FROM Contact
            WHERE Email = 'test@testemail.com'
            LIMIT 1];
        contactList[0].Role__c = null;
        update contactList;

        Test.startTest();
            wrapperResultList = RoleCertificationsController.getPercentages('*'+contactList[0].Id);
        Test.stopTest();
        
        System.assertEquals('Verify that the Email or Role fields have valid information.',wrapperResultList[0].role);
    }

    @isTest 
    static void noUserInfoTest() {
        
        List<RoleCertificationsController.rolesCertificacionesWrapper> wrapperResultList;

        List<Contact> contactList = [
            SELECT Id
            FROM Contact
            WHERE Email = 'test@testemail.com'
            LIMIT 1];

        List<ta_User_Certification__c> testUserCertificationList = [
            SELECT Id,
            User_Info__c
            FROM ta_User_Certification__c
            WHERE User_Info__r.Email__c = 'test@testemail.com'
            LIMIT 1];

        testUserCertificationList[0].User_Info__c = null;
        update testUserCertificationList;

        Test.startTest();
            wrapperResultList = RoleCertificationsController.getPercentages('*'+contactList[0].Id);
        Test.stopTest();
     
        System.assertEquals(false,wrapperResultList[0].trailblazerId);
    }

    @isTest 
    static void noCertificationsTest() {
        
        List<RoleCertificationsController.rolesCertificacionesWrapper> wrapperResultList;

        List<Contact> contactList = [
            SELECT Id
            FROM Contact
            WHERE Email = 'test@testemail.com'
            LIMIT 1];

        List<ta_User_Certification__c> testUserCertificationList = [
            SELECT Id,
            Certification__c
            FROM ta_User_Certification__c
            WHERE User_Info__r.Email__c = 'test@testemail.com'
            LIMIT 1];
        testUserCertificationList[0].Certification__c = null;
        update testUserCertificationList;

        List<ta_User_Info__c> userInfo = [
            SELECT Id,
            Role__c,
            TrailBlazerId__c
            FROM ta_User_Info__c
            WHERE Email__c = 'test@testemail.com'
            LIMIT 1
        ];
        userInfo[0].Role__c = 'Manager';
        userInfo[0].TrailBlazerId__c = 'trailId';
        update userInfo;

        Test.startTest();
            wrapperResultList = RoleCertificationsController.getPercentages('*'+contactList[0].Id);
        Test.stopTest();
     
        System.assertEquals(0,wrapperResultList[0].porcentaje);
    }

    @isTest 
    static void successfullTest() {
        
        List<RoleCertificationsController.rolesCertificacionesWrapper> wrapperResultList;

        List<Contact> contactList = [
            SELECT Id,
            Role__c
            FROM Contact
            WHERE Email = 'test@testemail.com'
            LIMIT 1];

            List<ta_User_Info__c> userInfo = [
            SELECT Id,
            TrailBlazerId__c
            FROM ta_User_Info__c
            WHERE Email__c = 'test@testemail.com'
            LIMIT 1
        ];
        userInfo[0].TrailBlazerId__c = 'trailId';
        update userInfo;

        Test.startTest();
            wrapperResultList = RoleCertificationsController.getPercentages('*'+contactList[0].Id);
        Test.stopTest();

        System.assertEquals('Developer',wrapperResultList[0].role);
        System.assertEquals(100,wrapperResultList[0].porcentaje);
        System.assertEquals('Salesforce Apex Specialist',wrapperResultList[1].role);
    }

    @isTest 
    static void successAddCurrentRole() {
        Integer randomNumber = Integer.valueof((Math.random() * 100));

        List<RoleCertificationsController.rolesCertificacionesWrapper> wrapperResultList;
        String mail  = 'testxyz'+randomNumber+'@testemail.com';

        Contact testCont2 = new Contact();
        testCont2.FirstName = 'FirstName 2';
        testCont2.LastName = 'LastName 2';
        testCont2.Email = mail;
        testCont2.Role__c = 'Salesforce Trainee';
        insert testCont2;
        
        List<ta_User_Info__c> userInfo = [
            SELECT Id,
            TrailBlazerId__c
            FROM ta_User_Info__c
            WHERE Email__c = :mail
            LIMIT 1
        ];
        userInfo[0].TrailBlazerId__c = 'trailId';
        update userInfo;

        List<ta_Certification__c> testCertificationList = new List<ta_Certification__c>();
        ta_Certification__c testCertification = new ta_Certification__c();
        testCertification.Name = 'Administrator';
        testCertificationList.add(testCertification);
        ta_Certification__c testCertification2 = new ta_Certification__c();
        testCertification2.Name = 'Administrator 2';
        testCertificationList.add(testCertification2);
        insert testCertificationList;

        List<ta_User_Certification__c> certifications = new List<ta_User_Certification__c>();
        ta_User_Certification__c testUserCertification = new ta_User_Certification__c();
        testUserCertification.Certification__c = testCertification.Id;
        testUserCertification.User_Info__c = userInfo[0].Id;
        certifications.add(testUserCertification);
        insert certifications;

        List<Salesforce_Career_Path__c> testPAthList = new List<Salesforce_Career_Path__c>();
        Salesforce_Career_Path__c testPath1 = new Salesforce_Career_Path__c();
        testPath1.Certification__c = testCertification2.Id;
        testPath1.Role__c = 'Salesforce Trainee';
        testPath1.Possible_Next_Role__c = 'Salesforce Apex Specialist';
        testPath1.Required__c = false;
        testPathList.add(testPath1);
        
        Salesforce_Career_Path__c testPath2 = new Salesforce_Career_Path__c();
        testPath2.Certification__c = testCertification.Id;
        testPath2.Role__c = 'Salesforce Apex Specialist';
        testPath2.Possible_Next_Role__c = 'Salesforce Lightning Specialist';
        testPath2.Required__c = true;
        testPathList.add(testPath2);

        insert testPathList;

        Test.startTest();
            wrapperResultList = RoleCertificationsController.getPercentages('*'+testCont2.Id);
        Test.stopTest();

        System.assertEquals('Salesforce Trainee',wrapperResultList[0].role);
        System.assertEquals(0,wrapperResultList[0].porcentaje);
    }
}