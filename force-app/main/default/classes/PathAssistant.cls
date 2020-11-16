public with sharing class PathAssistant {
    @AuraEnabled
    public static List<wrpColumns> getPath(){
        string strCurrentRole = '';
        Map<string,List<wrpRoles>> mapPositionXCareer = new Map<string,List<wrpRoles>>();
        List<Salesforce_Career_Path_Settings__mdt> lstCareerPathSettings = new List<Salesforce_Career_Path_Settings__mdt>();
        List<wrpColumns> lstWrpColumns = new List<wrpColumns>();

        List<Contact> lstContact = [SELECT Id, Name, Role__c 
                                    FROM Contact 
                                    WHERE Email =: UserInfo.getUserEmail()];

        if(!Test.isRunningTest()) {
             lstCareerPathSettings = [SELECT Id, MasterLabel, Position__c
                                        FROM Salesforce_Career_Path_Settings__mdt
                                        ORDER BY Position__c];
        }
        else {
            Salesforce_Career_Path_Settings__mdt mdtCareerPath1 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath1.MasterLabel = 'Trainee';
            mdtCareerPath1.Position__c = 11;
            lstCareerPathSettings.add(mdtCareerPath1);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath2 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath2.MasterLabel = 'Developer';
            mdtCareerPath2.Position__c = 12;
            lstCareerPathSettings.add(mdtCareerPath2);
        }
        
        if (lstContact != null) {
            strCurrentRole = lstContact[0].Role__c;
        }

        if (!lstCareerPathSettings.isEmpty()) {
            wrpRoles objWrpRole;
            List<wrpRoles> lstCareerTmp;
            for (Salesforce_Career_Path_Settings__mdt objCareerPath : lstCareerPathSettings) {
                String strColumn = objCareerPath.Position__c.format().substring(0,1);
                String strRoleSalesforce = 'Salesforce ' + objCareerPath.MasterLabel;
                objWrpRole = new wrpRoles();
                    objWrpRole.strRole = objCareerPath.MasterLabel;
                    if(strRoleSalesforce == strCurrentRole){
                        objWrpRole.blnCurrentRole = true;
                    }
                if (mapPositionXCareer.containsKey(strColumn)){
                    lstCareerTmp = mapPositionXCareer.get(strColumn);
                        lstCareerTmp.add(objWrpRole);
                }
                else {
                    lstCareerTmp = new List<wrpRoles>();
                    lstCareerTmp.add(objWrpRole);
                    mapPositionXCareer.put(strColumn,lstCareerTmp);
                }
            }
        }

        if (!mapPositionXCareer.isEmpty()) {
            for (string strPosition : mapPositionXCareer.keySet()) {
                wrpColumns objWrpColumn = new wrpColumns();
                objWrpColumn.strColumn = strPosition;
                objWrpColumn.lstWrpRoles = mapPositionXCareer.get(strPosition);
                lstWrpColumns.add(objWrpColumn);
            }
        }
        return lstWrpColumns;
    }

    public class wrpRoles {
        @AuraEnabled public Boolean blnCurrentRole = false;
        @AuraEnabled public string strRole;
    }

    public class wrpColumns {
        @AuraEnabled public String strColumn;
        @AuraEnabled public List<wrpRoles> lstWrpRoles = new List<wrpRoles>();
    }
}