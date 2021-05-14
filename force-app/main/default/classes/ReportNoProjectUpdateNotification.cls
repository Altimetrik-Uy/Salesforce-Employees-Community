/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Notify Project's without Updates
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Luis Macea  <lamcea@altimetrik.com>
* @created        2021-04-12
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public without sharing class ReportNoProjectUpdateNotification implements Schedulable{
    String emailAddress = Label.EmailManagers;
    public ReportNoProjectUpdateNotification() {

    }

    public void execute(SchedulableContext SC) {
        Date daysAgo20 = System.today().addDays(-20);
        List<Opportunity> listOpptiesNoUpdate = [SELECT Id,Name, Account.Name,Last_Project_Status__c,Last_Status_Date__c FROM Opportunity
                                                     WHERE IsClosed=false AND Last_Status_Date__c <=: daysAgo20];
        if (!listOpptiesNoUpdate.isEmpty()) {
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
            List<String> sendTo = new List<String>();
            sendTo.add(emailAddress);
            mail.setToAddresses(sendTo);
            mail.setSenderDisplayName('Salesforce Employee Community');
            mail.setSubject('Projects have not been updated');
            String body = '<p>Following projects have not been updated</p>';
            body += '<p></p>';
            body += '<p></p>';
            body += '<table border ="1" style="border-collapse: collapse;text-align: left;" >';
            body += '<tr><th>Name</th><th>Account</th><th>Last Status Update Date</th></tr>';
            String host= System.URL.getSalesforceBaseUrl().toExternalForm();
            for(Opportunity opp : listOpptiesNoUpdate){
                body +='<tr>';
                body +='<td><a href="'+host+'/'+opp.Id+'" target="_blank">'+opp.Name+'</a></td>';
                body +='<td>'+opp.Account.Name+'</td>';
                body += opp.Last_Status_Date__c!=null ? '<td>'+opp.Last_Status_Date__c.format()+'</td>':'<td></td>';
                body +='</tr>';
            }  
            
           mail.setHtmlBody(body);
           mails.add(mail);
            
           Messaging.sendEmail(mails);
        }
    }
}