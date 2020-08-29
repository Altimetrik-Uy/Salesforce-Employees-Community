public with Sharing class lookupfieldController {    
    @AuraEnabled
    public static List<sObject> GetRecentRecords(String ObjectName, List<String> ReturnFields, Integer MaxResults) {
        
        List<Id> recentIds = new List<Id>();
        List<Id> projectIds = new List<Id>();
        List<Id> employeeIds = new List<Id>();
        for(RecentlyViewed recent : [SELECT Id FROM RecentlyViewed WHERE Type = :ObjectName ORDER BY LastViewedDate DESC LIMIT :MaxResults]) {
            recentIds.add(recent.Id);
        }
        
        // TODO this should be refactored to make the component reusable
        // probably here we should resolve the "period" value from a custom setting
        Date period = Date.today().addMonths(-1);
        if (ObjectName == 'Opportunity') {
            recentIds = resolveUserLookupField('Opportunity');
        } else if (ObjectName == 'Contact') {
            recentIds = resolveUserLookupField('Contact');
        }
        
        String sQUERY = 'SELECT Id, ';
        
        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        sQuery += ' FROM ' + ObjectName + ' WHERE Id IN :recentIds';
        
        List<sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static List<sObject> SearchRecords(String ObjectName, List<String> ReturnFields, List<String> QueryFields, String SearchText, String SortColumn, String SortOrder, Integer MaxResults, String Filter) {
        // TODO this should be refactored to make the component reusable
        // probably here we should resolve the "period" value from a custom setting
        Date period = Date.today().addMonths(-1);
        if (objectName == 'Opportunity') {
            List<Id> projectIds = resolveUserLookupField('Opportunity');
            
            return [SELECT Id, Name, CloseDate FROM Opportunity WHERE Id IN :projectIds LIMIT :MaxResults];
        } else if (objectName == 'Contact') {
            List<Id> employeeIds = resolveUserLookupField('Contact');
            
            return [SELECT Id, Name FROM Contact WHERE Id IN :employeeIds LIMIT :MaxResults];
        }

        //always put a limit on the results
        if (MaxResults == null || MaxResults == 0) {
            MaxResults = 5;
        }
        
        SearchText = '%' + SearchText + '%';
        
        List <sObject > returnList = new List < sObject > ();
        
        String sQuery =  'SELECT Id, ';
        
        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        sQuery += ' FROM ' + ObjectName + ' WHERE ';
        
        if (QueryFields == null || QueryFields.isEmpty()) {
            sQuery += ' Name LIKE :SearchText ';
        } else {
            string likeField = '';
            for(string field : QueryFields) {
                likeField += ' OR ' + field + ' LIKE :SearchText ';    
            }
            sQuery += ' (' + likeField.removeStart(' OR ') + ') ';
        }
        
        if (Filter != null) {
            sQuery += ' AND (' + Filter + ')';
        }
        
        if(string.isNotBlank(SortColumn) && string.isNotBlank(SortOrder)) {
            sQuery += ' ORDER BY ' + SortColumn + ' ' + SortOrder;
        }
        
        sQuery += ' LIMIT ' + MaxResults;
        
        List <sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static List<sObject> GetRecord(String ObjectName, List<String> ReturnFields, String Id) {
        String sQUERY = 'SELECT Id, ';
        
        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        sQuery += ' FROM ' + ObjectName + ' WHERE Id = :Id';
        
        List<sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static string findObjectIcon(String ObjectName) {    
        String u;
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        
        for(Schema.DescribeTabSetResult describeTabSetResult : Schema.describeTabs()) {
            for(Schema.DescribeTabResult describeTabResult : describeTabSetResult.getTabs()) {
                if(describeTabResult.getSobjectName() == ObjectName) { 
                    if( describeTabResult.isCustom() == true ) {
                        for (Schema.DescribeIconResult describeIcon : describeTabResult.getIcons()) {
                            if (describeIcon.getContentType() == 'image/svg+xml'){
                                return 'custom:' + describeIcon.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                            }
                        }
                    } else {
                        return 'standard:' + ObjectName.toLowerCase();
                    }
                }
            }
        }
        
        return 'standard:default';
    }
    
    @AuraEnabled
    public static objectDetails getObjectDetails(String ObjectName) {    
        
        objectDetails details = new objectDetails();
        
        Schema.DescribeSObjectResult describeSobjectsResult = Schema.describeSObjects(new List<String>{ObjectName})[0];
        
        details.label = describeSobjectsResult.getLabel();
        details.pluralLabel = describeSobjectsResult.getLabelPlural();
        
        details.iconName = findObjectIcon(ObjectName);
        
        return details;
    }
    
    public class objectDetails {
        @AuraEnabled
        public string iconName;
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string pluralLabel;
    }
    
    public static List<Id> resolveUserLookupField(String objectName) {
        List<Managers_Assignment__c> userAssignments = getUserAssignments();
        Set<Id> userProjects = new Set<Id>();
        
        for (Managers_Assignment__c assignment : userAssignments) {
            userProjects.add(assignment.Project__c);
        }

        if (objectName == 'Opportunity') {
            return new List<Id>(userProjects);
        }

        return resolveEmployeesDiff(userProjects);
    }
    
    private static List<Id> resolveEmployeesDiff(Set<Id> userProjects) {
        List<Employee_Assignment__c> employeeAssignments = getEmpoyeeAssignmentsByProject(userProjects);
        Set<Id> userEmployees = new Set<Id>();
        
        for (Employee_Assignment__c assignment : employeeAssignments) {
            userEmployees.add(assignment.Employee__c);
        }
        
        return new List<Id>(userEmployees);
    }
    
    private static List<Managers_Assignment__c> getUserAssignments() {
        return [SELECT Id, Project__c FROM Managers_Assignment__c WHERE User__c = :UserInfo.getUserId()];
    }
    
    private static List<Employee_Assignment__c> getEmpoyeeAssignmentsByProject(Set<Id> projectIds) {
        return [SELECT Id, Employee__c FROM Employee_Assignment__c WHERE Project__c IN :projectIds];
    }
}