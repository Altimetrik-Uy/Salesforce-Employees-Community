Execute schedule job

- Open the developer console
- Under Debug, Open Execute Anonymous Window
- Copy the following script:

    NoEmployeeStatusUpdateNotification m = new NoEmployeeStatusUpdateNotification('salesforce-managers@altimetrik.com');
    String sch = '0 0 9 * * ? *';
    String jobID = system.schedule('No Status Update Notification Job', sch, m);

- Paste in the execute anonymous window and click Execute button.


For Testing purpose execute the following script instead replacing email address in the first line:

    NoEmployeeStatusUpdateNotification m = new NoEmployeeStatusUpdateNotification('[YOUR EMAIL ADDRESS]');
    String sch = '0 0 * * * ?';
    String jobID = system.schedule('No Status Update Notification Job', sch, m);