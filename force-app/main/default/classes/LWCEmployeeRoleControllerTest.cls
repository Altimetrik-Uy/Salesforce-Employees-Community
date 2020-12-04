@isTest
 public class LWCEmployeeRoleControllerTest {   
     @isTest
     public static void getRoleInformationTest(){
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
        	Account acc = TestDataFactory.createAccount();
           	Contact con = TestDataFactory.createContact(acc.Id);
           	con.Role__c = 'Salesforce Trainee';
           	update con;
			User usr = TestDataFactory.createUser(con.Id);
            Test.startTest();
            System.runAs(usr){
            System.assertEquals(LWCEmployeeRoleController.getRoleInformation(con.Id).Soft_skills__c, 'Comunicación escrita y oral, con equipo', 'The softskill do not match');
            }
            Test.stopTest();
        }
    } 
}