@isTest
public class LWCEvaluatedKpiControllerTest {
    @isTest
    public static void testGetEvaluatedKpi(){
        //System Admin
        User admin = TestDataFactory.createAdminUser();
        List<Evaluated_Kpi__c> evaluatedKpiList = new List<Evaluated_Kpi__c>();

        System.runAs(admin){
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User usr = TestDataFactory.createUser(con.Id);
            //Opportunity
            Opportunity project = TestDataFactory.createOpportunity('Test', acc.Id);
            //Review
            Review__c review = TestDataFactory.createReview(con.Id, project.Id, 'Open');
            //Kpis
            Kpi__c kpi1 = TestDataFactory.createKpis('Apex');
            Kpi__c kpi2 = TestDataFactory.createKpis('LWC');
            //Evaluated Kpi
            Evaluated_Kpi__c ek1 = TestDataFactory.createEvaluatedKpi(review.Id, kpi1.Id, 4);
            Evaluated_Kpi__c ek2 = TestDataFactory.createEvaluatedKpi(review.Id, kpi2.Id, 3);
            
            Test.startTest();
                evaluatedKpiList = LWCEvaluatedKpiController.getEvaluatedKpi(review.Id);
            Test.stopTest();
            
            System.assertEquals(2, evaluatedKpiList.size(), 'Size of EvaluatedKpi do not match');

        }
    }

    @isTest
    public static void testSetEvaluatedKpi(){
        //System Admin
        User admin = TestDataFactory.createAdminUser();
        System.runAs(admin) {
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User newUser = TestDataFactory.createUser(con.Id);
            //Opportunity
            Opportunity project = TestDataFactory.createOpportunity('Test', acc.Id);
            //Review
            Review__c review = TestDataFactory.createReview(con.Id, project.Id, 'Open');
            //Kpis
            Kpi__c kpi1 = TestDataFactory.createKpis('Apex');
            Kpi__c kpi2 = TestDataFactory.createKpis('LWC');
            //Evaluated Kpi
            Evaluated_Kpi__c ek1 = TestDataFactory.createEvaluatedKpi(review.Id, kpi1.Id, 2);
            Evaluated_Kpi__c ek2 = TestDataFactory.createEvaluatedKpi(review.Id, kpi2.Id, 1);

            String jsonKpis = '[[{"kpiId": "'+ek1.Id+'","point":"3"}],[{"kpiId": "'+ek2.Id+'","point":"4"}]]';
            
            Test.startTest();
                LWCEvaluatedKpiController.setEvaluatedKpi(jsonKpis);
            Test.stopTest();

            Evaluated_Kpi__c pointUpdate = [ SELECT Point__c FROM Evaluated_Kpi__c WHERE Id = :ek1.Id ];
            System.assertEquals(3, pointUpdate.Point__c);
        }
    }
}
