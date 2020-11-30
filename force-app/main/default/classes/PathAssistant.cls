public with sharing class PathAssistant {
    @AuraEnabled(cacheable=true)
    public static List<wrpColumns> getPath(String empId){
        string strCurrentRole = '';
        Map<string,List<wrpRoles>> mapPositionXCareer = new Map<string,List<wrpRoles>>();
        List<Salesforce_Career_Path_Settings__mdt> lstCareerPathSettings = new List<Salesforce_Career_Path_Settings__mdt>();
        List<wrpColumns> lstWrpColumns = new List<wrpColumns>();

        List<Contact> lstContact = [SELECT Id, Name, Role__c 
                                    FROM Contact 
                                    WHERE Id =: empId];
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

        Set<String> preRoles = calculatePreRole(strCurrentRole);

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
                    }else{
                        objWrpRole.blnIsPreRole = preRoles.contains(strRoleSalesforce);
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
        @AuraEnabled public Boolean blnIsPreRole = false;
    }

    public class wrpColumns {
        @AuraEnabled public String strColumn;
        @AuraEnabled public List<wrpRoles> lstWrpRoles = new List<wrpRoles>();
    }

    private static Set<String> calculatePreRole (String currentRole){
        Set<String> preRoles = new Set<String>();
        if(currentRole.equals('Salesforce Developer')){
            preRoles.add('Salesforce Trainee');
        } else if(currentRole.equals('Salesforce Lightning Specialist') || currentRole.equals('Salesforce Apex Specialist')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
        } else if(currentRole.equals('Salesforce Platform Specialist')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
            preRoles.add('Salesforce Lightning Specialist');
            preRoles.add('Salesforce Apex Specialist');
        } else if(currentRole.equals('Salesforce Senior Lightning Specialist')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
            preRoles.add('Salesforce Lightning Specialist');
        } else if(currentRole.equals('Salesforce Senior Apex Specialist')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
            preRoles.add('Salesforce Apex Specialist');
        }  else if(currentRole.equals('Salesforce Senior Platform Specialist')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
            preRoles.add('Salesforce Lightning Specialist');
            preRoles.add('Salesforce Apex Specialist');
            preRoles.add('Salesforce Platform Specialist');
        } else if(currentRole.equals('Salesforce Team Lead')|| currentRole.equals('Salesforce Technical Architect')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
            preRoles.add('Salesforce Lightning Specialist');
            preRoles.add('Salesforce Apex Specialist');
            preRoles.add('Salesforce Platform Specialist');
            preRoles.add('Salesforce Senior Lightning Specialist');
            preRoles.add('Salesforce Senior Apex Specialist');
            preRoles.add('Salesforce Senior Platform Specialist');
        } else if(currentRole.equals('Salesforce Manager')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
            preRoles.add('Salesforce Lightning Specialist');
            preRoles.add('Salesforce Apex Specialist');
            preRoles.add('Salesforce Platform Specialist');
            preRoles.add('Salesforce Senior Lightning Specialist');
            preRoles.add('Salesforce Senior Apex Specialist');
            preRoles.add('Salesforce Senior Platform Specialist');
            preRoles.add('Salesforce Team Lead');
        } else if(currentRole.equals('Salesforce Certified Architect')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
            preRoles.add('Salesforce Lightning Specialist');
            preRoles.add('Salesforce Apex Specialist');
            preRoles.add('Salesforce Platform Specialist');
            preRoles.add('Salesforce Senior Lightning Specialist');
            preRoles.add('Salesforce Senior Apex Specialist');
            preRoles.add('Salesforce Senior Platform Specialist');
            preRoles.add('Salesforce Tech Architect');
        } else if(currentRole.equals('Salesforce Delivery Manager')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
            preRoles.add('Salesforce Lightning Specialist');
            preRoles.add('Salesforce Apex Specialist');
            preRoles.add('Salesforce Platform Specialist');
            preRoles.add('Salesforce Senior Lightning Specialist');
            preRoles.add('Salesforce Senior Apex Specialist');
            preRoles.add('Salesforce Senior Platform Specialist');
            preRoles.add('Salesforce Team Lead');
            preRoles.add('Salesforce Manager');
        } else if(currentRole.equals('Salesforce Architect Chief')){
            preRoles.add('Salesforce Trainee');
            preRoles.add('Salesforce Developer');
            preRoles.add('Salesforce Lightning Specialist');
            preRoles.add('Salesforce Apex Specialist');
            preRoles.add('Salesforce Platform Specialist');
            preRoles.add('Salesforce Senior Lightning Specialist');
            preRoles.add('Salesforce Senior Apex Specialist');
            preRoles.add('Salesforce Senior Platform Specialist');
            preRoles.add('Salesforce Tech Architect');
            preRoles.add('Salesforce Certified Architect');  
        }
        return preRoles;
    }
}