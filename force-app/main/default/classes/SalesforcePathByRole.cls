public without sharing class SalesforcePathByRole {
    @AuraEnabled
    public static Object getSalesforcePath(){
        return SalesforcePathByRole.getSalesforcePathFromSelectedRole(null);
    }

    @AuraEnabled(cacheable=true)
    public static Object getSalesforcePathFromSelectedRole(String selectedRole){
        string strRoleUser;
        string strTaUserInfoId;
        Set<Id> setUserCertifications = new Set<Id>();
        List<Salesforce_Career_Path__c> lstCareerPathNextRole = new List<Salesforce_Career_Path__c>();
        List<Salesforce_Career_Path__c> lstCareerPathByRole = new List<Salesforce_Career_Path__c>();
        List<ta_User_Certification__c> lstUserCertifiaction = new List<ta_User_Certification__c>();
        Map<string,List<wrpCertification>> mapRoleCertifications = new Map<string,List<wrpCertification>>();
        List<wrpRolesSalesforce> lstWrpRolesSalesforce = new List<wrpRolesSalesforce>();
        List<Contact> lstContact = [SELECT Id, Name, Role__c  FROM Contact WHERE Email =: UserInfo.getUserEmail()];
        List<ta_User_Info__c> lstTaUserinfo = [SELECT Id, Email__c, Name FROM ta_User_Info__c WHERE Email__c =: UserInfo.getUserEmail()];

        if (lstTaUserinfo != null && lstTaUserinfo.size() > 0) {
            strTaUserInfoId = lstTaUserinfo[0].Id;
            lstUserCertifiaction = [SELECT Id, Certification__c, Certification__r.Name, User_Info__c FROM ta_User_Certification__c WHERE User_Info__c =: strTaUserInfoId];            
            if(!lstUserCertifiaction.isEmpty()) {
                //User Certifications
                for(ta_User_Certification__c objUserCertification : lstUserCertifiaction) {
                    setUserCertifications.add(objUserCertification.Certification__c);
                }
            }   
        }
        
        if (lstContact != null && !lstContact.isEmpty()) {
            if(String.isBlank(selectedRole)){
                strRoleUser = lstContact[0].Role__c;
            }else {
                strRoleUser = 'Salesforce '+selectedRole;
            }
            //Get the user role
            lstCareerPathByRole = [SELECT Id, Certification__c, Certification__r.Name, Role__c, Required__c, Possible_Next_Role__c FROM Salesforce_Career_Path__c WHERE Role__c =: strRoleUser];
            if (!lstCareerPathByRole.isEmpty()) { 
                //Get next roles
                List<string> lstNextRole = (lstCareerPathByRole[0].Possible_Next_Role__c != null ? lstCareerPathByRole[0].Possible_Next_Role__c.split(';') : new List<String>());
                    //Get the certification per role 
                    lstCareerPathNextRole = [SELECT Id, Certification__c, Certification__r.Name, Role__c, Required__c FROM Salesforce_Career_Path__c WHERE Role__c IN: lstNextRole ORDER BY Role__c];
                        lstCareerPathByRole.addAll(lstCareerPathNextRole);
                        for(Salesforce_Career_Path__c objNextRoleCertification : lstCareerPathByRole) {
                            list<wrpCertification> lstTmpWrpCertification;
                            wrpCertification objWrpCertification = new wrpCertification();
                            objWrpCertification.srtCertification = objNextRoleCertification.Certification__r.Name;
                            objWrpCertification.bnlRequired = objNextRoleCertification.Required__c;
                            objWrpCertification.strIdPathRecord = objNextRoleCertification.Id;
                            if(setUserCertifications.contains(objNextRoleCertification.Certification__c)){
                                objWrpCertification.blnAchieved = true;
                            }

                            if (mapRoleCertifications.containsKey(objNextRoleCertification.Role__c)) {
                                lstTmpWrpCertification = mapRoleCertifications.get(objNextRoleCertification.Role__c);
                                lstTmpWrpCertification.add(objWrpCertification);
                            }
                            else{
                                lstTmpWrpCertification = new list<wrpCertification>();
                                lstTmpWrpCertification.add(objWrpCertification);
                                mapRoleCertifications.put(objNextRoleCertification.Role__c, lstTmpWrpCertification);
                            }
                        }

                if(!mapRoleCertifications.isEmpty()) {
                    Integer intTableNumber = 1;
                    for(string strRole : mapRoleCertifications.keySet()) {
                        wrpRolesSalesforce objWrpRoleSalesforce = new wrpRolesSalesforce();
                        objWrpRoleSalesforce.strRole = strRole;
                        objWrpRoleSalesforce.lstWrpCertifications = mapRoleCertifications.get(strRole);
                        if(strRole == strRoleUser){
                            objWrpRoleSalesforce.blnCurrentRole = true;
                        }
                        if(intTableNumber >= 3) {
                            objWrpRoleSalesforce.blnExtraTable = true;
                        }
                        lstWrpRolesSalesforce.add(objWrpRoleSalesforce);
                        intTableNumber++;
                    }
                }
            }
        }
        return lstWrpRolesSalesforce;
    }

    public class wrpCertification {
        @AuraEnabled public Boolean blnAchieved = false;
        @AuraEnabled public Boolean bnlRequired = false;
        @AuraEnabled public String srtCertification;
        @AuraEnabled public String strIdPathRecord;
    }

    public class wrpRolesSalesforce {
        @AuraEnabled public String strRole;
        @AuraEnabled public Boolean blnCurrentRole = false;
        @AuraEnabled public Boolean blnExtraTable = false;
        @AuraEnabled public List<wrpCertification> lstWrpCertifications = new List<wrpCertification>();
    }
}