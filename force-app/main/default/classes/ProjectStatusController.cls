public class ProjectStatusController {

    @AuraEnabled
    public static List<ProjectStatusWrapper> getUserProjectStatus() {
        List<ProjectStatusWrapper> wrapper = new List<ProjectStatusWrapper>();
        
        List<Project_Status__c> userProjectStatus = resolveUserProjectStatus();
        for (Project_Status__c projectStatus : userProjectStatus) {
            ProjectStatusWrapper newWrapper = new ProjectStatusWrapper();
            newWrapper.project = projectStatus.Project__r.Name;
            newWrapper.subProject = projectStatus.Sub_Project__r.Name;
            newWrapper.status = projectStatus.Status__c;
            newWrapper.id = projectStatus.Id;
            wrapper.add(newWrapper);
        }
        
        return wrapper;
    }
    
    @AuraEnabled
    public static void createProjectStatus(String project, String subProject, String status, String comments, String meetingDate) {
        // #todo support sub project
        try {
            Project_Status__c projectStatus = new Project_Status__c(
                Project__c = project,
                Sub_Project__c = subProject,
                Status__c = status,
                Comments__c = comments
            );
            
            if (String.isNotBlank(meetingDate)) {
                projectStatus.Meeting_Date__c = Date.valueOf(meetingDate);
            }
            system.debug('======== '+ projectStatus);
            insert projectStatus;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static Map<String, String> getStatus() {
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Project_Status__c.Status__c.getDescribe();

        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : pList) {
            options.put(entry.getValue(), entry.getLabel());
        }
        return options;
    }
    
    public class ProjectStatusWrapper {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String project { get; set; }
        @AuraEnabled public String subProject { get; set; }
        @AuraEnabled public String status { get; set; }
    }
    
    private static List<Project_Status__c> resolveUserProjectStatus() {
        List<Managers_Assignment__c> userAssignments = getUserAssignments();
        Set<Id> userProjects = new Set<Id>();
        
        for (Managers_Assignment__c assignment : userAssignments) {
            userProjects.add(assignment.Project__c);
        }
        
        return getProjectStatusByProjectId(userProjects);
    }
    
    private static List<Managers_Assignment__c> getUserAssignments() {
        return [SELECT Id, Project__c, Sub_Project__c FROM Managers_Assignment__c WHERE User__c = :UserInfo.getUserId()];
    }
    
    private static List<Project_Status__c> getProjectStatusByProjectId(Set<Id> projectIds) {
        return [SELECT Id, Project__c, Project__r.Name, Sub_Project__c, Sub_Project__r.Name, Status__c FROM Project_Status__c WHERE Project__c IN :projectIds];
    }
}