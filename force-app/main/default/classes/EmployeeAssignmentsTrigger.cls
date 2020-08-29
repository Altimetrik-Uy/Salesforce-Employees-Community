/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Employee Assignments Trigger Helper
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Schubert Tonarelli   <stonarelli@altimetrik.com>
* @created        2020-04-20
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class EmployeeAssignmentsTrigger {
/**
* ─────────────────────────────────────────────────────────────────────────────────────────────┐
* Update Project Stage by Employee_Assignment Start Date And End Date
* Skip Prospecting Projects
* ──────────────────────────────────────────────────────────────────────────────────────────────
* @param    projectIdSet    Projects to update StageName
* @return   
* ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static void projectInsertArea( Set<String> projectIdSet ){
        List<Opportunity> ops = [SELECT id, Area__c from Opportunity where id in:projectIdSet];
        for (Opportunity op: ops){
            if( String.isEmpty( op.Area__c ) ) op.Area__c = 'Salesforce';
        }
        update ops;
    }
    public static void projectStartEndDate( Set<String> projectIdSet ){
        
        Map<String, Employee_Assignment__c> auxMap = new Map<String, Employee_Assignment__c>();
        
        for( Employee_Assignment__c e : [SELECT Id, Start_Date__c, End_Date__c, Project__c 
                                         FROM Employee_Assignment__c 
                                         WHERE Project__c IN :projectIdSet AND Project__r.StageName != 'Prospecting'
                                         ORDER BY Project__c DESC] ){
                                             
            if( !auxMap.containsKey(e.Project__c) ) auxMap.put( e.Project__c, new Employee_Assignment__c( Project__c = e.Project__c, Start_Date__c = NULL, End_Date__c = NULL ) );
                                             
            if( auxMap.get( e.Project__c ).Start_Date__c == NULL || auxMap.get( e.Project__c ).Start_Date__c > e.Start_Date__c ) auxMap.get( e.Project__c ).Start_Date__c = e.Start_Date__c;
                                             
            if( auxMap.get( e.Project__c ).End_Date__c == NULL || auxMap.get( e.Project__c ).End_Date__c < e.End_Date__c ) auxMap.get( e.Project__c ).End_Date__c = e.End_Date__c;
        }
        
        List<Opportunity> optyUpdatesList = new List<Opportunity>();
        
        for( String i : auxMap.keySet() ){
            
            Opportunity o = new Opportunity( Id = i, StageName = NULL );
            
            if( auxMap.get(i).Start_Date__c <= Date.today() && auxMap.get(i).End_Date__c >= Date.today() ) o.StageName = 'In Progress';
               
            if( auxMap.get(i).Start_Date__c < Date.today() && auxMap.get(i).End_Date__c < Date.today() ) o.StageName = 'Finished';
            
            o.Start_Date__c = auxMap.get(i).Start_date__c;
            o.End_Date__c = auxMap.get(i).End_Date__c;
            optyUpdatesList.add(o);
        }
        
        update optyUpdatesList;
    }
}