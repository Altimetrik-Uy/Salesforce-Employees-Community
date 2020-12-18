@isTest
public class LWCEmployeeOverallControllerTest {
 
    public static Project_Status__c returnProjectStatusStructure(Id opportunityId){
        //This method return the fields used by the getProjectStatusImageName
        return [SELECT Status__c, Project__r.Name, Meeting_Date__c, Project__r.Id FROM Project_Status__c WHERE Project__r.Id=:opportunityId];
    } 
    
    @isTest
    public static void getProjectStatusImageName(){
    	//System Admin
    	User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User usr = TestDataFactory.createUser(con.Id);
            Id OppO1Id = TestDataFactory.createDataForTestProjectStatusImageName('O1',acc.Id, con.Id, 'Red', date.parse('11/12/2020'), date.parse('2/17/2021'));
 			Id OppO2Id = TestDataFactory.createDataForTestProjectStatusImageName('O2',acc.Id, con.Id, 'Green', date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id OppO3Id = TestDataFactory.createDataForTestProjectStatusImageName('O3',acc.Id, con.Id, 'Red', date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id OppO4Id = TestDataFactory.createDataForTestProjectStatusImageName('O3',acc.Id, con.Id, '', date.parse('11/12/2020'), date.parse('2/17/2021'));
            Id OppO5Id = TestDataFactory.createDataForTestProjectStatusImageName('O5',acc.Id, con.Id, 'Yellow', date.parse('11/12/2020'), date.parse('2/17/2021'));
            List<Project_Status__c> proS = new List<Project_Status__c>();
            proS.add(returnProjectStatusStructure(OppO3Id));
            proS.add(returnProjectStatusStructure(OppO1Id));
            proS.add(returnProjectStatusStructure(OppO5Id));
            //Run LWCEmployeeOverallController
            System.assertEquals(LWCEmployeeOverallController.getProjectStatusImageName(usr.Id), proS,'One or more Status do not match');
        }  
    }  
    
    @isTest
    public static  void getStatusImageName() {
        //System Admin
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin) {
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User usr = TestDataFactory.createUser(con.Id);
            //Employee Status
            Employee_Status__c eS1 = TestDataFactory.createEmployeeStatus(con.Id,'Red', 'Red');
            //Run LWCEmployeeOverallController
            System.assertEquals(LWCEmployeeOverallController.getStatusImageName(usr.Id), 'Red','Image is not Red');
        }
    }

    @isTest
    public static void testGetTrailBlazerId(){
        //System Admin
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin) {
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User newUser = TestDataFactory.createUser(con.Id);
            //User Info
            ta_User_Info__c newUserInfo = TestDataFactory.createUserInfo('testTrailId');
            Test.startTest();
                String trailId = LWCEmployeeOverallController.getTrailBlazerId((String)newUser.Id);
            Test.stopTest();
            System.assertEquals('testTrailId', trailId);
        }
    }

    @isTest
    public static void testGetTrailBlazerIdNull(){
        //System Admin
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin) {
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User newUser = TestDataFactory.createUser(con.Id);
            //User Info
            ta_User_Info__c newUserInfo = TestDataFactory.createUserInfo('');
            Test.startTest();
                String trailId = LWCEmployeeOverallController.getTrailBlazerId((String)newUser.Id);
            Test.stopTest();
            System.assertEquals(null, trailId);
        }
    }

    @isTest
    public static void testInsertTrailBlazerId(){
        //System Admin
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin) {
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User newUser = TestDataFactory.createUser(con.Id);
            //User Info
            ta_User_Info__c newUserInfo = TestDataFactory.createUserInfo('testTrailId');
            Test.startTest();
                LWCEmployeeOverallController.insertTrailBlazerId(newUser.Id, 'newTestTrailId');
            Test.stopTest();
            String trailId = LWCEmployeeOverallController.getTrailBlazerId(newUser.Id);
            System.assertEquals('newTestTrailId', trailId);
        }
    }
}   