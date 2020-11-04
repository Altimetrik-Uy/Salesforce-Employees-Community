public class LWCEmployeeProjectsController {
    
    @AuraEnabled(cacheable=true)
    public static List<Employee_Assignment__c> getEmployeeProjects(String empId){
        try {
            return [SELECT Project__r.Name, Project__r.End_Date__c, CreatedDate FROM Employee_Assignment__c WHERE Employee__r.Id = :empId ORDER BY Project__r.End_Date__c];
        } catch (Exception e) {
            return new List<Employee_Assignment__c>();
        }
    }
}