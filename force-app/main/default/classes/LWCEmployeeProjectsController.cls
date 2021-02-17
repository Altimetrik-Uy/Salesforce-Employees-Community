public with sharing class LWCEmployeeProjectsController {

    public LWCEmployeeProjectsController() {
    }

    @AuraEnabled(cacheable=true)
    public static Integer getEmployeeProjectsCount(String empId){
        return [SELECT COUNT() FROM Employee_Assignment__c WHERE (Base_Category__c = 'BILLED' OR Project__r.Name = 'Bench') AND Employee__r.Id = :empId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Employee_Assignment__c> getEmployeeProjects(String empId, Integer offsetRange){
        List<Employee_Assignment__c> listEmployeeAssig = new List<Employee_Assignment__c>();
        try {
            if(offsetRange == null){
                listEmployeeAssig = [
                    SELECT Project__r.Id, Project__r.Name, Project__r.Description, Start_Date__c, End_Date__c, Active__c 
                    FROM Employee_Assignment__c  WHERE (Base_Category__c = 'BILLED' OR Project__r.Name = 'Bench') 
                    AND Employee__r.Id = :empId  ORDER BY Active__c DESC, Start_Date__c DESC LIMIT 4
                    ];
            }else{
                listEmployeeAssig = [
                    SELECT Project__r.Id, Project__r.Name, Project__r.Description, Start_Date__c, End_Date__c, Active__c 
                    FROM Employee_Assignment__c  WHERE (Base_Category__c = 'BILLED' OR Project__r.Name = 'Bench') 
                    AND  Employee__r.Id = :empId  ORDER BY Active__c DESC, Start_Date__c DESC LIMIT 4 OFFSET :offsetRange
                    ];
            }
            for(integer i=listEmployeeAssig.size()-1; i>0; i--) {
                Employee_Assignment__c employee = listEmployeeAssig.get(i);
                Employee_Assignment__c employee2 = listEmployeeAssig.get(i-1);
                if(employee.Project__r.Name == employee2.Project__r.Name){
                    if(employee2.Start_Date__c > employee.Start_Date__c){
                        employee2.Start_Date__c = employee.Start_Date__c;
                    }
                    if(employee2.End_Date__c < employee.End_Date__c){
                        employee2.End_Date__c = employee.End_Date__c;
                    }
                    listEmployeeAssig.remove(i);
                }
            }
            return listEmployeeAssig;
        } catch (Exception e) {
            return new List<Employee_Assignment__c>();
        }
    }
}
