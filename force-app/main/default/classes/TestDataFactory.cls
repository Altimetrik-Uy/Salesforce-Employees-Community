public class TestDataFactory {

    public static User createAdminUser(){
        Profile pAdmin = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        UserRole uRoleAdmin = [SELECT Id, Name FROM UserRole WHERE Name = 'CEO' LIMIT 1];
        User admin = new User();
        admin.firstname = 'Admin1';
        admin.lastname = 'Admin1';
        admin.Alias = 'aAdmin1';
        admin.email = 'aAdmin1@admin.com';
        admin.username = 'aAdmin1@admin.com';
        admin.UserRoleId = uRoleAdmin.Id;
        admin.profileId = pAdmin.id;
        admin.emailencodingkey ='UTF-8';
        admin.languagelocalekey ='en_US';
        admin.localesidkey ='en_US';
        admin.timezonesidkey ='America/Los_Angeles';
        insert admin;
        return admin;
    }
    
    public static User createAdminManagerUser(){
        Profile pAdmin = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User admin = new User();
        admin.firstname = 'Manager';
        admin.lastname = 'Manager';
        admin.Alias = 'Manager';
        admin.email = 'manager@admin.com';
        admin.username = 'project_manager@admin.com';
        admin.profileId = pAdmin.id;
        admin.emailencodingkey ='UTF-8';
        admin.languagelocalekey ='en_US';
        admin.localesidkey ='en_US';
        admin.timezonesidkey ='America/Los_Angeles';
        insert admin;
        return admin;
    }

    public static Contact createContact(Id accountId){
        Contact con = new Contact();
        con.FirstName='Test';
        con.LastName='Test';
        con.Email = 'Test@test.com';
        con.AccountId = accountId;
        insert con;
        return con;
    }

    public static Account createAccount(){
       Account acc = new Account();
       acc.Name = 'accountForTest';
       insert acc;
       return acc;
    }

    public static User createUser(Id contactId){
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User usr = new User();
        Profile pUser = [SELECT Id FROM Profile WHERE Name = 'Community Employee Profile' LIMIT 1];
        usr.firstname = 'Sebastian';
        usr.lastname = 'Trelles';
        usr.Alias = uniqueName.substring(18, 23);
        usr.email = uniqueName+'@test.com';
        usr.username = uniqueName+'@test.com';
        usr.profileId = pUser.id;
        usr.emailencodingkey ='UTF-8';
        usr.languagelocalekey ='en_US';
        usr.localesidkey ='en_US';
        usr.timezonesidkey ='America/Los_Angeles';
        usr.ContactId = contactId;
        insert usr;
        return usr;
    }

    public static ta_User_Info__c createUserInfo(string trailBlazerId){
        ta_User_Info__c userInfo = new ta_User_Info__c();
        userInfo.Name='Test';
        userInfo.Email__c = 'Test@test.com';
        userInfo.Role__c = 'Developer';
        userInfo.TrailBlazerId__c = trailBlazerId;
        insert userInfo;
        return userInfo;
    }

    public static Opportunity createOpportunity(String name, Id accountId){
        Opportunity opp = new Opportunity();
        opp.Name = name;
        opp.CloseDate = system.today();
        opp.StageName = 'Accepted';
        opp.AccountId = accountId;
        insert opp;
        return opp;
    }

    public static Employee_Assignment__c createEmployeeAssigment(Id contactId, Id opportunityId, Date startDate, Date endDate, String baseCat){
        Employee_Assignment__c eAssignment = new Employee_Assignment__c();
        eAssignment.Employee__c = contactId;
        eAssignment.Project__c = opportunityId;
        eAssignment.Start_Date__c = startDate;
        eAssignment.Base_Category__c = baseCat;
        eAssignment.End_Date__c = endDate;
        insert eAssignment;
        return eAssignment;
    }

    public static Project_Status__c createProjectStatus(Id opportunityId, String status){
        Project_Status__c pStatus = new Project_Status__c();
        pStatus.Project__c = opportunityId;
        pStatus.Comments__c = 'Test';
        pStatus.Meeting_Date__c = system.today();
        pStatus.Status__c = status;
        insert pStatus;
        return pStatus;
    }

    public static Id createDataForTestProjectStatusImageName(String name, Id accountId, Id conntactId, String status, Date startDate, Date endDate, String baseCat){
    	//Opportunity
        Opportunity opp = createOpportunity(name, accountId);
        //Employee Assignment
        Employee_Assignment__c eAssignment = createEmployeeAssigment(conntactId, opp.Id, startDate, endDate, baseCat);
        //If status is null do not create Project Status
        if(status != ''){
            //Project Status
            Project_Status__c pStatus = createProjectStatus(opp.Id, status); 
        }
       	return opp.Id;
    }

    public static Employee_Assignment__c createDataForBenchReport(String name, Id accountId, Id conntactId, Date startDate, Date endDate, String baseCat){
        //Opportunity
        Opportunity opp = createOpportunity(name, accountId);
        //Employee Assignment
        Employee_Assignment__c eAssignment = createEmployeeAssigment(conntactId, opp.Id, startDate, endDate, baseCat);
        //If status is null do not create Project Status
        return eAssignment;
    }

    public static Id createDataForTestProjectsTab(String name, Id accountId, Id conntactId, Date startDate, Date endDate, String baseCat){
    	//Opportunity
        Opportunity opp = createOpportunity(name, accountId);
        //Employee Assignment
        Employee_Assignment__c eAssignment = createEmployeeAssigment(conntactId, opp.Id, startDate, endDate, baseCat);
        return eAssignment.Id;
    }

    public static Employee_Status__c createEmployeeStatus(Id contactId, String status, String certificationStatus){
        Employee_Status__c eStatus = new Employee_Status__c();
        eStatus.Employee__c = contactId;
        eStatus.Status__c = status;
        eStatus.Certification_Status__c = certificationStatus;
        insert eStatus;
        return eStatus;
    }

    public static Managers_Assignment__c createManagersAssigment(Id managerId, Id opportunityId){
        Managers_Assignment__c mAssignment = new Managers_Assignment__c();
        mAssignment.Project__c = opportunityId;
        mAssignment.User__c = managerId;
        insert mAssignment;
        return mAssignment;
    }

    public static Review__c createReview(Id contactId, Id opportunityId, String status){
        Review__c review = new Review__c();
        review.Evaluated__c = contactId;
        review.Project__c = opportunityId;
        review.Status__c = status;
        insert review;
        return review;
    }

    public static Review_Assignment__c createReviewAssignment(Id reviewId, Id evaluatorId){
        Review_Assignment__c reviewAssignment = new Review_Assignment__c();
        reviewAssignment.Evaluator__c = evaluatorId;
        reviewAssignment.Review__c = reviewId;
        reviewAssignment.Name = 'Review Assignment Test';
        insert reviewAssignment;
        return reviewAssignment;
    }

    public static Plan_Item__c createPlanItem(Id reviewId, String status, Date endDate){
        Plan_Item__c planItem = new Plan_Item__c();
        planItem.Review__c = reviewId;
        planItem.State__c = status;
        planItem.Name = 'Test Plan Item';
        planItem.Plan__c = 'Test Plan Description';
        planItem.End_Date__c = endDate;
        insert planItem;
        return planItem;
    }

    public static Kpi__c createKpis(String name){
        Kpi__c kpi = new Kpi__c();
        kpi.Role__c = 'Developer';
        kpi.Name = name;
        insert kpi;
        return kpi;
    }
    public static Evaluated_Kpi__c createEvaluatedKpi(Id reviewId, Id kpiId, Integer Point){
        Evaluated_Kpi__c evaluatedKpi = new Evaluated_Kpi__c();
        evaluatedKpi.Review__c = reviewId;
        evaluatedKpi.Kpi__c = kpiId;
        evaluatedKpi.Name = 'Test Evaluated Kpi';
        evaluatedKpi.Point__c = 4;
        insert evaluatedKpi;
        return evaluatedKpi;
    }


}