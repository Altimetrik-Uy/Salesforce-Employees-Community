public class LWCEmployeeOverallController{
    @AuraEnabled(cacheable=true)
    public static List<Project_Status__c> getProjectStatusImageName(String uId){
        try{   
        //Obtain the ContactId of the logged in user
           String contactId = [SELECT Contact.Id FROM User WHERE Id = :uId LIMIT 1].Contact.Id;
           if(contactId != null){
                List<Project_Status__c> proSRet = new List<Project_Status__c>();
                //Get Opprotunities from Employee_Assignment__c
                List<Id> projectsId = new List<Id>();
                for(Employee_Assignment__c currentEA : [SELECT Project__r.Id FROM Employee_Assignment__c WHERE Employee__r.Id = :contactId AND Active__c = true ORDER BY CreatedDate DESC]){
                    projectsId.add(currentEA.Project__r.Id);
                }
                /* Get the Project Status where the employee is implecated, the list is order by Project id then Meeting Date to contemplate 
                the case that the Project have more than 1 employee Assignation */
                List<Project_Status__c> pS = [SELECT Status__c, Project__r.Name, Project__r.Id, Meeting_Date__c FROM Project_Status__c WHERE Project__r.Id IN :projectsId ORDER BY  Project__r.Id DESC, Meeting_Date__c DESC];
                //Get the values form the Status__c picklist 
                List<String> statusColor = getPicklistValues('Project_Status__c', 'Status__c');
                //Add one Status Project per Porject 
                List<Project_Status__c> pStatuses = new List<Project_Status__c>();
                Id auxId ;
                for(Project_Status__c current_pS : pS){
                    if(pStatuses.isEmpty()) {
                        pStatuses.add(current_pS);
                        auxId = current_pS.Project__r.Id;
                    }else{
                        if(current_pS.Project__r.Id != auxId){
                            pStatuses.add(current_pS);
                            auxId = current_pS.Project__r.Id;
                        }
                    }
                }
                //Add 3 Status Project for the return with the Status Color preference
                List<Project_Status__c> pStatusesOrderByStatus = new List<Project_Status__c>();
                for(String current_color : statusColor){
                    for(Project_Status__c current_pStatuses : pStatuses){
                        if (current_color.equals(current_pStatuses.Status__c) && pStatusesOrderByStatus.size() < 3) {
                            pStatusesOrderByStatus.add(current_pStatuses);
                        }
                    }
                }
                return pStatusesOrderByStatus;
            }else{
                return new  List<Project_Status__c>();
            }
        }catch(Exception ex){
            return new  List<Project_Status__c>();
        }
    }

    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        //Sort the list Desc, so we have Red, Yellow, Green
        List<String> finalList = new List<String>();
        for(Integer i = lstPickvals.size()-1; i>=0;i--)
        {
            finalList.add(lstPickvals.get(i));
        }
        return finalList;
    }

    @AuraEnabled (cacheable=true)
    public static String getStatusImageName(String uId){
        String imageName = '';
        try{
            String contactId = [SELECT Contact.Id FROM User WHERE Id =:uId LIMIT 1].Contact.Id;
            Employee_Status__c eStatus = [SELECT Id, Status__c, Employee__c, Employee__r.LastName FROM Employee_Status__c WHERE Employee__r.Id =: contactId ORDER BY CreatedDate DESC LIMIT 1].get(0);
            imageName = eStatus.Status__c;
        }catch(Exception ex){
            imageName = 'Black';
        }
        return imageName;
    }

    @AuraEnabled (cacheable=true)
    public static String getTrailBlazerId(String uId){
        String trailBlazerId = '';
        try{   
            //Obtain the ContactId of the logged in user
            String contactId = [SELECT Contact.Id FROM User WHERE Id = :uId LIMIT 1].Contact.Id;
            Contact userEmail = [SELECT Email FROM Contact WHERE Id = :contactId];
            ta_User_Info__c infoTrailBlazerId = [SELECT Email__c, TrailBlazerId__c FROM ta_User_Info__c WHERE Email__c = :userEmail.Email];
            trailBlazerId = infoTrailBlazerId.TrailBlazerId__c;
        }catch(Exception ex){
            trailBlazerId = '';
        }
        return trailBlazerId;
    }

    @AuraEnabled
    public static void insertTrailBlazerId(String uId, String newTrailBlazerId){
        String contactId = [SELECT Contact.Id FROM User WHERE Id = :uId LIMIT 1].Contact.Id;
        Contact userEmail = [SELECT Email FROM Contact WHERE Id = :contactId];
        ta_User_Info__c idUserInfo = [SELECT Id FROM ta_User_Info__c WHERE Email__c = :userEmail.Email];
        idUserInfo.TrailBlazerId__c = newTrailBlazerId;
        update(idUserInfo);
    }
}
