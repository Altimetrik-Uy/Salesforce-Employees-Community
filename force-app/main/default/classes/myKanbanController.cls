/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* myKanban VfPage-Site Controller 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Schubert Tonarelli   <stonarelli@altimetrik.com>
* @created        2020-05-15
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class myKanbanController {

    public String errorMessage { get; set; }
    public String errorType { get; set; }
 
    public Boolean createPermission { get; set; }			// Check if user have permission to Employee Assignment Object
    
    public List<myKanbanItem> myKanbanItems { get; set; }
    
    public String saveAllJSON { get; set; }					// Info to save new Employee Assignment records
    
    public String filter { 
        get{
            return ( ApexPages.currentPage().getParameters().containsKey('filter')? ApexPages.currentPage().getParameters().get('filter') : 'all' );
    	}set; 
	}
    
    public class myKanbanItem {
        @AuraEnabled public Opportunity opty { get; set; }
		@AuraEnabled public List<Contact> contacts { get; set; }
		@AuraEnabled public List<Employee_Assignment__c> assignments { get; set; }
    }
   /**
   * @desc get all data to display in the page
   * @return Nothing.
   */ 
    public List<myKanbanItem> getKanbanItems(){
        
        Map<String, myKanbanItem> myKanbanItemsMap = new Map<String, myKanbanItem>();
		
        Map<Id, Opportunity> optyMap = new Map<Id, Opportunity>(); 
        if( filter == 'prospecting' ){ // Get all Prospecting Projects
        	optyMap = new Map<Id, Opportunity>([SELECT Id, Name, StageName FROM Opportunity WHERE StageName = 'Prospecting' AND Area__c = 'Salesforce' ORDER BY Name ASC]);
        }else{ // Get all Projects
        	optyMap = new Map<Id, Opportunity>([SELECT Id, Name, StageName FROM Opportunity WHERE Area__c = 'Salesforce' ORDER BY Name ASC]);
        }
        
        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, Name, Image__c FROM Contact WHERE Area__c = 'Salesforce' AND Active__c = TRUE]);
        
        // Bench
        myKanbanItemsMap.put( 'Bench', new myKanbanItem() );
        myKanbanItemsMap.get('Bench').opty = new Opportunity( Name = 'Bench' );
        myKanbanItemsMap.get('Bench').contacts = new List<Contact>();
        myKanbanItemsMap.get('Bench').assignments = new List<Employee_Assignment__c>();
        
        // Future Bench
        myKanbanItemsMap.put( 'Bench2', new myKanbanItem() );
        myKanbanItemsMap.get('Bench2').opty = new Opportunity( Name = 'Future Bench' );
        myKanbanItemsMap.get('Bench2').contacts = new List<Contact>();
        myKanbanItemsMap.get('Bench2').assignments = new List<Employee_Assignment__c>();
        
        for( Employee_Assignment__c e : [SELECT Id, Employee__c, Project__c, Project__r.Name, Start_Date__c, End_Date__c FROM Employee_Assignment__c WHERE 
                                         Area__c = 'Salesforce'
                                         AND Active__c = TRUE
                                         AND End_Date__c > :Date.today()
                                         AND End_Date__c < :Date.today().addmonths(1)]
           ){
            if( contactMap.containsKey( e.Employee__c ) && e.Project__r.Name != 'Bench'){
            	myKanbanItemsMap.get('Bench2').contacts.add( contactMap.get( e.Employee__c ) );
             	myKanbanItemsMap.get('Bench2').assignments.add( e );
            }
        }
        
        // Prospecting Projects
        for( Opportunity o: optyMap.values() ){
            if( o.StageName == 'Prospecting' ){
                myKanbanItemsMap.put( o.Id, new myKanbanItem() );
                myKanbanItemsMap.get(o.Id).opty = o;
                myKanbanItemsMap.get(o.Id).contacts = new List<Contact>();
                myKanbanItemsMap.get(o.Id).assignments = new List<Employee_Assignment__c>();                
            }
        }
        
        // WITH ASSIGMENTS
        for( Employee_Assignment__c e : [SELECT Id, Employee__c, Project__c, Start_Date__c, End_Date__c, Base_Category__c FROM Employee_Assignment__c WHERE 
                                         Area__c = 'Salesforce'
                                         AND Project__c IN:optyMap.keySet() 
                                         AND (Active__c = TRUE OR Start_Date__c>=TODAY) ORDER BY Project__r.Name ASC, Employee__R.Name ASC]){
            if( !myKanbanItemsMap.containsKey( e.Project__c ) ){ // add project
                myKanbanItemsMap.put( e.Project__c, new myKanbanItem() );
                myKanbanItemsMap.get(e.Project__c).opty = optyMap.get( e.Project__c );
                myKanbanItemsMap.get(e.Project__c).contacts = new List<Contact>();
                myKanbanItemsMap.get(e.Project__c).assignments = new List<Employee_Assignment__c>();
            }
            if( contactMap.containsKey( e.Employee__c ) ){ // add employees
               if (!myKanbanItemsMap.get(e.Project__c).contacts.contains(contactMap.get( e.Employee__c ))){
                myKanbanItemsMap.get(e.Project__c).contacts.add( contactMap.get( e.Employee__c ) );
            	myKanbanItemsMap.get(e.Project__c).assignments.add( e );
               }
            }
        }
        
        for( Employee_Assignment__c e : [SELECT Id, Employee__c, Project__c, Start_Date__c, End_Date__c, Base_Category__c FROM Employee_Assignment__c WHERE 
                                         employee__r.Area__c = 'Salesforce'
                                         AND Project__r.Name = 'Bench' AND Base_Category__c='NON-BILLED' 
                                         AND Active__c = TRUE  ORDER BY Id DESC]){
            myKanbanItemsMap.get('Bench').opty.Id = e.Project__c;
            myKanbanItemsMap.get('Bench').contacts.add(contactMap.get( e.Employee__c ));
        }
        
        return myKanbanItemsMap.values();
    }
   /**
   * @desc initialize page
   * @return Nothing.
   */ 
    public PageReference init(){
        this.createPermission = getCreatePermission(); // user permission on Employee_Assignment__c
        this.myKanbanItems = getKanbanItems(); // Get all items to show

        return NULL;
    }
   /**
   * @desc return if user have permission on Employee_Assignment__c object
   * @return Nothing.
   */ 
    public Boolean getCreatePermission(){
        User u = [SELECT profileId FROM user WHERE Id =: UserInfo.getUserId()];
        String profileId = u.profileId;
        List<ObjectPermissions> objPermissionList = [SELECT Id, PermissionsCreate  
                                                     FROM ObjectPermissions 
                                                     WHERE SobjectType = 'Employee_Assignment__c'
                                                     AND ParentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Id =: profileId )];
        if( !objPermissionList.isEmpty() ) return objPermissionList.get(0).PermissionsCreate;
        return false;
    }
   /**
   * @desc add new Prospecting Project
   * @return Nothing.
   */ 
    public PageReference addProject(){
        errorType = 'error';
        if( !String.isEmpty( saveAllJSON )){
            try{
                Map<String, Object> dataMap = (Map<String, Object>) JSON.deserializeUntyped( saveAllJSON );
                
                insert new Opportunity(
                    stageName = 'Prospecting',
					Area__c = 'Salesforce',
                    Name = String.valueOf( dataMap.get('Name') ),
                    CloseDate = Date.valueOf( String.valueOf( dataMap.get('CloseDate') ) )
                );
                errorType = 'success';
                errorMessage = 'Project was added';
                
                return refreshPage();
            }catch( Exception e ){
                errorMessage = e.getMessage();
            }
        }else{
            errorMessage = 'Please refresh the page.';
        }   
        return NULL;
    }
   /**
   * @desc add new Employee to Bench
   * @return Nothing.
   */ 
    public PageReference addEmployee(){
        errorType = 'error';
        if( !String.isEmpty( saveAllJSON )){
            try{
                Map<String, Object> dataMap = (Map<String, Object>) JSON.deserializeUntyped( saveAllJSON );
                Contact newEmployee = new Contact(
                    Area__c = 'Salesforce',
                    Active__c = TRUE,
                    FirstName = String.valueOf( dataMap.get('FirstName') ),
                    LastName = String.valueOf( dataMap.get('LastName') ),
                    Image__c = '<img src="/img/social/unknown_profile_pic.png?v=2" />'
                );
                insert newEmployee;
                
                insert new Employee_Assignment__c(
                    Base_Category__c = 'NON-BILLED',
                	Employee__c = newEmployee.Id,
                    Project__c = this.myKanbanItems.get(0).opty.Id, // Bench
                    Start_Date__c = Date.today(),
                    End_Date__c = Date.today().addDays(2)
                );
                
                errorType = 'success';
                errorMessage = 'Employee was added to Bench';
                
                return refreshPage();
            }catch( Exception e ){
                errorMessage = e.getMessage();
            }
        }else{
            errorMessage = 'Please refresh the page.';
        }
        return NULL;        
    }
   /**
   * @desc create Employee Assignment between Employees and Project
   * @return refresh page if all is OK, send error message if NOT
   */ 
    public PageReference saveAll(){
        errorType = 'error';
        if( createPermission ){
            if( !String.isEmpty( saveAllJSON )){
                try{
                    List<Employee_Assignment__c> saveDataList = new List<Employee_Assignment__c>();
                    Map<String, Object> dataMap = (Map<String, Object>) JSON.deserializeUntyped( saveAllJSON );
                    
                    for( String id_contact : dataMap.keySet() ){
                        
                        Map<String, Object> dataMap2 = (Map<String, Object>) dataMap.get(id_contact);
                        
						Employee_Assignment__c aux = new Employee_Assignment__c(
                            Base_Category__c = '',
                        	Employee__c = id_contact, 
                            Project__c = String.valueOf( dataMap2.get('project') ), 
                            Start_Date__c = Date.ValueOf( String.valueOf( dataMap2.get('start_date') ) ),  // 5/31/2013
                            End_Date__c = Date.ValueOf( String.valueOf( dataMap2.get('end_date') ) ),
                            Active__c = true
                        );
                        saveDataList.add(aux);
                    }
                    insert saveDataList;
                    
                    return refreshPage(); 
                }catch( Exception e ){
                    errorMessage = e.getMessage();
                }
            }
        }else{
            errorMessage = 'You don\'t have permission.';
        }
        return NULL;            
    }
   /**
   * @desc remove Employee Assignment from Prospecting Project
   * @return refresh page if all is OK, send error message if NOT
   */ 
    public PageReference removeEmployeeAssignment(){
        errorType = 'error';
        try{
            if( !String.isEmpty( saveAllJSON ) ){
                delete[SELECT Id FROM Employee_Assignment__c WHERE Id = :saveAllJSON AND Project__r.StageName = 'Prospecting' LIMIT 1];
                return refreshPage();  
            }
        }catch( Exception e ){
            errorMessage = e.getMessage();
        }
        return NULL;  
    }
   /**
   * @desc remove Prospecting Project And Employee Assignments asociated
   * @return refresh page if all is OK, send error message if NOT
   */ 
    public PageReference removeProject(){
        errorType = 'error';
        try{
            if( !String.isEmpty( saveAllJSON ) ){
                delete[SELECT Id FROM Employee_Assignment__c WHERE Project__c = :saveAllJSON];
                delete[SELECT Id FROM Opportunity WHERE Id = :saveAllJSON LIMIT 1];
				return refreshPage();
            }
        }catch( Exception e ){
            errorMessage = e.getMessage();
        }
        return NULL;  
    }
   /**
   * @desc refresh the page
   * @return refresh page
   */ 
    public PageReference refreshPage(){
        PageReference pageRef = new PageReference('/apex/myKanban');
        pageRef.getParameters().put( 'filter', filter );
        pageRef.setRedirect(true);
        return pageRef;  
    }
}