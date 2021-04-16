@isTest
public with sharing class roleCertificationsCrtTest {

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
        testPathList.add(testPath1);
        Salesforce_Career_Path__c testPath2 = new Salesforce_Career_Path__c();
        testPath2.Certification__c = testCertification.Id;
        testPath2.Role__c = 'Salesforce Apex Specialist';
        testPath2.Possible_Next_Role__c = 'Salesforce Lightning Specialist';
        testPathList.add(testPath2);
        insert testPathList;

        
    
    }

    @isTest 
    static void noUserTest() {
        
        List<roleCertificationsCrt.rolesCertificacionesWrapper> wrapperResultList;
        
        Test.startTest();
            wrapperResultList = roleCertificationsCrt.calculosPorcentaje('1111111111111111111');
        Test.stopTest();
     
        System.debug('roleCertificationsCrtTest.wrapperList '+wrapperResultList);

        System.assertEquals('No existe usuario',wrapperResultList[0].role);
    }

    @isTest 
    static void noContactRoleTest() {
        
        List<roleCertificationsCrt.rolesCertificacionesWrapper> wrapperResultList;

        List<Contact> contactList = [
            SELECT Id,
            Role__c
            FROM Contact
            WHERE Email = 'test@testemail.com'
            LIMIT 1];
        System.debug('roleCertificationsCrtTest.contactList '+contactList);

        contactList[0].Role__c = null;
        update contactList;

        Test.startTest();
            wrapperResultList = roleCertificationsCrt.calculosPorcentaje('*'+contactList[0].Id);
        Test.stopTest();
     
        System.debug('roleCertificationsCrtTest.wrapperList '+wrapperResultList);

        System.assertEquals('Faltan datos',wrapperResultList[0].role);
    }

    @isTest 
    static void noUserInfoTest() {
        
        List<roleCertificationsCrt.rolesCertificacionesWrapper> wrapperResultList;

        List<Contact> contactList = [
            SELECT Id
            FROM Contact
            WHERE Email = 'test@testemail.com'
            LIMIT 1];
        System.debug('roleCertificationsCrtTest.contactList '+contactList);

        List<ta_User_Certification__c> testUserCertificationList = [
            SELECT Id,
            User_Info__c
            FROM ta_User_Certification__c
            WHERE User_Info__r.Email__c = 'test@testemail.com'
            LIMIT 1];
        System.debug('roleCertificationsCrtTest.testUserCertificationList '+testUserCertificationList);

        testUserCertificationList[0].User_Info__c = null;
        update testUserCertificationList;

        Test.startTest();
            wrapperResultList = roleCertificationsCrt.calculosPorcentaje('*'+contactList[0].Id);
        Test.stopTest();
     
        System.debug('roleCertificationsCrtTest.wrapperList '+wrapperResultList);

        System.assertEquals('Developer',wrapperResultList[0].role);
    }

    @isTest 
    static void noCertificationsTest() {
        
        List<roleCertificationsCrt.rolesCertificacionesWrapper> wrapperResultList;

        List<Contact> contactList = [
            SELECT Id
            FROM Contact
            WHERE Email = 'test@testemail.com'
            LIMIT 1];
        System.debug('roleCertificationsCrtTest.contactList '+contactList);

        List<ta_User_Certification__c> testUserCertificationList = [
            SELECT Id,
            Certification__c
            FROM ta_User_Certification__c
            WHERE User_Info__r.Email__c = 'test@testemail.com'
            LIMIT 1];
        System.debug('roleCertificationsCrtTest.testUserCertificationList '+testUserCertificationList);

        testUserCertificationList[0].Certification__c = null;
        update testUserCertificationList;

        Test.startTest();
            wrapperResultList = roleCertificationsCrt.calculosPorcentaje('*'+contactList[0].Id);
        Test.stopTest();
     
        System.debug('roleCertificationsCrtTest.wrapperList '+wrapperResultList);

        System.assertEquals('No hay registros para el rol presente',wrapperResultList[0].role);
    }

    @isTest 
    static void successfullTest() {
        
        List<roleCertificationsCrt.rolesCertificacionesWrapper> wrapperResultList;

        List<Contact> contactList = [
            SELECT Id,
            Role__c
            FROM Contact
            WHERE Email = 'test@testemail.com'
            LIMIT 1];
        System.debug('roleCertificationsCrtTest.contactList '+contactList);

        Test.startTest();
            wrapperResultList = roleCertificationsCrt.calculosPorcentaje('*'+contactList[0].Id);
        Test.stopTest();
     
        System.debug('roleCertificationsCrtTest.wrapperList '+wrapperResultList);

        System.assertEquals('Developer',wrapperResultList[0].role);
        System.assertEquals('Salesforce Apex Specialist',wrapperResultList[1].role);
    }
}