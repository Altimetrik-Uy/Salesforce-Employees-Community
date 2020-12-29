
/*     @AuraEnabled(cacheable=true)
    public static List<Employee_Assignment__c> getEmployeeProjects(String empId){
        try {
            return [SELECT Project__r.Id, Project__r.Name, Project__r.Description, Start_Date__c, End_Date__c, Active__c FROM Employee_Assignment__c WHERE Employee__r.Id = :empId  ORDER BY Active__c DESC, Start_Date__c DESC];
        } catch (Exception e) {
            return new List<Employee_Assignment__c>();
        }
    } */
//saving the file with .java extension for better indentation

public with sharing class LWCEmployeeProjectsController {

    public LWCEmployeeProjectsController() {
    }

    @AuraEnabled(cacheable=true)
    public static Integer getEmployeeProjectsCount(String empId){
        return [SELECT COUNT() FROM Employee_Assignment__c WHERE Employee__r.Id = :empId];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getAllCount(){
        return [SELECT COUNT() FROM Employee_Assignment__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Employee_Assignment__c> getEmployeeProjects(String empId, Integer offsetRange){
        try {
            if(offsetRange == null){
                return [SELECT Project__r.Id, Project__r.Name, Project__r.Description, Start_Date__c, End_Date__c, Active__c FROM Employee_Assignment__c  WHERE Employee__r.Id = :empId  ORDER BY Active__c DESC, Start_Date__c DESC LIMIT 4];
            }else{
                return [SELECT Project__r.Id, Project__r.Name, Project__r.Description, Start_Date__c, End_Date__c, Active__c FROM Employee_Assignment__c  WHERE Employee__r.Id = :empId  ORDER BY Active__c DESC, Start_Date__c DESC LIMIT 4 OFFSET :offsetRange];
            }
        } catch (Exception e) {
            return new List<Employee_Assignment__c>();
        }
    }
}
