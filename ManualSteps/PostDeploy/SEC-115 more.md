Step 1 [SEC-96] - Schedule the Job NoEmployeeStatusUpdateNotification every day at 6:00 AM 
   * Go to Setup search for Apex Classes
   * Select Schedule Apex
   * Name: NoEmployeeStatusUpdateNotification_JOB
   * Frequence : Weekly
   * Select Monday,Tuesday,Wednesday,Thursday, Friday
   * Start:  Today
   * End: 30/12/2030
   * Save

   - FOR TESTING PURPOSES:
    Change the label "EmailManagers" with your email  
       RUN THE SCRIPT 

        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute() + 2); 
        String ss = String.valueOf(Datetime.now().second());

        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';

        NoEmployeeStatusUpdateNotification s = new NoEmployeeStatusUpdateNotification(); 
        System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s);



Step 2 [SEC-95] - Schedule the Job ReportNoProjectUpdateNotification every day at 6:00 AM 

   * Go to Setup search for Apex Classes
   * Select Schedule Apex
   * Name: ReportNoProjectUpdateNotification_JOB
   * Frequence : Weekly
   * Select Monday,Tuesday,Wednesday,Thursday, Friday
   * Start:  Today
   * End: 30/12/2030
   * Save

   - FOR TESTING PURPOSES:
    Change the label "EmailManagers" with your email  
       RUN THE SCRIPT 
       
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute() + 2); 
        String ss = String.valueOf(Datetime.now().second());

        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';

        ReportNoProjectUpdateNotification s = new ReportNoProjectUpdateNotification(); 
        System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s);