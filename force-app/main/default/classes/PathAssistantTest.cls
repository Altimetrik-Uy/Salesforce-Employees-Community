@isTest
public with sharing class PathAssistantTest {
    @isTest
    static void dataCareerPathComponentDev() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'Salesforce Developer';
            update con;
            User usr = TestDataFactory.createUser(con.Id);
            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id);         
                System.assertEquals(lstWrpcolumns[0].strColumn, '1');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 1);
            }
            Test.stopTest();
        }
    }

    @isTest
    static void dataCareerPathComponentPlatform() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'Salesforce Platform Specialist';
            update con;
            User usr = TestDataFactory.createUser(con.Id);
            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id);         
                System.assertEquals(lstWrpcolumns[0].strColumn, '1');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 1);
            }
            Test.stopTest();
        }
    }

    @isTest
    static void dataCareerPathComponentSeniorPlatform() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'Salesforce Senior Platform Specialist';
            update con;
            User usr = TestDataFactory.createUser(con.Id);

            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id);

                System.assertEquals(lstWrpcolumns[0].strColumn, '1');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 1);

            }
            Test.stopTest();
        }
    }

    @isTest
    static void dataCareerPathComponentDeliveryManager() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'Salesforce Delivery Manager';
            update con;
            User usr = TestDataFactory.createUser(con.Id);

            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id);

                System.assertEquals(lstWrpcolumns[0].strColumn, '1');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 1);

            }
            Test.stopTest();
        }
    }

    @isTest
    static void dataCareerPathComponentArchitect() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'Salesforce Architect Chief';
            update con;
            User usr = TestDataFactory.createUser(con.Id);

            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id);

                System.assertEquals(lstWrpcolumns[0].strColumn, '1');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 1);

            }
            Test.stopTest();
        }
    }

    @isTest
    static void dataCareerPathComponentLead() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'Salesforce Team Lead';
            update con;
            User usr = TestDataFactory.createUser(con.Id);

            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id);

                System.assertEquals(lstWrpcolumns[0].strColumn, '1');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 1);

            }
            Test.stopTest();
        }
    }

    @isTest
    static void dataCareerPathComponentQA() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'QA Manager';
            update con;
            User usr = TestDataFactory.createUser(con.Id);
            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id); 
                System.assertEquals(lstWrpcolumns[0].strColumn, '6');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 1);
            }
            Test.stopTest();
        }
    }

    @isTest
    static void dataCareerPathComponentQALead() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'QA Lead';
            update con;
            User usr = TestDataFactory.createUser(con.Id);
            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id); 
                System.assertEquals(lstWrpcolumns[0].strColumn, '6');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 1);
            }
            Test.stopTest();
        }
    }

    @isTest
    static void dataCareerPathComponentQASpecialist() {
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            Account acc = TestDataFactory.createAccount();
            Contact con = TestDataFactory.createContact(acc.Id);
            con.Role__c = 'QA Automation Specialist';
            update con;
            User usr = TestDataFactory.createUser(con.Id);
            Test.startTest();
            System.RunAs(usr){
                List<PathAssistant.wrpColumns> lstWrpcolumns = PathAssistant.getPath(con.Id); 
                System.assertEquals(lstWrpcolumns[0].strColumn, '6');
                System.assertEquals(lstWrpcolumns[0].lstWrpRoles.size(), 1);
            }
            Test.stopTest();
        }
    }
}