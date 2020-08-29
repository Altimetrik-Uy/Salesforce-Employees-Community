/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Employee Assignments Trigger Tests
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Schubert Tonarelli   <stonarelli@altimetrik.com>
* @created        2020-04-20
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public class EmployeeAssignmentsTriggerTest {
    
    @testSetup 
    static void setupTest(){

        Account testAccount = new Account( Name = 'TestAccount' );
        insert testAccount;
        
        Contact testContact = new Contact(
        	FirstName = 'Schubert',
        	LastName = 'Tonarelli',
        	AccountId = testAccount.Id
        );
        insert testContact;
        
        Opportunity testOpty = new Opportunity(
        	AccountId = testAccount.Id,
            CloseDate = Date.today().addYears(2),
            Area__c = 'Salesforce',
            StageName = 'Accepted',
            Name = 'Test1'
        );
        insert testOpty;
        
        Employee_Assignment__c testEmpAss = new Employee_Assignment__c(
        	Employee__c = testContact.Id,
            Project__c = testOpty.Id,
            Start_Date__c = Date.today().addDays(-1),
            End_Date__c = Date.today()
        );
        insert testEmpAss;
    }
	
    @isTest
    static void projectStartEndDate() {
        Opportunity testOpty =  [SELECT StageName FROM Opportunity WHERE Name = 'Test1' LIMIT 1];
        system.assert( testOpty.StageName == 'In Progress' );
    }
}