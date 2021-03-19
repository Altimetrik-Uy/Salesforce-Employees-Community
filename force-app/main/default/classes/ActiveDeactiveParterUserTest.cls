@isTest(seeAllData=False)
private class ActiveDeactiveParterUserTest {
    @isTest(SeeAllData=False) static void testAllowUser() {
        Id p = [select id from profile where name='Community Employee Profile'].id;
        //Account
        Account ac = new Account(name ='Test') ;
        insert ac; 
        
        //Contact and user 1
        Contact con1 = new Contact(LastName ='testCon1',AccountId = ac.Id);
        insert con1;  
        User user1 = new User(alias = 'test1', email='test1@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                              ContactId = con1.Id,
                              timezonesidkey='America/Los_Angeles', username='tester1@altinoemail.com');    
        insert user1;
        
        //Contact and user 2
        Contact con2 = new Contact(LastName ='testCon2',AccountId = ac.Id);
        insert con2;  
        User user2 = new User(alias = 'test2', email='test2@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p, country='United States',IsActive =false,
                              ContactId = con2.Id,
                              timezonesidkey='America/Los_Angeles', username='tester2@altinoemail.com');      
        insert user2;
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.RunAs(usr){
            
            Test.startTest();
            system.assert(user1.IsActive);
            system.assert(!user2.IsActive);
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            
            req.requestURI = 'callout:communityCredentials/services/apexrest/v1/allowUser';
            req.httpMethod = 'PATCH';
            req.addParameter('username', 'tester2@altinoemail.com');
            RestContext.request = req;
            ActiveDeactivePartnerUser.allowUser();
            
            user1 = [SELECT IsActive FROM User WHERE Username = 'tester1@altinoemail.com' LIMIT 1];
            user2 = [SELECT IsActive FROM User WHERE Username = 'tester2@altinoemail.com' LIMIT 1];
            system.assert(!user1.IsActive);
            system.assert(user2.IsActive);
            Test.stopTest();
        }
    }
}