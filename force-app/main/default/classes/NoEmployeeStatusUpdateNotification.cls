global class NoEmployeeStatusUpdateNotification implements Schedulable{

    String emailAddress = 'salesforce-managers@altimetrik.com';
    global NoEmployeeStatusUpdateNotification(String testEmailAddress){
        emailAddress = testEmailAddress;
    }

    global void execute(SchedulableContext SC) {
        List<Contact> employees = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE CreatedDate <= LAST_N_DAYS:45 AND Role__c LIKE: 'Salesforce%'];

        List<Employee_Status__c>  statuses = [SELECT Employee__c FROM Employee_Status__c WHERE Employee__c IN: employees AND CreatedDate <= LAST_N_DAYS:45];
        
        //Remove from the list the employees that have had a new status in the last 45 days
        List<Id> employeesNotToNotify = new List<Id>();
        for(Employee_Status__c s : statuses){
            employeesNotToNotify.add(s.Employee__c);
        }
        Integer i = 0;
        while (i < employees.size()){
            if(employeesNotToNotify.contains(employees.get(i).Id)){
                employees.remove(i);
            }else{
                i++;
            }
        }
        
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
