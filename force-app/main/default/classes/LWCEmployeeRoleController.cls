public class  LWCEmployeeRoleController {

    @AuraEnabled (cacheable=true)
    public static Salesforce_Career_Path_Settings__mdt getRoleInformation(String empId){
        Salesforce_Career_Path_Settings__mdt roleDesc;
        List<Salesforce_Career_Path_Settings__mdt> lstroleDesc = [SELECT 
                                    Role_Description__c,
                                    Role_Functionalknowledge__c,
                                    Role_Technicalknowledge__c,
                                    Role_MentoringRequiered__c,
                                    Role_Communication__c,
                                    Role_Prerequisites__c,
                                    Role_Softskills__c  
                                FROM Salesforce_Career_Path_Settings__mdt WHERE Label =: getRole(empId)];
        if (!lstroleDesc.isEmpty()) {
            roleDesc = lstroleDesc[0];
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
            mdtCareerPath1.Role_Softskills__c = 'Comunicación escrita y oral, con equipo';
            lstCareerPathSettings.add(mdtCareerPath1);

            Salesforce_Career_Path_Settings__mdt mdtCareerPath2 = new Salesforce_Career_Path_Settings__mdt();
            mdtCareerPath2.MasterLabel = 'Developer';
            mdtCareerPath2.Position__c = 12;
            mdtCareerPath2.Role_Softskills__c = 'Comunicación escrita y oral, con equipo';
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
