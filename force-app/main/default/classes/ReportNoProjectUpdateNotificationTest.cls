/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for ReportNoProjectUpdateNotification
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Luis Macea  <lamcea@altimetrik.com>
* @created        2021-04-12
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public  class ReportNoProjectUpdateNotificationTest {
    @TestSetup
    static void makeData(){
        Account customer = new Account();
        customer.Name  = 'Test Customer';
        customer.Phone = '44554545545';
        insert customer;

        Opportunity project = new Opportunity();
        project.Name  = 'test Project';
        project.CloseDate = System.today();
        project.Amount = 100000;
        project.StageName = 'Prospecting';
        project.Last_Status_Date__c = System.today().addDays(-30); 
        project.AccountId = customer.Id;
        insert project;      
    }

    @IsTest
    static void tesRunJobSendEmail(){
        
        Test.startTest();
            String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new ReportNoProjectUpdateNotification());
        Test.stopTest();
        List<EmailMessage> emailMessageList = [SELECT Id FROM EmailMessage LIMIT 1];
        System.assertEquals(1, emailMessageList.size());        
    }

    @IsTest
    static void tesRunJobNotSendEmail(){
        Opportunity opp = [SELECT Id,Last_Status_Date__c FROM Opportunity ];
        opp.Last_Status_Date__c = System.today().addDays(-19);
        update opp;
        Test.startTest();
            String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new ReportNoProjectUpdateNotification());
        Test.stopTest();
        List<EmailMessage> emailMessageList = [SELECT Id FROM EmailMessage LIMIT 1];
       System.assertEquals(0, emailMessageList.size());        
    }
}