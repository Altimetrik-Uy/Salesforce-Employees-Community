/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Search for End Date in EmployeeAssignment to send feedback survey to employees and team leaders
* Should run once a day!
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Schubert Tonarelli   <stonarelli@altimetrik.com>
* @created        2020-05-15
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
global class EmployeeAssignmentEndDateBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private final String EMAIL_TEMPLATE_DEV_NAME = 'Altimetrik_Employee_Notification';
    private final String TEAM_LEAD_ROLE = 'Salesforce Team Lead';
    private final String TEAM_LEAD_TEMPLATE = 'a082F00000gVekAQAS';
    private final String EMPLOYEE_TEMPLATE = 'a082F00000gVbVvQAK';
    private final String LINK_URL = getURL();
    private Map<String, Survey_Template__c> templateMap = new Map<String, Survey_Template__c>( [SELECT Id, Name, Description__c 
                                                                                 FROM Survey_Template__c WHERE Id IN( :TEAM_LEAD_TEMPLATE, :EMPLOYEE_TEMPLATE )] );
        
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            //'SELECT Id, Employee__c, Employee__r.Email, Employee__r.FirstName, Role__c, Project__c FROM Employee_Assignment__c WHERE ID = \'a002F000004OVQg\''
            'SELECT Id, Employee__c, Employee__r.Email, Employee__r.FirstName, Role__c, Project__c FROM Employee_Assignment__c WHERE Active__c = TRUE AND End_Date__c = TODAY()' 
        );
    }
    
    global void execute(Database.BatchableContext info, List<Employee_Assignment__c > scope){
        
        List<EmailTemplate> emailTemplateList = [SELECT Id, Name, Subject, Body, HtmlValue 
                                                 FROM EmailTemplate WHERE DeveloperName = :EMAIL_TEMPLATE_DEV_NAME LIMIT 1];
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage> ();
        Set<String> projectsSet = new Set<String>();
        
        // Send email to employee
        for( Employee_Assignment__c e : scope ){

            emails.add( getEmail( e, emailTemplateList.get(0) ) );
            
            if( !projectsSet.contains( e.Project__c ) ) projectsSet.add( e.Project__c );
        }
        
        for( Employee_Assignment__c e : [SELECT Id, Employee__c, Employee__r.Email, Employee__r.FirstName, Role__c, Project__c 
                                         FROM Employee_Assignment__c WHERE Project__c IN :projectsSet AND Role__c = :TEAM_LEAD_ROLE]){
            
            emails.add( getEmail( e, emailTemplateList.get(0) ) );
        }
        
        Messaging.sendEmail( emails );       
    }  
    
    private Messaging.SingleEmailMessage getEmail( Employee_Assignment__c e, EmailTemplate emailTemplate ){

        String employeeTemplate = ( ( e.Role__c == '' )? TEAM_LEAD_TEMPLATE : EMPLOYEE_TEMPLATE );
        
        String surveyURL = LINK_URL + '/?empId='+e.Employee__c+'&tmpId='+ employeeTemplate +'&proyId='+ e.Project__c +'';
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        
        email.setToAddresses( new String[] { e.Employee__r.Email } );
        email.setSaveAsActivity(false);
        email.setTargetObjectId( e.Employee__c );
        
        email.setSubject( emailTemplate.Subject + ' '+ templateMap.get(EMPLOYEE_TEMPLATE).Name );
        
        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!Contact.FirstName}', e.Employee__r.FirstName );
        htmlBody = htmlBody.replace('{!url}', surveyURL );         
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!Contact.FirstName}', e.Employee__r.FirstName );         
        plainBody = plainBody.replace('{!url}', surveyURL );         
        
        email.setHtmlBody(htmlBody);
        email.setPlainTextBody(plainBody);  
        
        return email;
    }
    
    private String getURL(){
        List<Site> siteList = [SELECT GuestUserId, Name,MasterLabel, Subdomain, 
                               OptionsRequireHttps, UrlPathPrefix FROM Site WHERE MasterLabel = 'FeedBack' LIMIT 1];
        
        List<String> siteFullUrlList = new List<String>();
        /** We can get instance of the org from organisation object **/
        Organization org = [SELECT InstanceName,Name, IsSandbox, OrganizationType FROM Organization];
        if(siteList != null && siteList.size() != 0) {
            for(Site s: siteList) {
                if(s.Subdomain != null) {
                    String httpStr = 'http://';
                    if(s.OptionsRequireHttps == true) {
                        httpStr = 'https://';
                    }
                    String siteFullUrl = httpStr;
                    if(org.IsSandbox == true) {
                        siteFullUrl += UserInfo.getUserName().substringAfterLast('.')+'-';
                    }
                    siteFullUrl += s.Subdomain + '.';
                    siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force.com';
                    if(s.UrlPathPrefix != null) {
                        siteFullUrl += '/'+s.UrlPathPrefix; 
                    }
                    siteFullUrlList.add(siteFullUrl);
                }
            }
        }
        return ( ( !siteFullUrlList.isEmpty() )? siteFullUrlList.get(0) : '' );
    }
    
    global void finish(Database.BatchableContext info){ 
        
    } 
}