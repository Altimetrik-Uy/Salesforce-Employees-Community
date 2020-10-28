@isTest
public class LWCEmployeeOverallControllerTest {
    public static User createAdminUser(){
        Profile pAdmin = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        UserRole uRoleAdmin = [SELECT Id, Name FROM UserRole WHERE Name = 'CEO' LIMIT 1];
        User admin = new User();
        admin.firstname = 'Admin1';
        admin.lastname = 'Admin1';
        admin.Alias = 'aAdmin1';
        admin.email = 'aAdmin1@admin.com';
        admin.username = 'aAdmin1@admin.com';
        admin.UserRoleId = uRoleAdmin.Id;
        admin.profileId = pAdmin.id;
        admin.emailencodingkey ='UTF-8';
        admin.languagelocalekey ='en_US';
        admin.localesidkey ='en_US';
        admin.timezonesidkey ='America/Los_Angeles';
        insert admin;
        return admin;
    }
    public static Contact createContact(Id accountId){
        Contact con = new Contact();
        con.FirstName='Test';
        con.LastName='Test';
        con.AccountId = accountId;
        insert con;
        return con;
    }
    public static Account createAccount(){
       Account acc = new Account();
       acc.Name = 'accountForTest';
       insert acc;
       return acc;
    }
    public static User createUser(Id contactId){
        User usr = new User();
        Profile pUser = [SELECT Id FROM Profile WHERE Name = 'Partner Community User' LIMIT 1];
        usr.firstname = 'Sebastian';
        usr.lastname = 'Trelles';
        usr.Alias = 'strel';
        usr.email = 'strel@test.com';
        usr.username = 'strel@test.com';
        usr.profileId = pUser.id;
        usr.emailencodingkey ='UTF-8';
        usr.languagelocalekey ='en_US';
        usr.localesidkey ='en_US';
        usr.timezonesidkey ='America/Los_Angeles';
        usr.ContactId = contactId;
        insert usr;
        return usr;
    }
    public static Opportunity createOpportunity(String name, Id accountId){
        Opportunity opp = new Opportunity();
        opp.Name = name;
        opp.CloseDate = system.today();
        opp.StageName = 'Accepted';
        opp.AccountId = accountId;
        insert opp;
        return opp;
    }
    public static Employee_Assignment__c createEmployeeAssigment(Id contactId, Id opportunityId){
    	Employee_Assignment__c eAssignment = new Employee_Assignment__c();
        eAssignment.Employee__c = contactId;
        eAssignment.Project__c = opportunityId;
        insert eAssignment;
        return eAssignment;
    }
    public static Project_Status__c createProjectStatus(Id opportunityId, String status){
        Project_Status__c pStatus = new Project_Status__c();
        pStatus.Project__c = opportunityId;
        pStatus.Comments__c = 'Test';
        pStatus.Meeting_Date__c = system.today();
        pStatus.Status__c = status;
        insert pStatus;
        return pStatus;
    }
    public static Id createDataForTestProjectStatusImageName(String name, Id accountId, Id conntactId, String status){
    	//Opportunity
        Opportunity opp = createOpportunity(name, accountId);
        //Employee Assignment
        Employee_Assignment__c eAssignment5 = createEmployeeAssigment(conntactId, opp.Id);
        //If status is null do not create Project Status
        if(status != ''){
            //Project Status
            Project_Status__c pStatus5 = createProjectStatus(opp.Id, status); 
        }
       	return opp.Id;
    }
    public static Project_Status__c returnProjectStatusStructure(Id opportunityId){
        //This method return the fields used by the getProjectStatusImageName
       return [SELECT Status__c, Project__r.Name, Project__r.Id FROM Project_Status__c WHERE Project__r.Id=:opportunityId];
    } 
    @isTest
    public static void getProjectStatusImageName(){
    	//System Admin
    	User admin = createAdminUser();
        System.runAs(admin){
            //Account
            Account acc = createAccount();
            //Contact
            Contact con = createContact(acc.Id);
            //User
            User usr = createUser(con.Id);
            Id OppO1Id = createDataForTestProjectStatusImageName('O1',acc.Id, con.Id, 'Red');
 			Id OppO2Id = createDataForTestProjectStatusImageName('O2',acc.Id, con.Id, 'Green');
            Id OppO3Id = createDataForTestProjectStatusImageName('O3',acc.Id, con.Id, 'Red');
            Id OppO4Id = createDataForTestProjectStatusImageName('O3',acc.Id, con.Id, '');
            Id OppO5Id = createDataForTestProjectStatusImageName('O5',acc.Id, con.Id, 'Yellow');
            List<Project_Status__c> proS = new List<Project_Status__c>();
            proS.add(returnProjectStatusStructure(OppO1Id));
            proS.add(returnProjectStatusStructure(OppO3Id));
            proS.add(returnProjectStatusStructure(OppO5Id));
            //Run LWCEmployeeOverallController
            System.assertEquals(LWCEmployeeOverallController.getProjectStatusImageName(usr.Id), proS,'One or more Status do not match');
        }  
    }      
}