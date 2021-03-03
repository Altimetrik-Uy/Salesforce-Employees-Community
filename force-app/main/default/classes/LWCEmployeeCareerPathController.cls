public class LWCEmployeeCareerPathController {

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
        
        try {
            String postText = 'The Employee '  + userName + ' requests a role change.';
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
