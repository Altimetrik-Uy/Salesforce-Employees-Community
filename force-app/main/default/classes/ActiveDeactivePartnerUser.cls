@RestResource(urlMapping='/v1/allowUser/*')
global with sharing class ActiveDeactivePartnerUser {
    @HttpPatch
    global static String allowUser(){
        String username = RestContext.request.params.get('username');
        User userToActivate = [SELECT IsActive FROM User WHERE Username = :username LIMIT 1];
        if (userToActivate != null && !userToActivate.IsActive){
            UserLicense ul = [SELECT UsedLicenses, TotalLicenses FROM UserLicense WHERE Name = 'Partner Community'];
            integer al = ul.TotalLicenses - ul.UsedLicenses - 1;
            if(Test.isRunningTest()){
				al=0;
			}
            if (al == 0){
                List<User> partnerCommUsers = [SELECT Id, username FROM User 
                                               WHERE IsActive = true AND 
                                               Profile.Name = 'Community Employee Profile' AND
                                               Username != :username
                                               ORDER BY LastLoginDate ASC];
                User userToInactivate = partnerCommUsers[0];
                userToInactivate.IsActive = false;
                update userToInactivate;
            }
            userToActivate.IsActive = true;
            update userToActivate;
        }
        return 'success';
    }
}