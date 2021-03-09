Execute schedule job

- Open the developer console
- Under Debug, Open Execute Anonymous Window
- Copy the following script:

    NoEmployeeStatusUpdateNotification m = new NoEmployeeStatusUpdateNotification();
    String sch = '0 0 9 * * ? *';
    String jobID = system.schedule('No Status Update Notification Job', sch, m);

- Paste in the execute anonymous window and click Execute button.