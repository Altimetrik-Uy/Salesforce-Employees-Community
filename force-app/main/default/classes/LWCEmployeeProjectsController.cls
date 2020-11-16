public class LWCEmployeeProjectsController {
    
    @AuraEnabled(cacheable=true)
    public static List<Employee_Assignment__c> getEmployeeProjects(String empId){
        try {
            return [SELECT Project__r.Id, Project__r.Name, Project__r.Description, Start_Date__c, End_Date__c, Active__c FROM Employee_Assignment__c WHERE Employee__r.Id = :empId  ORDER BY Active__c DESC, Start_Date__c DESC];
        } catch (Exception e) {
            return new List<Employee_Assignment__c>();
        }
    }
}