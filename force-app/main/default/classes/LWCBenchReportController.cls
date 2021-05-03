public class LWCBenchReportController {

    private static final String OverallNonBilledOpeningCount   = 'Overall Non Billed Opening Count';
    private static final String WFBOpeningCount                = 'WFB Opening Count';
    private static final String WFBtoBilled                    = 'WFB to Billed';
    private static final String WFBClosingCount                = 'WFB Closing Count';
    private static final String BUInvestmentOpeningCount       = 'BU Investment Opening Count';
    private static final String BUInvestmentToBilled           = 'BU Investment to Billed';
    private static final String BUInvestmentClosingCount       = 'BU Investment Closing Count';
    private static final String CorpBenchOpeningCount          = 'Corp Bench Opening Count';
    private static final String CorpBenchDeployment            = 'Corp Bench Deployment';
    private static final String RollOffBilledToBench           = 'Roll Off (Billed to Bench)';
    private static final String RollOffDeployed                = 'Roll Off Deployed';
    private static final String CorpBenchClosingCount          = 'Corp Bench Closing Count';
    private static final String OverallNonBilledClosingCount   = 'Overall Non Billed Closing Count';

    private static final Date startOfWeek1 = Date.today().toStartOfWeek();
    private static final Date endOfWeek1   = startOfWeek1.addDays(6);
    private static final Date startOfWeek2 = Date.today().addDays(7).toStartOfWeek();
    private static final Date endOfWeek2   = startOfWeek2.addDays(6);
    private static final Date startOfWeek3 = Date.today().addDays(14).toStartOfWeek();
    private static final Date endOfWeek3   = startOfWeek3.addDays(6);
    private static final Date startOfWeek4 = Date.today().addDays(21).toStartOfWeek();
    private static final Date endOfWeek4   = startOfWeek4.addDays(6);
    private static final Date startOfWeek5 = Date.today().addDays(28).toStartOfWeek();

    @AuraEnabled
    public static Object getData(){
        
        wrpBenchReport benchReport = new wrpBenchReport();
        try {
            Time init = Time.newInstance(0,0,0,0);
            benchReport.columns = new List<String>();
            benchReport.columns.add('');
            benchReport.columns.add(''+Datetime.newInstance(startOfWeek1,init).format('d-MMM'));
            benchReport.columns.add(''+Datetime.newInstance(startOfWeek2,init).format('d-MMM'));
            benchReport.columns.add(''+Datetime.newInstance(startOfWeek3,init).format('d-MMM'));
            benchReport.columns.add(''+Datetime.newInstance(startOfWeek4,init).format('d-MMM'));

            Map<String, wrpCalendar> calendarByProject = initMap();
            
            for(Employee_Assignment__c assignment: [
                SELECT  Id, Active__c, Base_Category__c, Employee__c, Employee__r.Name, Employee__r.Role__c, Employee__r.Image__c, Project__c, Start_Date__c, End_Date__c 
                FROM    Employee_Assignment__c 
                WHERE   Active__c = true
                AND     Start_Date__c <: startOfWeek5
                AND     End_Date__c >=: startOfWeek1
                ]){
                // Overall Non Billed Opening Count
                if(assignment.Base_Category__c == 'NON-BILLED' || assignment.Base_Category__c == 'WFB' || assignment.Base_Category__c == 'INVESTMENT'){
                    wrpCalendar oNBOC = processAssignment(assignment, OverallNonBilledOpeningCount, calendarByProject);
                    calendarByProject.put(OverallNonBilledOpeningCount,oNBOC);
                }
                // WFB Opening Count
                if(assignment.Base_Category__c == 'WFB'){
                    wrpCalendar wOC = processAssignment(assignment, WFBOpeningCount, calendarByProject);
                    calendarByProject.put(WFBOpeningCount,wOC);
                }
                // WFB to Billed
                if(assignment.Base_Category__c == 'WFB'){
                    wrpCalendar wTB = processAssignmentToBilled(assignment, WFBtoBilled, calendarByProject);
                    calendarByProject.put(WFBtoBilled,wTB);
                }
                // WFB Closing Count
                wrpCalendar wCC = processAssignmentClosing(WFBOpeningCount, WFBtoBilled, WFBClosingCount, calendarByProject);
                calendarByProject.put(WFBClosingCount,wCC);
                // BU Investment Opening Count
                if(assignment.Base_Category__c == 'INVESTMENT'){
                    wrpCalendar bIOC = processAssignment(assignment, BUInvestmentOpeningCount, calendarByProject);
                    calendarByProject.put(BUInvestmentOpeningCount,bIOC);
                }
                // BU Investment to Billed
                if(assignment.Base_Category__c == 'INVESTMENT'){
                    wrpCalendar bITB = processAssignmentToBilled(assignment, BUInvestmentToBilled, calendarByProject);
                    calendarByProject.put(BUInvestmentToBilled,bITB);
                }
                // BU Investment Closing Count
                wrpCalendar bICC = processAssignmentClosing(BUInvestmentOpeningCount, BUInvestmentToBilled, BUInvestmentClosingCount, calendarByProject);
                calendarByProject.put(BUInvestmentClosingCount,bICC);
                // Corp Bench Opening Count
                wrpCalendar cBOC = processAssignmentCorpBenchOpeningCount(calendarByProject);
                calendarByProject.put(CorpBenchOpeningCount,cBOC);
                // Corp Bench Deployment
                if(assignment.Base_Category__c == 'NON-BILLED'){
                    wrpCalendar cBD = processAssignmentCorpBenchDeployment(assignment, calendarByProject.get(CorpBenchDeployment));
                    calendarByProject.put(CorpBenchDeployment,cBD);
                }
                // Roll Off (Billed to Bench)
                if(assignment.Base_Category__c == 'NON-BILLED'){
                    wrpCalendar rOBTB = processAssignmentRollOffBilledToBench(assignment, calendarByProject.get(RollOffBilledToBench));
                    calendarByProject.put(RollOffBilledToBench,rOBTB);
                }
                // Roll Off Deployed
                if(assignment.Base_Category__c == 'NON-BILLED'){
                    wrpCalendar rOD= processAssignmentRollOffDeployed(assignment, calendarByProject.get(RollOffDeployed));
                    calendarByProject.put(RollOffDeployed,rOD);
                }
                // Corp Bench Closing Count
                wrpCalendar cBCC = processAssignmentClosing(CorpBenchOpeningCount, CorpBenchDeployment, CorpBenchClosingCount, calendarByProject, RollOffBilledToBench, RollOffDeployed);
                calendarByProject.put(CorpBenchClosingCount,cBCC);
                // Overall Non Billed Closing Count
                wrpCalendar oNBCC = processAssignmentClosing(WFBOpeningCount, BUInvestmentClosingCount, OverallNonBilledClosingCount, calendarByProject, CorpBenchClosingCount);
                calendarByProject.put(OverallNonBilledClosingCount,oNBCC);
            }
            

            List<wrpCalendar> calendar = initCalendarList(calendarByProject);
            benchReport.calendar = calendar;
            return benchReport;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static List<wrpCalendar> initCalendarList(Map<String,wrpCalendar> calendarByProject){
        List<wrpCalendar> calendar = new List<wrpCalendar>();
        calendar.add(calendarByProject.get(OverallNonBilledOpeningCount));
        calendar.add(calendarByProject.get(WFBOpeningCount));
        calendar.add(calendarByProject.get(WFBtoBilled));
        calendar.add(calendarByProject.get(WFBClosingCount));
        calendar.add(calendarByProject.get(BUInvestmentOpeningCount));
        calendar.add(calendarByProject.get(BUInvestmentToBilled));
        calendar.add(calendarByProject.get(BUInvestmentClosingCount));
        calendar.add(calendarByProject.get(CorpBenchOpeningCount));
        calendar.add(calendarByProject.get(CorpBenchDeployment));
        calendar.add(calendarByProject.get(RollOffBilledToBench));
        calendar.add(calendarByProject.get(RollOffDeployed));
        calendar.add(calendarByProject.get(CorpBenchClosingCount));
        calendar.add(calendarByProject.get(OverallNonBilledClosingCount));
        return calendar;
    }

    private static Map<String,wrpCalendar> initMap(){
        Map<String, wrpCalendar> calendarByProject = new Map<String,wrpCalendar>();

        wrpCalendar oNBOC = initCalendar(OverallNonBilledOpeningCount, '0');
        calendarByProject.put(OverallNonBilledOpeningCount,oNBOC);
        wrpCalendar wOC = initCalendar(WFBOpeningCount, '1');
        calendarByProject.put(WFBOpeningCount,wOC);
        wrpCalendar wTB = initCalendar(WFBtoBilled, '2');
        calendarByProject.put(WFBtoBilled,wTB);
        wrpCalendar wCC = initCalendar(WFBClosingCount, '3');
        calendarByProject.put(WFBClosingCount,wCC);
        wrpCalendar bIOC = initCalendar(BUInvestmentOpeningCount, '4');
        calendarByProject.put(BUInvestmentOpeningCount,bIOC);
        wrpCalendar bITB = initCalendar(BUInvestmentToBilled, '5');
        calendarByProject.put(BUInvestmentToBilled,bITB);
        wrpCalendar bICC = initCalendar(BUInvestmentClosingCount, '6');
        calendarByProject.put(BUInvestmentClosingCount,bICC);
        wrpCalendar cBOC = initCalendar(CorpBenchOpeningCount, '7');
        calendarByProject.put(CorpBenchOpeningCount,cBOC);
        wrpCalendar cBC = initCalendar(CorpBenchDeployment, '8');
        calendarByProject.put(CorpBenchDeployment,cBC);
        wrpCalendar rOBTB = initCalendar(RollOffBilledToBench, '9');
        calendarByProject.put(RollOffBilledToBench,rOBTB);
        wrpCalendar rOD = initCalendar(RollOffDeployed, '10');
        calendarByProject.put(RollOffDeployed,rOD);
        wrpCalendar cBCC = initCalendar(CorpBenchClosingCount, '11');
        calendarByProject.put(CorpBenchClosingCount,cBCC);
        wrpCalendar oNBCC = initCalendar(OverallNonBilledClosingCount, '12');
        calendarByProject.put(OverallNonBilledClosingCount,oNBCC);

        return calendarByProject;
    }

    private static wrpCalendar initCalendar(String project, String id){
        wrpCalendar calendar = new wrpCalendar();
        calendar.Project = project;
        calendar.Id = id;
        calendar.Days = new List<wrpDays>();
        wrpDays week1 = new wrpDays();
        //week1.Id = 'week1+'+project;
        week1.Id = '0-'+id;
        week1.dataFound = false;
        week1.week = startOfWeek1.day()+'-'+startOfWeek1.month()+'-'+startOfWeek1.year();
        week1.employees = new List<wrpEmployee>();
        calendar.Days.add(week1);
        wrpDays week2 = new wrpDays();
        //week2.Id = 'week2+'+project;
        week2.Id = '1-'+id;
        week2.dataFound = false;
        week2.week = startOfWeek2.day()+'-'+startOfWeek2.month()+'-'+startOfWeek2.year();
        week2.employees = new List<wrpEmployee>();
        calendar.Days.add(week2);
        wrpDays week3 = new wrpDays();
        //week3.Id = 'week3+'+project;
        week3.Id = '2-'+id;
        week3.dataFound = false;
        week3.week = startOfWeek3.day()+'-'+startOfWeek3.month()+'-'+startOfWeek3.year();
        week3.employees = new List<wrpEmployee>();
        calendar.Days.add(week3);
        wrpDays week4 = new wrpDays();
        //week4.Id = 'week4+'+project;
        week4.Id = '3-'+id;
        week4.dataFound = false;
        week4.week = startOfWeek4.day()+'-'+startOfWeek4.month()+'-'+startOfWeek4.year();
        week4.employees = new List<wrpEmployee>();
        calendar.Days.add(week4);        
        return calendar;
    }

    private static wrpEmployee initEmployee(Employee_Assignment__c assignment){
        wrpEmployee employee = new wrpEmployee();
        employee.Id = assignment.Employee__c;
        employee.Name = assignment.Employee__r.Name;
        employee.Role = assignment.Employee__r.Role__c;
        employee.Image = assignment.Employee__r.Image__c;
        return employee;
    }

    private static wrpCalendar processAssignment(Employee_Assignment__c assignment, String project, Map<String, wrpCalendar> calendarByProject){
        wrpCalendar calendar = calendarByProject.get(project);
        wrpEmployee employee = initEmployee(assignment);
        List<wrpDays> Days;
        if(isInWeek(assignment,1)){
            Days = addEmployee(calendar.Days, employee, 1);
        }
        if(isInWeek(assignment,2)){
            Days = addEmployee(calendar.Days, employee, 2);
        }
        if(isInWeek(assignment,3)){
            Days = addEmployee(calendar.Days, employee, 3);
        }
        if(isInWeek(assignment,4)){
            Days = addEmployee(calendar.Days, employee, 4);
        }
        if(Days != null){
            calendar.Days = Days;
        }
        return calendar;
    }

    private static wrpCalendar processAssignmentToBilled(Employee_Assignment__c assignment, String project, Map<String, wrpCalendar> calendarByProject){
        wrpCalendar calendar = calendarByProject.get(project);
        wrpEmployee employee = initEmployee(assignment);
        List<wrpDays> Days;
        if(isInWeekToBilled(assignment,1)){
            Days = addEmployee(calendar.Days, employee, 1);
        }
        if(isInWeekToBilled(assignment,2)){
            Days = addEmployee(calendar.Days, employee, 2);
        }
        if(isInWeekToBilled(assignment,3)){
            Days = addEmployee(calendar.Days, employee, 3);
        }
        if(isInWeekToBilled(assignment,4)){
            Days = addEmployee(calendar.Days, employee, 4);
        }
        if(Days != null){
            calendar.Days = Days;
        }
        return calendar;
    }

    private static wrpCalendar processAssignmentClosing(String project1, String project2, String projectResult, Map<String, wrpCalendar> calendarByProject){
        return processAssignmentClosing(project1, project2, projectResult, calendarByProject, null, null);
    }

    private static wrpCalendar processAssignmentClosing(String project1, String project2, String projectResult, Map<String, wrpCalendar> calendarByProject, String project3){
        return processAssignmentClosing(project1, project2, projectResult, calendarByProject, project3, null);
    }

    private static wrpCalendar processAssignmentClosing(String project1, String project2, String projectResult, Map<String, wrpCalendar> calendarByProject, String project3, String project4){
        wrpCalendar cal1 = calendarByProject.get(project1);
        wrpCalendar cal2 = calendarByProject.get(project2);
        wrpCalendar cal3, cal4;
        if(project3 != null){
            cal3 = calendarByProject.get(project3);
        }
        if(project4 != null){
            cal4 = calendarByProject.get(project4);
        }
        wrpCalendar calR = calendarByProject.get(projectResult);
        List<wrpDays> days1 = cal1.Days;
        List<wrpDays> days2 = cal2.Days;
        List<wrpDays> days3,days4;
        if(cal3 != null){
            days3 = cal3.Days;
        }
        if(cal4 != null){
            days4 = cal4.Days;
        }
        List<wrpDays> daysR = calR.Days;
        for(Integer index=0; index < 4; index++){
            wrpDays day1 = days1.get(index);
            wrpDays day2 = days2.get(index);
            wrpDays day3,day4;
            wrpDays dayR = daysR.get(index);
            dayR.employees = day1.employees;
            for(wrpEmployee emp : day2.employees){
                /*Boolean found = false;
                for(wrpEmployee added: dayR.employees){
                    if(emp.Id == added.Id) found = true;
                }
                if(!found) dayR.employees.add(emp);*/
                if(!dayR.employees.contains(emp)){
                    dayR.employees.add(emp);
                }
            }
            if(days3 != null){
                day3 = days3.get(index);
                for(wrpEmployee emp : day3.employees){
                    if(!dayR.employees.contains(emp)){
                        dayR.employees.add(emp);
                    }
                }
            }
            if(days4 != null){
                day4 = days4.get(index);
                for(wrpEmployee emp : day4.employees){
                    if(!dayR.employees.contains(emp)){
                        dayR.employees.add(emp);
                    }
                }
            }
            dayR.dataFound = (dayR.employees.size() > 0) ? true : false;
            calR.Days.set(index,dayR);
        }
        return calR;
    }

    private static wrpCalendar processAssignmentCorpBenchOpeningCount(Map<String,wrpCalendar> calendarByProject){
        wrpCalendar oNBOC = calendarByProject.get(OverallNonBilledOpeningCount);
        wrpCalendar wOC = calendarByProject.get(WFBOpeningCount);
        wrpCalendar bIOC = calendarByProject.get(BUInvestmentOpeningCount);
        wrpCalendar cBOC = calendarByProject.get(CorpBenchOpeningCount);
        List<wrpDays> oNBOCDays = oNBOC.Days;
        List<wrpDays> wOCDays = wOC.Days;
        List<wrpDays> bIOCDays = bIOC.Days;
        List<wrpDays> cBOCDays = cBOC.Days;
        for(Integer index=0; index < 4; index++){
            wrpDays oNBOCDay = oNBOCDays.get(index);
            wrpDays wOCDay = wOCDays.get(index);
            wrpDays bIOCDay = bIOCDays.get(index);
            wrpDays cBOCDay = cBOCDays.get(index);
            cBOCDay.employees = oNBOCDay.employees;
            for(wrpEmployee emp: wOCDay.employees){
                for(integer i = cBOCDay.employees.size()-1; i >= 0; --i){
                    if(emp.equals(cBOCDay.employees.get(i))){
                        cBOCDay.employees.remove(i);
                    }
                }
            }
            for(wrpEmployee emp: bIOCDay.employees){
                for(integer i = cBOCDay.employees.size()-1; i >= 0; --i){
                    if(emp.equals(cBOCDay.employees.get(i))){
                        cBOCDay.employees.remove(i);
                    }
                }
            }
            cBOCDay.dataFound = (cBOCDay.employees.size() > 0) ? true : false;
            cBOCDays.set(index, cBOCDay);
        }
        cBOC.Days = cBOCDays;
        return cBOC;
    }

    private static wrpCalendar processAssignmentCorpBenchDeployment(Employee_Assignment__c assignment, wrpCalendar cBD){
        wrpEmployee employee = initEmployee(assignment);
        List<wrpDays> Days;
        if(endsInWeek(assignment,1)){
            Days = addEmployee(cBD.Days, employee, 1);
        }else if(endsInWeek(assignment,2)){
            Days = addEmployee(cBD.Days, employee, 2);
        }else if(endsInWeek(assignment,3)){
            Days = addEmployee(cBD.Days, employee, 3);
        }else if(endsInWeek(assignment,4)){
            Days = addEmployee(cBD.Days, employee, 4);
        }
        if(Days != null){
            cBD.Days = Days;
        }
        return cBD;
    }

    private static wrpCalendar processAssignmentRollOffBilledToBench(Employee_Assignment__c assignment, wrpCalendar rOBTB){
        wrpEmployee employee = initEmployee(assignment);
        List<wrpDays> Days;
        if(startsInWeek(assignment,1)){
            Days = addEmployee(rOBTB.Days, employee, 1);
        }else if(startsInWeek(assignment,2)){
            Days = addEmployee(rOBTB.Days, employee, 2);
        }else if(startsInWeek(assignment,3)){
            Days = addEmployee(rOBTB.Days, employee, 3);
        }else if(startsInWeek(assignment,4)){
            Days = addEmployee(rOBTB.Days, employee, 4);
        }
        if(Days != null){
            rOBTB.Days = Days;
        }
        return rOBTB;
    }

    private static wrpCalendar processAssignmentRollOffDeployed(Employee_Assignment__c assignment, wrpCalendar rOD){
        wrpEmployee employee = initEmployee(assignment);
        List<wrpDays> Days;
        if(endsInWeek(assignment,1)){
            Days = addEmployee(rOD.Days, employee, 1);
        }else if(endsInWeek(assignment,2)){
            Days = addEmployee(rOD.Days, employee, 2);
        }else if(endsInWeek(assignment,3)){
            Days = addEmployee(rOD.Days, employee, 3);
        }else if(endsInWeek(assignment,4)){
            Days = addEmployee(rOD.Days, employee, 4);
        }
        if(Days != null){
            rOD.Days = Days;
        }
        return rOD;
    }

    private static Boolean isInWeek(Employee_Assignment__c assignment, Integer week){
        Date startDate = assignment.Start_Date__c;
        Date endDate = assignment.End_Date__c;
        Date startOfWeek,startOfNextWeek;

        if(week == 1){
            startOfWeek = startOfWeek1;
            startOfNextWeek = startOfWeek2;
        }else if(week == 2){
            startOfWeek = startOfWeek2;
            startOfNextWeek = startOfWeek3;
        }else if(week == 3){
            startOfWeek = startOfWeek3;
            startOfNextWeek = startOfWeek4;
        }else {
            startOfWeek = startOfWeek4;
            startOfNextWeek = startOfWeek5;
        }
        if( (startDate <= startOfWeek && endDate > startOfWeek) ||
            (startDate > startOfWeek && startDate < startOfNextWeek)){
            return true;
        }
        return false;
    }

    private static Boolean isInWeekToBilled(Employee_Assignment__c assignment, Integer week){
        Date startDate = assignment.Start_Date__c;
        Date endDate = assignment.End_Date__c;
        Date startOfWeek,endOfWeek;

        if(week == 1){
            startOfWeek = startOfWeek1;
            endOfWeek = endOfWeek1;
        }else if(week == 2){
            startOfWeek = startOfWeek2;
            endOfWeek = endOfWeek2;
        }else if(week == 3){
            startOfWeek = startOfWeek3;
            endOfWeek = endOfWeek3;
        }else {
            startOfWeek = startOfWeek4;
            endOfWeek = endOfWeek4;
        }
        if(startDate < endOfWeek && endDate > endOfWeek){
            return true;
        }
        return false;
    }

    private static Boolean startsInWeek(Employee_Assignment__c assignment, Integer week){
        Date startDate = assignment.Start_Date__c;
        Date startOfWeek,endOfWeek;
        if(week == 1){
            startOfWeek = startOfWeek1;
            endOfWeek = endOfWeek1;
        }else if(week == 2){
            startOfWeek = startOfWeek2;
            endOfWeek = endOfWeek2;
        }else if(week == 3){
            startOfWeek = startOfWeek3;
            endOfWeek = endOfWeek3;
        }else {
            startOfWeek = startOfWeek4;
            endOfWeek = endOfWeek4;
        }
        if(startDate >= startOfWeek && startDate <= endOfWeek){
            return true;
        }
        return false;
    }

    private static Boolean endsInWeek(Employee_Assignment__c assignment, Integer week){
        Date endDate = assignment.End_Date__c;
        Date endOfWeek;
        if(week == 1){
            endOfWeek = endOfWeek1;
        }else if(week == 2){
            endOfWeek = endOfWeek2;
        }else if(week == 3){
            endOfWeek = endOfWeek3;
        }else {
            endOfWeek = endOfWeek4;
        }
        if(endDate <= endOfWeek){
            return true;
        }
        return false;
    }

    private static List<wrpDays> addEmployee(List<wrpDays> Days, wrpEmployee employee, Integer dayNumber){
        Integer index = dayNumber - 1;
        wrpDays day = Days.get(index);
        List<wrpEmployee> employees = day.employees;
        employees.add(employee);
        day.dataFound = true;
        day.employees = employees;
        Days.set(index,day);
        return Days;
    }

    /*
        "columns":['','12-Feb','19-Feb','26-Feb','5-Mar'],
        "calendar" :  [ 
        {
            "Project": "Overall Non Billed Opening Count",
            "Id":"10",
            "Days" :[
                {"Id":"date1+proyect","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                {"Id":"date2+proyect","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                {"Id":"date3+proyect","dataFound":false, "date":"26-02-2021","employees":["id1","id2","id3"]},
                {"Id":"date4+proyect","dataFound":false, "date":"05-03-2021","employees":["id1","id2","id3"]}
            ]
        },
    */

    public class wrpBenchReport {
        @AuraEnabled public List<String> columns = new List<String>();
        @AuraEnabled public List<wrpCalendar> calendar = new List<wrpCalendar>();
    }

    public class wrpCalendar {
        @AuraEnabled public String Project;
        @AuraEnabled public String Id;
        @AuraEnabled public List<wrpDays> Days = new List<wrpDays>();
    }

    public class wrpDays {
        @AuraEnabled public String Id;
        @AuraEnabled public Boolean dataFound;
        @AuraEnabled public String week;
        @AuraEnabled public List<wrpEmployee> employees = new List<wrpEmployee>();
    }

    public class wrpEmployee {
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String Role;
        @AuraEnabled public String Image;

        public Boolean equals(Object instance)
        {
            wrpEmployee that = (wrpEmployee)instance;
            return this.Id == that.Id;
        }
        public String hashCode()
        {
            return Id;
        }
    }
    
}
