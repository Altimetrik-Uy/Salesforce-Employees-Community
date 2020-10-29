public class LWCEmployeeOverallController{
    @AuraEnabled(cacheable=true)
    public static List<Project_Status__c> getProjectStatusImageName(String uId){
        try{   
        //Obtain the ContactId of the logged in user
           String contactId = [SELECT Contact.Id FROM User WHERE Id = :uId LIMIT 1].Contact.Id;
           Integer count = 1;
           if(contactId != null){
                List<Project_Status__c> proSRet = new List<Project_Status__c>();
                //Get Opprotunities from Employee_Assignment__c
                List<Id> projectsId = new List<Id>();
                for(Employee_Assignment__c currentEA : [SELECT Project__r.Id FROM Employee_Assignment__c WHERE Employee__r.Id = :contactId AND Project__r.End_Date__c = null ORDER BY CreatedDate DESC]){
                    projectsId.add(currentEA.Project__r.Id);
                }
                //Obtain the status and opportunities of Project_Status__c
               return [SELECT Status__c, Project__r.Name, Project__r.Id FROM Project_Status__c WHERE Project__r.Id IN :projectsId ORDER BY Status__c DESC LIMIT 3];
            }else{
                return new  List<Project_Status__c>();
            }
        }catch(Exception ex){
            System.debug('exception:' + ex);    
            return new  List<Project_Status__c>();
        }
    }
}