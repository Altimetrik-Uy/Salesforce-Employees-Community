public class EmployeeController {

    @AuraEnabled
    public static List<EmployeeWrapper> getEmployeeWithLastStatus() {
        List<EmployeeWrapper> wrapper = resolveUserEmployees();
        
        return wrapper;
    }
    
    public class EmployeeWrapper {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String employeeId { get; set; }
        @AuraEnabled public String employee { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public DateTime lastdate { get; set; }
    }
    
    private static List<EmployeeWrapper> resolveUserEmployees() {
        List<Managers_Assignment__c> userAssignments = getUserAssignments();
        Set<Id> userProjects = new Set<Id>();
        
        for (Managers_Assignment__c assignment : userAssignments) {
            userProjects.add(assignment.Project__c);
        }
        
        List<Employee_Assignment__c> employeeAssignments = getEmployeeAssignmentsByProjectId( userProjects );
        Set<Id> userEmployees = getEmployeesFromAssignments(employeeAssignments);
        
        Map<Id, Contact> userEmployeesById = new Map<Id, Contact>(
            getEmployeesById(userEmployees)
        );
        
        List<Employee_Status__c> employeeStatus = getEmployeeStatusByEmployeeId(userEmployees);
        Map<Id, Employee_Status__c> lastEmployeeStatusByEmployee = resolveLastEmployeeStatus(employeeStatus);
        
        return resolveEmployeeWrapper(userEmployeesById, lastEmployeeStatusByEmployee);
    }
    
    private static List<Managers_Assignment__c> getUserAssignments() {
        return [SELECT Id, Project__c, Sub_Project__c FROM Managers_Assignment__c WHERE User__c = :UserInfo.getUserId()];
    }
    
    private static List<Employee_Assignment__c> getEmployeeAssignmentsByProjectId( Set<Id> projectIds ) {
        
        List<Employee_Assignment__c> toReturn = new List<Employee_Assignment__c>();
        
        for (Employee_Assignment__c ea: [SELECT Id, Employee__c, Project__c,  Sub_Project__c 
                                         FROM Employee_Assignment__c 
                                         WHERE Project__c IN :projectIds 
                                         AND Employee__r.Active__c = true 
                                         AND End_Date__c >: date.today() 
                                         AND Base_Category__c!='']){
            toReturn.add(ea);
        }
        return toReturn;
    }
    
    private static List<Employee_Status__c> getEmployeeStatusByEmployeeId(Set<Id> employeeIds) {
        return [
            SELECT
               Id,
               Employee__c,
               Employee__r.Name,
               Status__c,
               LastModifiedDate
            FROM Employee_Status__c
            WHERE Employee__c IN :employeeIds
            ORDER BY LastModifiedDate DESC
        ];
    }
    
    private static Set<Id> getEmployeesFromAssignments(List<Employee_Assignment__c> employeeAssignments) {
        Set<Id> employees = new Set<Id>();
        
        for (Employee_Assignment__c assignment : employeeAssignments) {
            employees.add(assignment.Employee__c);
        }
        
        return employees;
    }
    
    private static Map<Id, Employee_Status__c> resolveLastEmployeeStatus(List<Employee_Status__c> employeeStatus) {
        Map<Id, Employee_Status__c> lastEmployeeStatusByEmployee = new Map<Id, Employee_Status__c>();
        
        for (Employee_Status__c eStatus : employeeStatus) {
            if (!lastEmployeeStatusByEmployee.containsKey(eStatus.Employee__c)) {
                lastEmployeeStatusByEmployee.put(eStatus.Employee__c, eStatus);
            }
        }
        
        return lastEmployeeStatusByEmployee;
    }
    
    private static List<Contact> getEmployeesById(Set<Id> employeeIds) {
        return [SELECT Id, Name FROM Contact WHERE Id IN :employeeIds];
    }
    
    private static List<EmployeeWrapper> resolveEmployeeWrapper(
        Map<Id, Contact> userEmployeesById,
        Map<Id, Employee_Status__c> lastEmployeeStatusByEmployee
    ) {
        List<EmployeeWrapper> wrapper = new List<EmployeeWrapper>();
        Map<Id, String> lastStatusByEmployee = new Map<Id, String>();
        
        for (Id employee : userEmployeesById.keySet()) {
            if (lastEmployeeStatusByEmployee.containsKey(employee)) {
                EmployeeWrapper newWrapper = getEmployeeWrapper(
                    lastEmployeeStatusByEmployee.get(employee)
                );

                wrapper.add(newWrapper);
            } else {
                Contact currentEmployee = userEmployeesById.get(employee);
                EmployeeWrapper newWrapper = getEmployeeWrapper(currentEmployee);

                wrapper.add(newWrapper);
            }
        }

        return wrapper;
    }
    
    private static EmployeeWrapper getEmployeeWrapper(Employee_Status__c employeeStatus) {
        EmployeeWrapper newWrapper = new EmployeeWrapper();
        newWrapper.id = employeeStatus.Id;
        newWrapper.employeeId = employeeStatus.Employee__c;
        newWrapper.employee = employeeStatus.Employee__r.Name;
        newWrapper.status = employeeStatus.Status__c;
        newWrapper.lastdate = employeeStatus.LastModifiedDate;
                    
        return newWrapper;
    }
    
    private static EmployeeWrapper getEmployeeWrapper(Contact employee) {
        EmployeeWrapper newWrapper = new EmployeeWrapper();
        newWrapper.id = '';
        newWrapper.employeeId = employee.Id;
        newWrapper.employee = employee.Name;
        newWrapper.status = '';
                    
        return newWrapper;
    }
}