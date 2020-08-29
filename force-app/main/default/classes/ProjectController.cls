public class ProjectController {
    
    @AuraEnabled
    public static List<ProjectWrapper> getProjectWithLastStatus() {
        List<ProjectWrapper> wrapper = resolveUserProjects();
        
        return wrapper;
    }
    
    public class ProjectWrapper {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String projectId { get; set; }
        @AuraEnabled public String project { get; set; }
        @AuraEnabled public String subProjectId { get; set; }
        @AuraEnabled public String subProject { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public DateTime lastdate { get; set; }
    }
    
    private static List<ProjectWrapper> resolveUserProjects() {
        List<Managers_Assignment__c> userAssignments = getUserAssignments();
        Map<Id, Set<Id>> userProjects = new Map<Id, Set<Id>>();
        
        for (Managers_Assignment__c assignment : userAssignments) {
            if (userProjects.get(assignment.Project__c) == null){
                Set<Id> aux = new Set<Id>();
                aux.add(assignment.Sub_Project__c);
                userProjects.put(assignment.Project__c, aux);
            }else{
                userProjects.get(assignment.Project__c).add(assignment.Sub_Project__c);
            }
            
        }
        
        Map<Id, List<Sub_Project__c>> userProjectsById = new Map<Id, List<Sub_Project__c>>(
            getProjectsById(userProjects)
        );
        
        List<Project_Status__c> projectStatus = getProjectStatusByProjectId(userProjects);
        Map<String, Project_Status__c> lastProjectStatusByProject = resolveLastProjectStatus(projectStatus);
        
        return resolveProjectWrapper(userProjectsById, lastProjectStatusByProject);
    }
    
    private static List<Managers_Assignment__c> getUserAssignments() {
        return [SELECT Id, Project__c, Sub_Project__c FROM Managers_Assignment__c WHERE User__c = :UserInfo.getUserId()];
    }
    
    private static List<Project_Status__c> getProjectStatusByProjectId(Map<Id, Set<Id>> projectIds) {
        return [
            SELECT
               Id,
               Project__c,
               Project__r.Name,
               Sub_Project__c,
               Sub_Project__r.Name, 
               Status__c,
               LastModifiedDate
            FROM Project_Status__c
            WHERE Project__c IN :projectIds.keyset()
            ORDER BY LastModifiedDate DESC
        ];
    }
    
    private static Map<String, Project_Status__c> resolveLastProjectStatus(List<Project_Status__c> projectStatus) {
        Map<String, Project_Status__c> lastProjectStatusByProject = new Map<String, Project_Status__c>();
        
        for (Project_Status__c pStatus : projectStatus) {
            String k = '';
            if (pStatus.Sub_Project__c != null){
                k = pStatus.Project__c + '-'+ pStatus.Sub_Project__c;
            }else{
                k = pStatus.Project__c; 
            }
            if (!lastProjectStatusByProject.containsKey(k)) {
                lastProjectStatusByProject.put(k, pStatus);
            }
        }
        
        return lastProjectStatusByProject;
    }
    
    private static Map<Id, List<Sub_Project__c>> getProjectsById(Map<Id, Set<Id>> projectIds) {
        Set<Id> oppIds = projectIds.keySet();
        List<Opportunity> opps = [SELECT Id, Name FROM Opportunity WHERE Id IN :oppIds];
        Map<Id, List<Sub_Project__c>> aux1 = new Map<Id, List<Sub_Project__c>>();
        for (Opportunity o: opps){
            aux1.put(o.Id, new List<Sub_Project__c>());
        }
            
        Set<Id> aux = new Set<Id>();
		for (Id i: projectIds.keySet()){
            aux.addAll(projectIds.get(i));
        }
        
        for (Sub_Project__c sp: [ SELECT id, Name, Project__c from Sub_Project__c where id in: aux]){
            if (aux1.containsKey(sp.Project__c)){
                aux1.get(sp.Project__c).add(sp);
            }else{
                List<Sub_Project__c> a = new List<Sub_Project__c>();
                a.add(sp);
                aux1.put(sp.Project__c, a);
            }
        }
        return aux1;
    }
    
    private static List<ProjectWrapper> resolveProjectWrapper(
        Map<Id, List<Sub_Project__c>> userProjectsById,
        Map<String, Project_Status__c> lastProjectStatusByProject
    ) {
        system.debug('=====lastProjectStatusByProject ='+ lastProjectStatusByProject);
        List<ProjectWrapper> wrapper = new List<ProjectWrapper>();
        Map<Id, String> lastStatusByProject = new Map<Id, String>();
        Map<id, Opportunity> opps = new Map<id, Opportunity>([SELECT Id, Name FROM Opportunity WHERE Id IN :userProjectsById.keySet()]);
        for (Id project : userProjectsById.keySet()) {
            
            if (userProjectsById.get(project).size()>0){
                // tiene subprojects
                for (Sub_Project__c subProject : userProjectsById.get(project)){
                    
                    String k = project + '-' + subProject.Id;
                    system.debug('===== k ='+ k);
                    if (lastProjectStatusByProject.containsKey(k)) {
                        ProjectWrapper newWrapper = getProjectWrapper(
                            lastProjectStatusByProject.get(k)
                        );
        
                        wrapper.add(newWrapper);
                    } else {
                        ProjectWrapper newWrapper = getProjectWrapper(opps.get(project), subProject);
                        wrapper.add(newWrapper);
                    }
                }
            }else{
                
                if (lastProjectStatusByProject.containsKey(project)) {
                    ProjectWrapper newWrapper = getProjectWrapper(
                        lastProjectStatusByProject.get(project)
                    );
    
                    wrapper.add(newWrapper);
            	} else {
                    ProjectWrapper newWrapper = getProjectWrapper(opps.get(project), null);
   
                    wrapper.add(newWrapper);
                }
        	}
            
        }
            

        return wrapper;
    }
    
    private static ProjectWrapper getProjectWrapper(Project_Status__c projectStatus) {
        ProjectWrapper newWrapper = new ProjectWrapper();
        newWrapper.id = projectStatus.Id;
        newWrapper.projectId = projectStatus.Project__c;
        newWrapper.project = projectStatus.Project__r.Name;
        newWrapper.subProjectId = projectStatus.Sub_Project__c;
        newWrapper.subProject = projectStatus.Sub_Project__r.Name;
        
        newWrapper.status = projectStatus.Status__c;
        newWrapper.lastdate = projectStatus.LastModifiedDate;
                    
        return newWrapper;
    }
    
    private static ProjectWrapper getProjectWrapper(Opportunity project, Sub_Project__c sp) {
        ProjectWrapper newWrapper = new ProjectWrapper();
        newWrapper.id = '';
        newWrapper.projectId = project.Id;
        newWrapper.project = project.Name;
        if (sp!= null){
            newWrapper.subProjectId = sp.Id;
        	newWrapper.subProject = sp.Name;
        }
        
        newWrapper.status = '';
                    
        return newWrapper;
    }
}