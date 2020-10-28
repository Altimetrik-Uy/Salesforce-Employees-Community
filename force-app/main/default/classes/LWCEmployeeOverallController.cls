public class LWCEmployeeOverallController{
    @AuraEnabled(cacheable=true)
    public static List<Project_Status__c> getProjectStatusImageName(String uId){
        try{   
        //Obtain the ContactId of the logged in user
           String contactId = [SELECT Contact.Id FROM User WHERE Id =:uId LIMIT 1].Contact.Id;
           Integer count = 1;
           if(contactId != null){
                List<Project_Status__c> proSRet = new List<Project_Status__c>();
                //Get Opprotunities from Employee_Assignment__c
                List<Employee_Assignment__c> oppEA = [SELECT Project__r.Id, Project__r.Name, Employee__r.Id, Employee__r.Name FROM Employee_Assignment__c WHERE Employee__r.Id =: contactId AND Project__r.End_Date__c = null ORDER BY CreatedDate DESC];
                //Obtain the status and opportunities of Project_Status__c
                List<Project_Status__c> proS = [SELECT Status__c, Project__r.Name, Project__r.Id FROM Project_Status__c ORDER BY Status__c DESC];
                for(Project_Status__c currentProS : proS){
                    for(Employee_Assignment__c currentOppEA : oppEA){
                        if(currentOppEA.Project__r.Id == currentProS.Project__r.Id){
                        //Add Project 
                            if (count <= 3) {
                                proSRet.add(currentProS);
                                count ++;
                            }
                        }
                    }
                }
                return proSRet;
            }else{
                return new  List<Project_Status__c>();
            }
        }catch(Exception ex){
            System.debug('exception:' + ex);    
            return new  List<Project_Status__c>();
        }
    }
}