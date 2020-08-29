public class EmployeeStatusController {

    @AuraEnabled
    public static List<EmployeeStatusWrapper> getUserEmployeeStatus() {
        List<EmployeeStatusWrapper> wrapper = new List<EmployeeStatusWrapper>();
        
        List<Employee_Status__c> userEmployeeStatus = resolveUserEmployeeStatus();
        for (Employee_Status__c employeeStatus : userEmployeeStatus) {
            EmployeeStatusWrapper newWrapper = new EmployeeStatusWrapper();
            newWrapper.employee = employeeStatus.Employee__r.Name;
            newWrapper.status = employeeStatus.Status__c;
            newWrapper.id = employeeStatus.Id;
            wrapper.add(newWrapper);
        }
        
        return wrapper;
    }
    
    @AuraEnabled
    public static void createEmployeeStatus(
        String employee,
        String status,
        String comments,
        String redReason,
        String certStatus,
        String certComments
    ) {
        try {
            Employee_Status__c employeeStatus = new Employee_Status__c(
                Employee__c = employee,
                Status__c = status,
                Comments__c = comments,
                Red_Reason__c = redReason,
                Certification_Status__c = certStatus,
                Certification_Comments__c = certComments
            );
                        
            insert employeeStatus;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static Map<String, String> getStatus() {
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Employee_Status__c.Status__c.getDescribe();

        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : pList) {
            options.put(entry.getValue(), entry.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static Map<String, String> getCertificationStatus() {
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Employee_Status__c.Certification_Status__c.getDescribe();

        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : pList) {
            options.put(entry.getValue(), entry.getLabel());
        }
        return options;
    }
    
    public class EmployeeStatusWrapper {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String employee { get; set; }
        @AuraEnabled public String status { get; set; }
    }
    
    private static List<Employee_Status__c> resolveUserEmployeeStatus() {
        List<Managers_Assignment__c> userAssignments = getUserAssignments();
        Set<Id> userProjects = new Set<Id>();
        Map<String, Set<Id>> userSubProjects = new Map<String, Set<Id>>();
        
        for (Managers_Assignment__c assignment : userAssignments) {
            userProjects.add(assignment.Project__c);
            if (!String.isBlank(assignment.Sub_Project__c)){
                if (userSubProjects.get(assignment.Project__c) == null){
                    Set<Id> aux = new Set<Id>();
                    aux.add(assignment.Sub_Project__c);
                    userSubProjects.put(assignment.Project__c, aux);
                }else{
                    userSubProjects.get(assignment.Project__c).add(assignment.Sub_Project__c);
                }
                
            }
        }
        
        List<Employee_Assignment__c> employeeAssignments = getEmployeeAssignmentsByProjectId(userProjects, userSubProjects);
        
        Set<Id> employeeIds = new Set<Id>();
        for (Employee_Assignment__c employeeAssignment : employeeAssignments) {
            employeeIds.add(employeeAssignment.Employee__c);
        }

        return getEmployeeStatusByEmployeeIds(employeeIds);
    }
    
    private static List<Managers_Assignment__c> getUserAssignments() {
        return [SELECT Id, Project__c, Sub_Project__c FROM Managers_Assignment__c WHERE User__c = :UserInfo.getUserId()];
    }
    
    private static List<Employee_Assignment__c> getEmployeeAssignmentsByProjectId(Set<Id> projectIds, Map<String, Set<Id>> subProjects) {
        
        List<Employee_Assignment__c> toReturn = new List<Employee_Assignment__c>();
        for (Employee_Assignment__c ea: [SELECT Id, Employee__c, Project__c,  Sub_Project__c FROM Employee_Assignment__c WHERE Project__c IN :projectIds and Employee__r.Active__c = true and End_Date__c >: date.today() and Base_Category__c!='']){
            system.debug('======== Employee__c '+ ea.Employee__c);
            system.debug('======== Project__c '+ ea.Project__c);
            system.debug('======== Sub_Project__c '+ ea.Sub_Project__c);
            if (!String.isBlank(ea.Sub_Project__c) && subProjects.get(ea.Project__c)!= null && subProjects.get(ea.Project__c).contains(ea.Sub_Project__c)) {
                system.debug('======== added 1');
                toReturn.add(ea);
            }else{
                system.debug('======== added 2');
                toReturn.add(ea);
            }
        }
        return toReturn;
        
    }
    
    private static List<Employee_Status__c> getEmployeeStatusByEmployeeIds(Set<Id> employeeIds) {
        return [
            SELECT Id, Status__c, Employee__c, Employee__r.Name
            FROM Employee_Status__c
            WHERE Employee__r.Active__c= true and Employee__c IN :employeeIds
        ];
    }
}