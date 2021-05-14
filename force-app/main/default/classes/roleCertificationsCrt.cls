public without sharing class roleCertificationsCrt {
    
    @AuraEnabled(cacheable=true)
    public static List<rolesCertificacionesWrapper> calculosPorcentaje(String userId) {
        System.debug('roleCertificationsCrt.userId '+userId);

        List<rolesCertificacionesWrapper> certificacionesWrapperList = new List<rolesCertificacionesWrapper>();
        List<User> userList = [
            SELECT Id,
            Contact.Id 
            FROM User 
            WHERE Id = :userId 
            LIMIT 1];
        System.debug('roleCertificationsCrt.userList '+userList);


        if(!userList.isEmpty() || (Test.isRunningTest() && userId.contains('*'))){
            String contactId;
            if(!Test.isRunningTest()){
                contactId= userList[0].Contact.Id;
            }
            else{
                contactId= userId.remove('*');
            }
            System.debug('roleCertificationsCrt.contactId '+contactId);

            Map<String,List<Salesforce_Career_Path__c>> roleCertificationsMap = new Map<String,List<Salesforce_Career_Path__c>>();
            List<AggregateResult> totalCertificationsList;
            List<Contact> contactList = [
                SELECT Id,
                Email, 
                Role__c
                FROM Contact
                WHERE Id =: contactId
                LIMIT 1];
            System.debug('roleCertificationsCrt.contactList '+contactList);

            if(!contactList.isEmpty() && !String.isBlank(contactList[0].Email) && !String.isBlank(contactList[0].Role__c)){

                String currentRole = contactList[0].Role__c;
                List<String> nextRolesList = new List<String>();
                List<String> totalRolesList = new List<String>();
                List<Salesforce_Career_Path__c> totalCarreerPathList = new List<Salesforce_Career_Path__c>();
                totalRolesList.add(currentRole);
                Set<Id> certificationIdSet = new Set<Id>();

                List<ta_User_Certification__c> userCertificacionList = [
                    SELECT Id,
                    Certification__c
                    FROM ta_User_Certification__c
                    WHERE User_Info__r.Email__c =: contactList[0].Email];
                System.debug('roleCertificationsCrt.userCertificacionList '+userCertificacionList);

                for(ta_User_Certification__c userCert : userCertificacionList){
                    certificationIdSet.add(userCert.Certification__c);
                }
                System.debug('roleCertificationsCrt.certificationIdSet '+certificationIdSet);

                List<Salesforce_Career_Path__c> carreerPathList = [
                    SELECT Id,
                    Role__c,
                    Possible_Next_Role__c
                    FROM Salesforce_Career_Path__c
                    WHERE Role__c =: currentRole];
                System.debug('roleCertificationsCrt.carreerPathList '+carreerPathList);

                if(!String.isBlank(carreerPathList[0].Possible_Next_Role__c)){
                    nextRolesList = carreerPathList[0].Possible_Next_Role__c.split(';');
                    totalRolesList.addAll(nextRolesList);
                }
                System.debug('roleCertificationsCrt.totalRolesList '+totalRolesList);

                if(!certificationIdSet.isEmpty()){
                    totalCarreerPathList = [
                        SELECT Id,
                        Role__c,
                        Possible_Next_Role__c
                        FROM Salesforce_Career_Path__c
                        WHERE Role__c =: totalRolesList
                            AND Certification__c=: certificationIdSet
                        ORDER BY Role__c];
                    System.debug('roleCertificationsCrt.totalCarreerPathList '+totalCarreerPathList);

            
                    for(Salesforce_Career_Path__c path : totalCarreerPathList){
                        if(roleCertificationsMap.containsKey(path.Role__c)){
                            roleCertificationsMap.get(path.Role__c).add(path);
                        }
                        else{
                            List<Salesforce_Career_Path__c> pathList = new List<Salesforce_Career_Path__c>();
                            pathList.add(path);
                            roleCertificationsMap.put(path.Role__c,pathList);
                        }
                    }
                    System.debug('roleCertificationsCrt.roleCertificationsMap '+roleCertificationsMap);
                    
                    if(!roleCertificationsMap.isEmpty()){
                
                        totalCertificationsList = [
                            SELECT Role__c, count(Id)total
                                FROM Salesforce_Career_Path__c
                                WHERE Role__c =: totalRolesList
                                GROUP BY Role__c
                                ORDER BY Role__c];
                        System.debug('roleCertificationsCrt.totalCertificationsList '+totalCertificationsList);
                        List<rolesCertificacionesWrapper> wrapperList = new List<rolesCertificacionesWrapper>();
                        for(AggregateResult ar : totalCertificationsList){
                            rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
                            Decimal denominator = (Decimal) ar.get('total');
                            Decimal porcentaje;
                            if(roleCertificationsMap.containsKey((String) ar.get('Role__c'))){
                                porcentaje = (roleCertificationsMap.get((String) ar.get('Role__c')).size() *100) / denominator;
                            }
                            else{
                                porcentaje = 0;
                            }
                            System.debug('roleCertificationsCrt.porcentaje '+porcentaje);

                            certificacionWrapper.role = (String) ar.get('Role__c');
                            certificacionWrapper.porcentaje = porcentaje;
                            if((String) ar.get('Role__c') == currentRole){
                                certificacionWrapper.isCurrent = true;
                                certificacionesWrapperList.add(certificacionWrapper); 
                            }
                            else{
                                certificacionWrapper.isCurrent = false;
                                wrapperList.add(certificacionWrapper); 
                            }                                               
                        }
                        certificacionesWrapperList.addAll(wrapperList);
                    }
                    else{
                        rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
                        certificacionWrapper.role = 'No hay registros para el rol presente';
                        certificacionWrapper.porcentaje = 0;
                        certificacionesWrapperList.add(certificacionWrapper);
                    }
                }
                else {
                    for(String role : totalRolesList){
                        rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
                        certificacionWrapper.role = role;
                        certificacionWrapper.porcentaje = 0;
                        certificacionesWrapperList.add(certificacionWrapper);
                    }
                }
            }
            else {
                rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
                certificacionWrapper.role = 'Faltan datos';
                certificacionWrapper.porcentaje = contactList.size();
                certificacionesWrapperList.add(certificacionWrapper);
            }
        }
        else{
            rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
            certificacionWrapper.role = 'No existe usuario';
            certificacionWrapper.porcentaje = userList.size();
            certificacionesWrapperList.add(certificacionWrapper);
        }
        System.debug('roleCertificationsCrt.certificacionesWrapperList '+certificacionesWrapperList);
        
        return certificacionesWrapperList;
    }

    public class rolesCertificacionesWrapper{
        @AuraEnabled
        public String role {get;set;}
        @AuraEnabled
        public Decimal porcentaje {get;set;}
        @AuraEnabled
        public boolean isCurrent {get;set;}
    }
}