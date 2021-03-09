public with sharing class PathAssistant {
    public static List<wrpColumns> getPath(String empId, String mainRole){
        string strCurrentRole = (mainRole != null && !String.isEmpty(mainRole)) ? mainRole : '';
        Map<string,List<wrpRoles>> mapPositionXCareer = new Map<string,List<wrpRoles>>();
        List<Salesforce_Career_Path_Settings__mdt> lstCareerPathSettings = new List<Salesforce_Career_Path_Settings__mdt>();
        List<Salesforce_Career_Path_Settings__mdt> lstQaCareerPathSettings = new List<Salesforce_Career_Path_Settings__mdt>();
        List<wrpColumns> lstWrpColumns = new List<wrpColumns>();

        if (empId != null && !String.isEmpty(empId) ) {
            List<Contact> lstContact = [SELECT Id, Name, Role__c 
                                    FROM Contact 
                                    WHERE Id =: empId];

            if (lstContact != null) {
                strCurrentRole = lstContact[0].Role__c;
            }
        }
        
        if(!Test.isRunningTest()) {
             lstCareerPathSettings = [SELECT Id, MasterLabel, Position__c
                                        FROM Salesforce_Career_Path_Settings__mdt
                                        WHERE NOT MasterLabel LIKE 'QA%'
                                        ORDER BY Position__c];
            lstQaCareerPathSettings = [SELECT Id, MasterLabel, Position__c
                                        FROM Salesforce_Career_Path_Settings__mdt
                                        WHERE MasterLabel LIKE 'QA%'
                                        ORDER BY Position__c];
        } else {
            // Test method metadata
            Salesforce_Career_Path_Settings__mdt mdtCareerPath1 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath1.MasterLabel = 'Developer';
            mdtCareerPath1.Position__c = 12;
            lstCareerPathSettings.add(mdtCareerPath1);
            
            Salesforce_Career_Path_Settings__mdt mdtCareerPath2 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath2.MasterLabel = 'Platform Specialist';
            mdtCareerPath2.Position__c = 33;
            lstCareerPathSettings.add(mdtCareerPath2);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath4 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath4.MasterLabel = 'Salesforce Senior Platform Specialist';
            mdtCareerPath4.Position__c = 43;
            lstCareerPathSettings.add(mdtCareerPath4);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath7 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath7.MasterLabel = 'Salesforce Delivery Manager';
            mdtCareerPath7.Position__c = 51;
            lstCareerPathSettings.add(mdtCareerPath7);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath8 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath8.MasterLabel = 'Salesforce Architect Chief';
            mdtCareerPath8.Position__c = 52;
            lstCareerPathSettings.add(mdtCareerPath8);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath9 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath9.MasterLabel = 'Salesforce Team Lead';
            mdtCareerPath9.Position__c = 61;
            lstCareerPathSettings.add(mdtCareerPath9);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath3 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath3.MasterLabel = 'QA Manager';
            mdtCareerPath3.Position__c = 61;
            lstQaCareerPathSettings.add(mdtCareerPath3);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath5 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath5.MasterLabel = 'QA Lead';
            mdtCareerPath5.Position__c = 41;
            lstQaCareerPathSettings.add(mdtCareerPath5);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath6 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath6.MasterLabel = 'QA Automation Specialist';
            mdtCareerPath6.Position__c = 42;
            lstQaCareerPathSettings.add(mdtCareerPath6);
        }
        
        

        Set<String> devPreRoles = calculateDevPreRole(strCurrentRole);
        Set<String> qaPreRoles = calculateQaPreRole(strCurrentRole);

        if(strCurrentRole.contains('QA')){
            if (!lstQaCareerPathSettings.isEmpty()) {
                wrpRoles objWrpRole;
                List<wrpRoles> lstCareerTmp;
                for (Salesforce_Career_Path_Settings__mdt objCareerPath : lstQaCareerPathSettings) {
                    String strColumn = objCareerPath.Position__c.format().substring(0,1);
                    String strRoleSalesforce = objCareerPath.MasterLabel;
                    objWrpRole = new wrpRoles();
                        objWrpRole.strRole = objCareerPath.MasterLabel;
                        if(strRoleSalesforce == strCurrentRole){
                            objWrpRole.blnCurrentRole = true;
                        }else{
                            objWrpRole.blnIsPreRole = qaPreRoles.contains(strRoleSalesforce);
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
        } else if (!lstCareerPathSettings.isEmpty()) {
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
                        objWrpRole.blnIsPreRole = devPreRoles.contains(strRoleSalesforce);
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

    @AuraEnabled(cacheable=true)
    public static List<wrpColumns> getPath(String empId){
        return getPath(empId, null);
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

    private static Set<String> calculateDevPreRole (String currentRole){
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
            preRoles.add('Salesforce Technical Architect');
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
            preRoles.add('Salesforce Technical Architect');
            preRoles.add('Salesforce Certified Architect');  
        }
        return preRoles;
    }

    private static Set<String> calculateQaPreRole (String currentRole){
        Set<String> qaPreRoles = new Set<String>();
        if(currentRole.equals('QA Analyst')){
            qaPreRoles.add('QA Junior');
        } else if(currentRole.equals('QA Senior')){
            qaPreRoles.add('QA Junior');
            qaPreRoles.add('QA Analyst');
        } else if(currentRole.equals('QA Lead') || currentRole.equals('QA Automation Specialist') || currentRole.equals('QA Mobile Specialist') ||
                    currentRole.equals('QA Security Specialist') || currentRole.equals('QA Usability Specialist') || currentRole.equals('QA Technology Specialist') || 
                    currentRole.equals('QA Coach')){
                qaPreRoles.add('QA Junior');
                qaPreRoles.add('QA Analyst');
                qaPreRoles.add('QA Senior');
        }else if(currentRole.equals('QA Automation Specialist Lead')){
                qaPreRoles.add('QA Automation Specialist');
                qaPreRoles.add('QA Junior');
                qaPreRoles.add('QA Analyst');
                qaPreRoles.add('QA Senior');
        } else if(currentRole.equals('QA Mobile Specialist Lead')){
            qaPreRoles.add('QA Mobile Specialist');
            qaPreRoles.add('QA Junior');
            qaPreRoles.add('QA Analyst');
            qaPreRoles.add('QA Senior');
        } else if(currentRole.equals('QA Security Specialist Lead')){
            qaPreRoles.add('QA Security Specialist');
            qaPreRoles.add('QA Junior');
            qaPreRoles.add('QA Analyst');
            qaPreRoles.add('QA Senior');
        } else if(currentRole.equals('QA Usability Specialist Lead')){
                qaPreRoles.add('QA Usability Specialist');
                qaPreRoles.add('QA Junior');
                qaPreRoles.add('QA Analyst');
                qaPreRoles.add('QA Senior');
        } else if(currentRole.equals('QA Manager')){
            qaPreRoles.add('QA Usability Specialist Lead');
            qaPreRoles.add('QA Security Specialist Lead');
            qaPreRoles.add('QA Mobile Specialist Lead');
            qaPreRoles.add('QA Automation Specialist Lead');
            qaPreRoles.add('QA Usability Specialist');
            qaPreRoles.add('QA Security Specialist');
            qaPreRoles.add('QA Mobile Specialist');
            qaPreRoles.add('QA Automation Specialist');
            qaPreRoles.add('QA Technology Specialist');
            qaPreRoles.add('QA Lead');
            qaPreRoles.add('QA Coach');
            qaPreRoles.add('QA Junior');
            qaPreRoles.add('QA Analyst');
            qaPreRoles.add('QA Senior');
        }
        return qaPreRoles;
    }

    @AuraEnabled(cacheable=true)
    public static List<wrpColumns> getPathByMainRole(String mainRole){
        List<wrpColumns> lstToReturn = getPath(null, mainRole);
        if (!lstToReturn.isEmpty()) lstToReturn.get(0).lstWrpRoles[0].blnCurrentRole = true;
        return lstToReturn;
    }
}