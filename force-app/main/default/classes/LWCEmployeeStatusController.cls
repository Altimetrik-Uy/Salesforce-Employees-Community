public class LWCEmployeeStatusController {

    @AuraEnabled(cacheable=true)
    public static List<Employee_Assignment__c> getEmployeeProjects(String empId){
        List<Employee_Assignment__c> eAList = new List<Employee_Assignment__c>();
        //Get projects only once
        Id auxId;
        for (Employee_Assignment__c current_eA : [SELECT Project__r.Id, Project__r.Name FROM Employee_Assignment__c WHERE Employee__r.Id = :empId ORDER BY Project__r.Name ]){
            if(eAList.isEmpty()){
                eAList.add(current_eA);
            }else{
                if (current_eA.Project__r.Id != auxId) {
                    eAList.add(current_eA);
                }
            }
            auxId = current_eA.Project__r.Id;
        }
        return eAList;
    }
    @AuraEnabled(cacheable=true)
    public static List<Employee_Status__c> getEmployeeStatuses(Id projId){
        return [SELECT Status__c, Meeting_Date__c, Comments__c, CreatedBy.Name, Project__r.Name FROM Employee_Status__c WHERE Project__r.Id =: projId];
    }

}