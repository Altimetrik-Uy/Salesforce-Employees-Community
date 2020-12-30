public without sharing class RoleCertificationsController{
	@AuraEnabled(cacheable = true)
	public static List<rolesCertificacionesWrapper> getPercentages(String userId){
        List<rolesCertificacionesWrapper> certificacionesWrapperList = new List<rolesCertificacionesWrapper>();
        rolesCertificacionesWrapper trailblazerWrapper = new rolesCertificacionesWrapper();
		List<User> userList = [SELECT Id, Contact.Id
		                       FROM User
		                       WHERE Id = :userId
		                       LIMIT 1];
		if (!userList.isEmpty() || (Test.isRunningTest() && userId.contains('*'))){
			String contactId;
			if (!Test.isRunningTest()){
				contactId = userList[0].Contact.Id;
			} else{
				contactId = userId.remove('*');
			}
			Map<String, List<Salesforce_Career_Path__c>> roleCertificationsMap = new Map<String, List<Salesforce_Career_Path__c>>();
			List<AggregateResult> totalCertificationsList;
			List<Contact> contactList = [SELECT Id, Email, Role__c
			                             FROM Contact
			                             WHERE Id = :contactId
			                             LIMIT 1];
			String currentRole = contactList[0].Role__c;
			if (!contactList.isEmpty() && !String.isBlank(contactList[0].Email) && !String.isBlank(contactList[0].Role__c)){
				
				List<String> nextRolesList = new List<String>();
				List<String> totalRolesList = new List<String>();
				List<Salesforce_Career_Path__c> totalCarreerPathList = new List<Salesforce_Career_Path__c>();
				totalRolesList.add(currentRole);
				Set<Id> certificationIdSet = new Set<Id>();

				List<ta_User_Info__c> userInfoTrailId = [SELECT Id, TrailBlazerId__c
				                                        FROM ta_User_Info__c
														WHERE Email__c = :contactList[0].Email];

				List<ta_User_Certification__c> userCertificacionList = [SELECT Id, Certification__c, User_Info__r.TrailBlazerId__c
				                                                        FROM ta_User_Certification__c
																		WHERE User_Info__r.Email__c = :contactList[0].Email];
				String userInfoTBId = '';
				if(!userCertificacionList.isEmpty()){
					if(userCertificacionList[0].User_Info__r.TrailBlazerId__c != null){
						userInfoTBId = userCertificacionList[0].User_Info__r.TrailBlazerId__c;
					}
				} else if(userInfoTrailId[0].TrailBlazerId__c != null){
					userInfoTBId = userInfoTrailId[0].TrailBlazerId__c;
				}
				
				if (!String.IsBlank(userInfoTBId)){
					trailblazerWrapper.trailblazerId = true;
					
				} else{
					trailblazerWrapper.trailblazerId = false;
					certificacionesWrapperList.add(trailblazerWrapper);
					return certificacionesWrapperList;
				}
				
				for (ta_User_Certification__c userCert : userCertificacionList){
					certificationIdSet.add(userCert.Certification__c);
				}

				List<Salesforce_Career_Path__c> carreerPathList = [SELECT Id, Role__c, Possible_Next_Role__c
				                                                   FROM Salesforce_Career_Path__c
				                                                   WHERE Role__c = :currentRole
																   LIMIT 1];
																   
				if (!carreerPathList.isEmpty()){
					if (!String.isBlank(carreerPathList[0].Possible_Next_Role__c)){
						nextRolesList = carreerPathList[0].Possible_Next_Role__c.split(';');
						totalRolesList.addAll(nextRolesList);
					}
					if (!certificationIdSet.isEmpty()){
						totalCarreerPathList = [SELECT Id, Role__c, Possible_Next_Role__c
						                        FROM Salesforce_Career_Path__c
						                        WHERE Role__c = :totalRolesList AND Certification__c = :certificationIdSet AND Required__c = true
						                        ORDER BY Role__c];

						for (Salesforce_Career_Path__c path : totalCarreerPathList){
							if (roleCertificationsMap.containsKey(path.Role__c)){
								roleCertificationsMap.get(path.Role__c).add(path);
							} else{
								List<Salesforce_Career_Path__c> pathList = new List<Salesforce_Career_Path__c>();
								pathList.add(path);
								roleCertificationsMap.put(path.Role__c, pathList);
							}
						}

						if (!roleCertificationsMap.isEmpty()){
							totalCertificationsList = [SELECT Role__c, count(Id)total
							                           FROM Salesforce_Career_Path__c
							                           WHERE Role__c = :totalRolesList AND Required__c = true
							                           GROUP BY Role__c
													   ORDER BY Role__c];
							List<rolesCertificacionesWrapper> wrapperList = new List<rolesCertificacionesWrapper>();
							for (AggregateResult ar : totalCertificationsList){
								rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
								Decimal denominator = (Decimal)ar.get('total');
								Decimal porcentaje;
								if (roleCertificationsMap.containsKey((String)ar.get('Role__c'))){
									porcentaje = (roleCertificationsMap.get((String)ar.get('Role__c')).size() * 100) / denominator;
								} else{
									porcentaje = 0;
								}

								certificacionWrapper.role = (String)ar.get('Role__c');
                                certificacionWrapper.porcentaje = porcentaje;
                                certificacionWrapper.hasRequired = true;
								if ((String)ar.get('Role__c') == currentRole){
									certificacionWrapper.isCurrent = true;
									certificacionesWrapperList.add(certificacionWrapper);
								} else{
									certificacionWrapper.isCurrent = false;
									wrapperList.add(certificacionWrapper);
								}
							}
							certificacionesWrapperList.addAll(wrapperList);
							
						} else{
								for (String role : totalRolesList){
									rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
									List<Salesforce_Career_Path__c> noRequiredList = [SELECT Id, Name, Role__c, Required__c
									FROM Salesforce_Career_Path__c
									WHERE Role__c =: role AND Required__c = true];
						
									if(noRequiredList.isEmpty()){
										certificacionWrapper.hasRequired = false;
									}else{
										certificacionWrapper.hasRequired = true;
									}
									if (currentRole == role) {
										certificacionWrapper.isCurrent = true;
									}else{
										certificacionWrapper.isCurrent = false;
									}
									certificacionWrapper.role = role;
									certificacionWrapper.porcentaje = 0;
									certificacionesWrapperList.add(certificacionWrapper);
								}
							}
					} else{
						for (String role : totalRolesList){
							rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
							List<Salesforce_Career_Path__c> noRequiredList = [SELECT Id, Name, Role__c, Required__c
																			  FROM Salesforce_Career_Path__c
																			  WHERE Role__c =: role AND Required__c = true];
									if(noRequiredList.isEmpty()){
										certificacionWrapper.hasRequired = false;
									}else{
										certificacionWrapper.hasRequired = true;
									}
									if (currentRole == role) {
										certificacionWrapper.isCurrent = true;
									}else{
										certificacionWrapper.isCurrent = false;
									}
							certificacionWrapper.role = role;
							certificacionWrapper.porcentaje = 0;
							certificacionesWrapperList.add(certificacionWrapper);
						}
					}
				} else{
                    rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
					certificacionWrapper.hasRequired = true;
					certificacionWrapper.role = 'There are no Salesforce Career Path Records.';
					certificacionWrapper.porcentaje = carreerPathList.size();
                    certificacionesWrapperList.add(certificacionWrapper);
                    
                }
			} else{
                rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
				certificacionWrapper.hasRequired = true;				
				certificacionWrapper.role = 'Verify that the Email or Role fields have valid information.';
				certificacionWrapper.porcentaje = contactList.size();
                certificacionesWrapperList.add(certificacionWrapper); 
            }
            //if user does not have current role
            if(certificacionesWrapperList[0].isCurrent!=null){ 
				if(!certificacionesWrapperList[0].isCurrent){
					certificacionesWrapperList = addCurrentRole(currentRole, certificacionesWrapperList);
				}
            }
		} else{
            rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
            certificacionWrapper.hasRequired = true;
			certificacionWrapper.role = 'No user record is associated with this contact.';
			certificacionWrapper.porcentaje = userList.size();
            certificacionesWrapperList.add(certificacionWrapper);
           
		}
		return certificacionesWrapperList;
    }

    public static List<rolesCertificacionesWrapper> addCurrentRole(String currentRole, List<rolesCertificacionesWrapper> certificacionesWrapperList){
            rolesCertificacionesWrapper certificacionWrapper = new rolesCertificacionesWrapper();
            List<Salesforce_Career_Path__c> noRequiredList = [SELECT Id, Name, Role__c, Required__c
            FROM Salesforce_Career_Path__c
            WHERE Role__c =: currentRole AND Required__c = True];
            if(noRequiredList.isEmpty()){
                certificacionWrapper.hasRequired = false;
            }else{
                certificacionWrapper.hasRequired = true;
            }
            certificacionWrapper.isCurrent = true;
            certificacionWrapper.role = currentRole;
            certificacionWrapper.porcentaje = 0;
            List<rolesCertificacionesWrapper> certificacionesWrapperListAux = new List<rolesCertificacionesWrapper>();
            for (rolesCertificacionesWrapper nextRoleAux : certificacionesWrapperList) {
                certificacionesWrapperListAux.add(nextRoleAux);
            }
            certificacionesWrapperList.clear();
            //Add current Role
            certificacionesWrapperList.add(certificacionWrapper);
            //Add all de next roles
            for (rolesCertificacionesWrapper nextRole : certificacionesWrapperListAux) {
             certificacionesWrapperList.add(nextRole);
            }
        return certificacionesWrapperList;
    }

	public class rolesCertificacionesWrapper{
		@AuraEnabled
		public String role{ get; set; }

		@AuraEnabled
		public Decimal porcentaje{ get; set; }

		@AuraEnabled
		public boolean isCurrent{ get; set; }

		@AuraEnabled
        public boolean trailblazerId{ get; set; }
        
        @AuraEnabled
        public boolean hasRequired{ get; set; }
	}
}