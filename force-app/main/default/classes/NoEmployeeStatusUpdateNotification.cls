global class NoEmployeeStatusUpdateNotification implements Schedulable{

    String emailAddress = Label.EmailManagers;
    global NoEmployeeStatusUpdateNotification(){
    }

    global void execute(SchedulableContext SC) {

        Date daysAgo45 = System.today().addDays(-45);
        List<Employee_Status__c>  statuses = [SELECT Employee__c FROM Employee_Status__c WHERE 
                                                CreatedDate <: daysAgo45 AND
                                                Employee__r.Role__c LIKE: 'Salesforce%' AND Employee__r.CreatedDate<=:  daysAgo45];
        
        //Remove from the list the employees that have had a new status in the last 45 days
        List<Id> employeesNotToNotify = new List<Id>();
        for(Employee_Status__c s : statuses){
            employeesNotToNotify.add(s.Employee__c);
        }

        List<Contact> employees = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id IN: employeesNotToNotify];
        //Send Notification
        if(employees.size() > 0){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
            List<String> sendTo = new List<String>();
            sendTo.add(emailAddress);
            mail.setToAddresses(sendTo);
            mail.setSenderDisplayName('Salesforce Employee Community');
            mail.setSubject('No Status Update Notification');
            String body = '';
            for(Contact c : employees){
                body += 'The employee ' + c.FirstName + ' ' + c.LastName + ' has not had a status update for 45 days </br>';
            }   
            mail.setHtmlBody(body);
            mails.add(mail);
            
            Messaging.sendEmail(mails);
        }
    }
}