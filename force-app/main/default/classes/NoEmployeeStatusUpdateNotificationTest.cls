@isTest
public class NoEmployeeStatusUpdateNotificationTest {
    @TestSetup
    static void makeData(){
        Account customer = new Account();
        customer.Name  = 'Test Customer';
        customer.Phone = '44554545545';
        insert customer;
        Contact c1 = new Contact();
        c1.FirstName = 'Test';
        c1.Email= 'test@test.com';
        c1.LastName='morales';
        c1.Role__c='Salesforce Developer';
        insert c1;
        Test.setCreatedDate(c1.Id, Datetime.now().addDays(-60));
        
        Employee_Status__c es =  new Employee_Status__c();
        es.Status__c='Yellow';
        es.Certification_Status__c='Red';
        es.Employee__c = c1.Id;
        insert es;
        Test.setCreatedDate(es.Id, Datetime.now().addDays(-60));
        
    }
    @isTest static void testNoEmployeeStatusUpdateNotification() {
        Test.startTest();

        String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new NoEmployeeStatusUpdateNotification());
        Test.stopTest();

        List<EmailMessage>  emailMessage  = [SELECT Id FROM EmailMessage LIMIT 1];
        System.assertEquals(1, emailMessage.size());
    }
}