public class LWCEmployeeStatusController {

    @AuraEnabled(cacheable=true)
    public static List<Employee_Assignment__c> getEmployeeProjects(String empId){
        List<Employee_Assignment__c> eAList = new List<Employee_Assignment__c>();
        //Get projects only once
        Id auxId;
        for (Employee_Assignment__c current_eA : [SELECT Project__r.Id, Project__r.Name FROM Employee_Assignment__c WHERE Employee__r.Id = :empId ORDER BY Project__r.Name]){
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
    public static List<Employee_Status__c> getEmployeeStatuses(Id projId, String empId, Boolean allSelected, Integer offsetRange){
        if(allSelected) {
            if(offsetRange == null){
                return [SELECT Id, Status__c, Meeting_Date__c, Comments__c, CreatedBy.Name FROM Employee_Status__c WHERE Employee__r.Id =:empId ORDER BY Meeting_Date__c DESC LIMIT 4];
            }else {
                return [SELECT Id, Status__c, Meeting_Date__c, Comments__c, CreatedBy.Name FROM Employee_Status__c WHERE Employee__r.Id =:empId ORDER BY Meeting_Date__c DESC LIMIT 4 OFFSET :offsetRange];
            }
        }else{
            if(offsetRange == null){
                return  [SELECT Status__c, Meeting_Date__c, Comments__c, CreatedBy.Name, Project__r.Name FROM Employee_Status__c WHERE Project__r.Id =: projId ORDER BY Meeting_Date__c DESC LIMIT 4]; 
            }else{
                return [SELECT Status__c, Meeting_Date__c, Comments__c, CreatedBy.Name, Project__r.Name FROM Employee_Status__c WHERE Project__r.Id =: projId ORDER BY Meeting_Date__c DESC LIMIT 4 OFFSET :offsetRange]; 
            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getEmployeeStatusCount(Id projId, String empId, Boolean allSelected){
        if (allSelected) {
            return [SELECT COUNT() FROM Employee_Status__c WHERE Employee__r.Id = :empId];
        }else{
            return [SELECT COUNT() FROM Employee_Status__c WHERE Employee__r.Id = :empId AND Project__r.Id = :projId];
        }
    }

    public static List<Employee_Status__c> getAllEmployeeStatuses(String empId){
        return [SELECT Id, Status__c, Meeting_Date__c, Comments__c, CreatedBy.Name FROM Employee_Status__c WHERE Employee__r.Id =:empId ORDER BY Meeting_Date__c DESC];
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getManager(String projId){
       List<String> lstManagersId = new List<String>();
        for(Managers_Assignment__c currentMA : [SELECT User__r.Id FROM Managers_Assignment__c WHERE Project__r.Id = :projId ORDER BY Project__r.Id]){
            if(lstManagersId.isEmpty()) {
                lstManagersId.add(currentMA.User__r.Id);
            }else{
                if(!lstManagersId.contains(currentMA.User__r.Id)){
                    lstManagersId.add(currentMA.User__r.Id);
                }
            }
       } 
       return lstManagersId;
    }

    @AuraEnabled(cacheable=true)
    public static string getUser(String empId){
        return [SELECT Contact.Name FROM User WHERE Contact.Id =: empId LIMIT 1].Contact.Name;
    }

     @AuraEnabled(cacheable=true)
    public static Boolean getProjectActiveStauts(String empId, Id projId){
            try {
                return [SELECT Active__c FROM Employee_Assignment__c WHERE Employee__r.Id = :empId AND Project__r.Id =: projId ORDER BY Active__c DESC LIMIT 1].Active__c;
            } catch (Exception e) {
                return false;
           }  
    }
 
    @AuraEnabled
    public static Boolean sendMessage(List<String> lstManagersId, String userName){
       return feedMessage(lstManagersId, userName);
    }

    public static Boolean feedMessage(List<String> lstManagersId, String userName){
        try {
            String postText = 'The Employee '  + userName + ' request a status update';
            // Define the FeedItemInput object to pass to postFeedElement
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            textSegmentInput.text = postText;
            //The MessageBodyInput object holds the text in the post
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);
            feedItemInput.body = messageBodyInput;
            // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
            // For this feed item, we define a direct message capability to hold the member(s) and the subject.
            List<String> memberIds = new List<String>();
            for(String currentId : lstManagersId){
                memberIds.add(currentId);
            }
            ConnectApi.DirectMessageCapabilityInput dmInput = new ConnectApi.DirectMessageCapabilityInput();
            dmInput.subject = 'Thank you!';
            dmInput.membersToAdd = memberIds;
            ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
            feedElementCapabilitiesInput.directMessage = dmInput;
            feedItemInput.capabilities = feedElementCapabilitiesInput;
            // Post the feed item. 
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput); 
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}



    
    