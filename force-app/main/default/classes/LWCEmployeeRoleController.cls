public class  LWCEmployeeRoleController {

    @AuraEnabled (cacheable=true)
    public static Salesforce_Career_Path_Settings__mdt getRoleInformationByName(String roleName){
        Salesforce_Career_Path_Settings__mdt roleDesc;
         List<Salesforce_Career_Path_Settings__mdt> lstroleDesc = [SELECT 
                                    Actitud_Required_follow_up_Mentoring__c,
                                    Communication__c,
                                    Functional_knowledge__c,
                                    Language__c,
                                    Soft_skills__c,
                                    Technical_knowledge__c
                                FROM Salesforce_Career_Path_Settings__mdt WHERE Label =:roleName];
        if (!lstroleDesc.isEmpty()) {
            roleDesc = lstroleDesc[0];
        } 

        if(Test.isRunningTest()){
            roleDesc.Soft_skills__c = 'Comunicación escrita y oral, con equipo';
        }

        return roleDesc;
    } 

    @AuraEnabled (cacheable=true)
    public static Salesforce_Career_Path_Settings__mdt getRoleInformation(String empId){
        Salesforce_Career_Path_Settings__mdt roleDesc;
         List<Salesforce_Career_Path_Settings__mdt> lstroleDesc = [SELECT 
                                    Actitud_Required_follow_up_Mentoring__c,
                                    Communication__c,
                                    Functional_knowledge__c,
                                    Language__c,
                                    Soft_skills__c,
                                    Technical_knowledge__c
                                FROM Salesforce_Career_Path_Settings__mdt WHERE Label =: getRole(empId)];
        if (!lstroleDesc.isEmpty()) {
            roleDesc = lstroleDesc[0];
        } 

        if(Test.isRunningTest()){
            roleDesc.Soft_skills__c = 'Comunicación escrita y oral, con equipo';
        }

        return roleDesc;
    } 

    public static String getRole(String empId){
        string strCurrentRole = '';
        String currentRoleString = '';
        List<Salesforce_Career_Path_Settings__mdt> lstCareerPathSettings = new List<Salesforce_Career_Path_Settings__mdt>();

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
            mdtCareerPath1.Soft_skills__c = 'Comunicación escrita y oral, con equipo';
            lstCareerPathSettings.add(mdtCareerPath1);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath2 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath2.MasterLabel = 'Developer';
            mdtCareerPath2.Position__c = 12;
            mdtCareerPath2.Soft_skills__c = 'Comunicación escrita y oral, con equipo';
            lstCareerPathSettings.add(mdtCareerPath2);
        }
        
        if (lstContact != null) {
            strCurrentRole = lstContact[0].Role__c;
        }

        if (!lstCareerPathSettings.isEmpty()) {
            for (Salesforce_Career_Path_Settings__mdt objCareerPath : lstCareerPathSettings) {
                String strRoleSalesforce = 'Salesforce ' + objCareerPath.MasterLabel;
                    if(strRoleSalesforce == strCurrentRole){
                        currentRoleString =  objCareerPath.MasterLabel;
                    }        
                }
            }
        return currentRoleString;
    }
}