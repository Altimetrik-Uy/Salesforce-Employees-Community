public class yearProgress {
   
   @AuraEnabled 
    public static List<String> getAccounts(){
        Integer lastYear = date.today().year() - 1;
        Date d = Date.parse('12/01/'+lastYear);
        List<String> toReturn = new List<String>();
        for (AggregateResult a: [select Project__r.Account.Name aName from Employee_Assignment__c WHERE End_Date__c>=:d and Project__r.Area__c='Salesforce' group by Project__r.Account.Name]){
            toReturn.add((String)a.get('aName'));
        }  
        return toReturn;
    }
   @AuraEnabled
   public static  List<Map<String, Map<String, Integer>>> yearProgressT(Boolean removeFinishedProjects, Boolean forecastedProjects, List<String> accounts){
   	   Integer currentYear = date.today().year();
       Map<String, Map<String, Integer>> table = new Map<String, Map<String, Integer>>();
       table.put('12-'+String.valueOf(currentYear-1), monthData('12', String.valueOf(currentYear-1), accounts));
       table.put('01-'+String.valueOf(currentYear), monthData('01', String.valueOf(currentYear), accounts));
       table.put('02-'+String.valueOf(currentYear), monthData('02', String.valueOf(currentYear), accounts));
       table.put('03-'+String.valueOf(currentYear), monthData('03', String.valueOf(currentYear), accounts));
       table.put('04-'+String.valueOf(currentYear), monthData('04', String.valueOf(currentYear), accounts));
       table.put('05-'+String.valueOf(currentYear), monthData('05', String.valueOf(currentYear), accounts));
       table.put('06-'+String.valueOf(currentYear), monthData('06', String.valueOf(currentYear), accounts));
       table.put('07-'+String.valueOf(currentYear), monthData('07', String.valueOf(currentYear), accounts));
       table.put('08-'+String.valueOf(currentYear), monthData('08', String.valueOf(currentYear), accounts));
       table.put('09-'+String.valueOf(currentYear), monthData('09', String.valueOf(currentYear), accounts));
       table.put('10-'+String.valueOf(currentYear), monthData('10', String.valueOf(currentYear), accounts));
       table.put('11-'+String.valueOf(currentYear), monthData('11', String.valueOf(currentYear), accounts));
       table.put('12-'+String.valueOf(currentYear), monthData('12', String.valueOf(currentYear), accounts));
       
       Map<String, Map<String, Integer>> table1 = new Map<String, Map<String, Integer>>();
       table1.put('12-'+String.valueOf(currentYear-1),plannedMonthData('12', String.valueOf(currentYear-1), accounts));
       table1.put('01-'+String.valueOf(currentYear), plannedMonthData('01', String.valueOf(currentYear), accounts));
       table1.put('02-'+String.valueOf(currentYear), plannedMonthData('02', String.valueOf(currentYear), accounts));
       table1.put('03-'+String.valueOf(currentYear), plannedMonthData('03', String.valueOf(currentYear), accounts));
       table1.put('04-'+String.valueOf(currentYear), plannedMonthData('04', String.valueOf(currentYear), accounts));
       table1.put('05-'+String.valueOf(currentYear), plannedMonthData('05', String.valueOf(currentYear), accounts));
       table1.put('06-'+String.valueOf(currentYear), plannedMonthData('06', String.valueOf(currentYear), accounts));
       table1.put('07-'+String.valueOf(currentYear), plannedMonthData('07', String.valueOf(currentYear), accounts));
       table1.put('08-'+String.valueOf(currentYear), plannedMonthData('08', String.valueOf(currentYear), accounts));
       table1.put('09-'+String.valueOf(currentYear), plannedMonthData('09', String.valueOf(currentYear), accounts));
       table1.put('10-'+String.valueOf(currentYear), plannedMonthData('10', String.valueOf(currentYear), accounts));
       table1.put('11-'+String.valueOf(currentYear), plannedMonthData('11', String.valueOf(currentYear), accounts));
       table1.put('12-'+String.valueOf(currentYear), plannedMonthData('12', String.valueOf(currentYear), accounts));
       
       
      
       Map<String, Map<String, Integer>> totals = new Map<String, Map<String, Integer>>();
       Map<String, Map<String, Integer>> totalsExpected = new Map<String, Map<String, Integer>>();
       Map<String, Map<String, Integer>> byproject = new Map<String, Map<String, Integer>>();
       Map<String, Map<String, Integer>> byprojectExpected = new Map<String, Map<String, Integer>>();

       Set<String> dates = table.keySet();
       Set<String> projects = new Set<String>();
       for (String year: table.keySet()){
           Integer t = 0;
          
           for (String project: table.get(year).keySet()){
               projects.add(project);
               t = t+ table.get(year).get(project);
           }
           
           
           Map<String, Integer> subTotal = new Map<String, Integer>();
           Map<String, Integer> subTotal1 = new Map<String, Integer>();
           subTotal.put('total', t);
           subTotal1.put('total', t);
           totals.put(year, subTotal);
           totalsExpected.put(year, subTotal1);
       }
       
       for (String year: table1.keySet()){
           Integer t = 0;
           for (String project: table1.get(year).keySet()){
               if (!projects.contains(project)){
                   projects.add(project);
               }
               t = t+ table1.get(year).get(project);
           }
           Map<String, Integer> subTotal1 = new Map<String, Integer>();
           subTotal1 = totalsExpected.get(year);
           Integer beforeCount = subTotal1.get('total');
           beforeCount = beforeCount + t;
           subTotal1.put('total', beforeCount);
           
           totalsExpected.put(year, subTotal1);
       }
       
       
       
       List<Map<String, Map<String, Integer>>> toReturn = new List<Map<String, Map<String, Integer>>>();
       toReturn.add(totals);
       
       for (string d: dates){ //remove the months of current year that have passed
           String lastyear = '12-'+ String.valueOf(currentYear);
           if (d != lastyear){
               Integer currentMonth = date.today().month();
               if (Integer.valueOf(d.split('-')[0]) < currentMonth ){
                   dates.remove(d);
                   totals.remove(d);
                   totalsExpected.remove(d);
               }
           }
           
       }

       for (String projectName: projects){
           for (String d: dates){
               if (byProject.get(projectName) == null){
                   Map<String, Integer> aux = new Map<String, Integer>();
                   aux.put(d, 0);
                   byProject.put(projectName, aux);
               }else{
                   byProject.get(projectName).put(d,0);
               }
               
               if (byprojectExpected.get(projectName) == null){
                   Map<String, Integer> aux = new Map<String, Integer>();
                   aux.put(d, 0);
                   byprojectExpected.put(projectName, aux);
               }else{
                   byprojectExpected.get(projectName).put(d,0);
               }
               
           }
           
       }
       Set<String> withNoDataProjects = projects.clone();
       Set<String> withNoForecast = projects.clone();
       
       String lastyear = '12-'+ String.valueOf(currentYear-1);
      
       for (String year: table.keySet()){
           Integer t = 0;
           for (String project: table.get(year).keySet()){
               t = t+ table.get(year).get(project);
               if (byProject.get(project) != null){
                   byProject.get(project).put(year, table.get(year).get(project)+0);
                   if (withNoDataProjects.contains(project) && table.get(year).get(project)>0 && year!=lastyear){
                      withNoDataProjects.remove(project);
                   } 
               }else{
                   Map<String, Integer> aux = new Map<String, Integer>();
                   aux.put(year, table.get(year).get(project));
                   byProject.put(project, aux);
                   if (withNoDataProjects.contains(project) && table.get(year).get(project)>0 && year!=lastyear){
                       withNoDataProjects.remove(project);
                   } 
               }
               
           }
           Map<String, Integer> subTotal = new Map<String, Integer>();
           subTotal.put('total', t);
           totals.put(year, subTotal);
       }
       
       for (String year: table1.keySet()){
           Integer t = 0;
           for (String project: table1.get(year).keySet()){
               
               if (byprojectExpected.get(project) != null){
                   byprojectExpected.get(project).put(year, table1.get(year).get(project)+0);
                   if (withNoDataProjects.contains(project) && year!=lastyear && table1.get(year).get(project)>0){
                       withNoDataProjects.remove(project);
                   } 
                   if (table1.get(year).get(project)>0){
                       withNoForecast.remove(project);  
                   }
               }else{
                   Map<String, Integer> aux = new Map<String, Integer>();
                   aux.put(year, table1.get(year).get(project));
                   byprojectExpected.put(project, aux);
                   if (withNoDataProjects.contains(project) && year!=lastyear && table1.get(year).get(project)>0){
                       withNoDataProjects.remove(project);
                   } 
                   if (table1.get(year).get(project)>0){
                       withNoForecast.remove(project);  
                   }
                   
               }
           }
       }
       if (removeFinishedProjects){
           for (String pName: withNoDataProjects){
               byProject.remove(pName);
               byprojectExpected.remove(pName);
           }
       }
       if (forecastedProjects){
        for (String pName: withNoForecast){
               byProject.remove(pName);
               byprojectExpected.remove(pName);
        }   
       }
       toReturn.add(byProject);
       toReturn.add(byprojectExpected);
       toReturn.add(totalsExpected);

       return toReturn; //return null;
   }
   
   private static Map<String, Integer> monthData(String m, String y, List<String> accounts){
       Date d = Date.parse(m+'/01/'+y);
       Integer numberOfDays = Date.daysInMonth(Integer.valueOf(y), Integer.valueOf(m));
       Date lastd = Date.parse(m+'/'+String.valueOf(numberOfDays)+'/'+y);
       List<AggregateResult> eas = [select Project__r.Name pName, COUNT(id) c from Employee_Assignment__c WHERE Project__r.Account.Name in: accounts AND Base_Category__c='BILLED' and End_Date__c>=:d and Start_Date__c<=:lastd and Project__r.Area__c='Salesforce' group by Project__r.Name order by Project__r.Name ASC];
       Map<String, Integer> auxData = new Map<String, Integer>();
       
       for (AggregateResult ea: eas){
           auxData.put((String)ea.get('pName'), (Integer)ea.get('c'));
       }
       return auxData;
   }
   
   private static Map<String, Integer> plannedMonthData(String m, String y, List<String> accounts){
       Date d = Date.parse(m+'/01/'+y);
       Integer numberOfDays = Date.daysInMonth(Integer.valueOf(y), Integer.valueOf(m));
       Date lastd = Date.parse(m+'/'+String.valueOf(numberOfDays)+'/'+y);
       List<AggregateResult> eas = [select Project__r.Name pName, COUNT(id) c from Employee_Assignment__c WHERE Project__r.Account.Name in:accounts and Base_Category__c='' and End_Date__c>=:d and Start_Date__c<=:lastd and Project__r.Area__c='Salesforce' group by Project__r.Name order by Project__r.Name ASC];
       Map<String, Integer> auxData = new Map<String, Integer>();
       
       for (AggregateResult ea: eas){
           auxData.put((String)ea.get('pName'), (Integer)ea.get('c'));
       }
       return auxData;
   }
   
   public class ProjectMonthDataWrapper {
        public String projectName {get; set;}
        public Integer currentData {get; set;}
        public Integer forecastData {get; set;}
 
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public ProjectMonthDataWrapper(String projectName) {
            projectName = projectName;
        }
        
        public void setCurrentData(Integer data){
            currentData = data;
        }
        
        public void setForecastData(Integer data){
            forecastData = data;
        }
        
       public String getProjectName(){
           return this.projectName;
       }
       public Integer getCurrentData(){
           return this.currentData;
       }
       public Integer getForeCastData(){
           return this.forecastData;
       }
    }
}