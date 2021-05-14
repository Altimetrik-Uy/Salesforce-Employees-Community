@isTest
private class LWCBenchReportControllerTest {

    @isTest
    public static void getDataBenchReport(){
    	//System Admin
    	User admin = TestDataFactory.createAdminUser();
        System.runAs(admin){
            //Account
            Account acc = TestDataFactory.createAccount();
            //Contact
            Contact con = TestDataFactory.createContact(acc.Id);
            //User
            User usr = TestDataFactory.createUser(con.Id);

            TestDataFactory.createDataForBenchReport('O1',acc.Id, con.Id, date.parse('5/12/2020'), date.parse('3/15/2199'), 'NON-BILLED');
            TestDataFactory.createDataForBenchReport('O2',acc.Id, con.Id, date.parse('11/20/2021'), date.parse('1/20/2199'), 'WFB');
            TestDataFactory.createDataForBenchReport('O3',acc.Id, con.Id, date.parse('11/12/2020'), date.parse('2/17/2199'), 'INVESTMENT');
        
            Test.startTest();
                Object benchReport = LWCBenchReportController.getData();
                LWCBenchReportController.wrpBenchReport report = (LWCBenchReportController.wrpBenchReport) benchReport;
            
                String proj = report.calendar.get(3).Project;
                String empId = report.calendar.get(3).Days.get(0).employees.get(0).Id;
                Boolean dataf = report.calendar.get(3).Days.get(0).dataFound;
                Boolean dataf3 = report.calendar.get(7).Days.get(0).dataFound;
                String proj2 = report.calendar.get(4).Project;
                String proj3 = report.calendar.get(7).Project;
               
            Test.stopTest();
            
            //Run 
            System.assertEquals('WFB Closing Count',proj,'The name of the project doesnt match');
            System.assertEquals('BU Investment Opening Count',proj2,'The name of the project doesnt match');
            System.assertEquals('Corp Bench Opening Count',proj3,'The name of the project doesnt match');

            System.assertEquals(con.Id, empId,'Id of employee doesnt match');
            System.assert(dataf,'DataFound is false');
            System.assertEquals(false, dataf3,'DataFound is true');


        }  
    }  
}
