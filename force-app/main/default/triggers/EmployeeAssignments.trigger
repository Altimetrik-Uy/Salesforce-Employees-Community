/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Employee Assignments Trigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Schubert Tonarelli   <stonarelli@altimetrik.com>
* @created        2020-04-20
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
trigger EmployeeAssignments on Employee_Assignment__c ( before insert, before update, after insert, after update ) {
    
    Set<String> empAssByProjectSet = new  Set<String>();

    if( Trigger.isBefore ){
        
        Set<Id> employeeIds = new Set<Id>();
        for( Employee_Assignment__c e: Trigger.New ) 
            if( String.isEmpty( e.Role__c ) ) 
            	employeeIds.add( e.Employee__c ); 
        
        Map<Id, Contact> employeeByIdMap = new Map<Id, Contact>();
        if( employeeIds.size() > 0 )
       		employeeByIdMap = new Map<Id, Contact>( [SELECT Id, Role__c FROM Contact WHERE Id IN: employeeIds] );
        
        for( Employee_Assignment__c e: Trigger.New ){
            if( String.isEmpty( e.Role__c ) ) 
                e.Role__c = employeeByIdMap.get( e.Employee__c ).Role__c;
            e.Active__c = ( e.End_Date__c >= Date.today() && e.Start_Date__c <= Date.today() );
        }            
    }
    
    if( Trigger.isAfter ){
        
        if( Trigger.isInsert ){
            
            for( Employee_Assignment__c e: Trigger.New ) {
                if( !empAssByProjectSet.contains(e.Project__c) ){ 
                    empAssByProjectSet.add( e.Project__c );
                }
            }
            EmployeeAssignmentsTrigger.projectInsertArea(empAssByProjectSet);
        }   
        
        
        if( Trigger.isUpdate ){ 
            
            for( Employee_Assignment__c e: Trigger.New ){ 
                
                if( !empAssByProjectSet.contains(e.Project__c) && ( Trigger.newMap.get(e.Id).Start_Date__c != Trigger.oldMap.get(e.Id).Start_Date__c 
                    ||  Trigger.newMap.get(e.Id).End_Date__c != Trigger.oldMap.get(e.Id).End_Date__c )
                  ){
                    
                    empAssByProjectSet.add( e.Project__c );
                }
            }
        }
        // Update Project Stage
        EmployeeAssignmentsTrigger.projectStartEndDate( empAssByProjectSet );
    }
}