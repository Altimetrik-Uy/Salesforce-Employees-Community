@isTest
public class NoEmployeeStatusUpdateNotificationTest {
    @isTest static void testNoEmployeeStatusUpdateNotification() {
        Test.startTest();

        String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new NoEmployeeStatusUpdateNotification());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals('0 0 0 3 9 ? 2022', ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        List<EmailMessage> emailMessage  = [SELECT Id FROM EmailMessage LIMIT 1];
        System.assertNotEquals(1, emailMessage.size());

        Test.stopTest();

        emailMessage  = [SELECT Id FROM EmailMessage LIMIT 1];
        System.assertEquals(1, emailMessage.size());
    }
}
