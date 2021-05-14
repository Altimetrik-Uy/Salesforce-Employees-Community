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
    public static List<Employee_Status__c> getEmployeeStatuses(String empId, Integer offsetRange){
        if(offsetRange == null){
            return [SELECT Id, Status__c, CreatedDate, Comments__c, CreatedBy.Name FROM Employee_Status__c WHERE Employee__r.Id =:empId ORDER BY CreatedDate DESC LIMIT 4];
        }else {
            return [SELECT Id, Status__c, CreatedDate, Comments__c, CreatedBy.Name FROM Employee_Status__c WHERE Employee__r.Id =:empId ORDER BY CreatedDate DESC LIMIT 4 OFFSET :offsetRange];
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getEmployeeStatusCount(String empId){
        return [SELECT COUNT() FROM Employee_Status__c WHERE Employee__r.Id = :empId];
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getManager(String empId){
        List<String> lstProjectsActive = new List<String>();
        for(Employee_Assignment__c activeProj : [SELECT Project__r.Id FROM Employee_Assignment__c WHERE Employee__r.Id = :empId AND Active__c = true]){
            lstProjectsActive.add(activeProj.Project__r.Id);
        }
        List<String> lstManagersId = new List<String>();
        if(!lstProjectsActive.isEmpty()){
            for(Managers_Assignment__c currentMA : [SELECT User__r.Id FROM Managers_Assignment__c WHERE Project__r.Id IN :lstProjectsActive ORDER BY Project__r.Id]){
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
        lstManagersId.add('You dont have manager assigned');
        return lstManagersId;
    }

    @AuraEnabled(cacheable=true)
    public static string getUser(String empId){
        return [SELECT Contact.Name FROM User WHERE Contact.Id =: empId LIMIT 1].Contact.Name;
    }
 
    @AuraEnabled
    public static Boolean sendMessage(List<String> lstManagersId, String userName){
       return feedMessage(lstManagersId, userName);
    }

    public static Boolean feedMessage(List<String> lstManagersId, String userName){
        String requestType = 'Status';

        List<Community_Request_Notification__c> statusNotification = [
            SELECT LastModifiedDate, OwnerId FROM Community_Request_Notification__c WHERE CreatedById = :UserInfo.getUserId() AND Request_type__c = :requestType LIMIT 1
            ];
            DateTime last24hours = System.Now()-1;
        try {
            if(statusNotification.isEmpty() || statusNotification.get(0).LastModifiedDate < last24hours){
                String postText = 'The Employee '  + userName + ' requests a status update.';
                Community_Request_Notification__c newStatusNotification = new Community_Request_Notification__c();
                newStatusNotification.Request_type__c = requestType;
                if(statusNotification.isEmpty()){
                    insert newStatusNotification;
                }else{
                    upsert statusNotification;
                }      
                  
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
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }
}



    
    