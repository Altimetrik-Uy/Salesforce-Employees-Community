@isTest
 public class LWCEmployeeRoleControllerTest {   
    
    @isTest
    public static void getRoleInformationTest(){
        User admin = TestDataFactory.createAdminUser();
        Salesforce_Career_Path_Settings__mdt newPathSettings;
        System.runAs(admin){
        	Account acc = TestDataFactory.createAccount();
           	Contact con = TestDataFactory.createContact(acc.Id);
           	con.Role__c = 'Salesforce Trainee';
           	update con;
            User usr = TestDataFactory.createUser(con.Id);
            Test.startTest();
            System.runAs(usr){
                newPathSettings = LWCEmployeeRoleController.getRoleInformation(con.Id);
            }
            Test.stopTest();
            System.assertEquals('Comunicación escrita y oral, con equipo', newPathSettings.Soft_skills__c, 'The softskill do not match');
        }
    } 
}