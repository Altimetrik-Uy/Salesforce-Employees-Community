/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Feedback VfPage-Site Controller 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Schubert Tonarelli   <stonarelli@altimetrik.com>
* @created        2020-05-15
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class FeedbackController {

    public String errorMessage { get; set; }
    public String errorType { get; set; }

    public String tmpId { get; set; } // Template Id
    public String empId { get; set; } // Employee Id
    public String proyId { get; set; } // Project Id
    
    public Contact employee { get; set; }
    public Survey_Template__c template { get; set; }
    
    class questionAnswers {
		public String questionText { get; set; }
		public String questionType { get; set; }
        public Survey_Answer__c answerObj { get; set; } 
    }
    
    public List<questionAnswers> itemList { get; set; }

    public PageReference init(){
        
        this.tmpId = Apexpages.currentpage().getparameters().get('tmpId'); 
        this.empId = Apexpages.currentpage().getParameters().get('empId'); 
        this.proyId = Apexpages.currentpage().getParameters().get('proyId'); 
        
        if( String.isEmpty( this.tmpId ) ){ 
            errorMessage = 'El template Id es vacío.';
            errorType = 'error';
            return null;
        }
        
        try{
        	employee = [SELECT Id, Name, Image__c FROM Contact WHERE Id =:this.empId LIMIT 1];
        }catch(Exception e){ 
            errorMessage = 'El employee no existe.';
            errorType = 'error';
            return null;            
        }
        
        if( String.isEmpty( this.empId ) ){  
            errorMessage = 'El employee Id es vacío.';
            errorType = 'error';
            return null;
        }
                
        try{
            template = [SELECT Id, Name, Description__c FROM Survey_Template__c WHERE Id =:this.tmpId LIMIT 1];
        }catch(Exception e){ 
            errorMessage = 'El template no existe.';
            errorType = 'error';
            return null;            
        }
        
        if( String.isEmpty( this.proyId ) ){  
            errorMessage = 'El project Id es vacío.';
            errorType = 'error';
            return null;
        }
            
        itemList = getItemList( this.empId, this.tmpId, this.proyId );
        
        if( itemList.isEmpty() ){
            errorMessage = 'Todas las preguntas han sido contestadas. Gracias por su aporte!';
            errorType = 'success';   
        }
        
        return null;
    }
    
    public List<questionAnswers> getItemList( String employeeId, String templateId, String projectId ){
        
        itemList = new List<questionAnswers>();
        
        Map<String, Survey_Answer__c> savedAnswersMap = new Map<String, Survey_Answer__c>();
        
        for( Survey_Answer__c a : [SELECT Id, Survey_Question__c, Answer__c FROM Survey_Answer__c 
                                   WHERE Survey_Template__c = :templateId AND Employee__c = :employeeId AND Project__c = :projectId ] ){
            savedAnswersMap.put( a.Survey_Question__c, a );
        }
        
        for( Survey_Question__c a : [SELECT Id, Question_Text__c, Question_Type__c, Survey_Template__c 
                                     FROM Survey_Question__c WHERE Survey_Template__c = :templateId ] ){
            
            if( !savedAnswersMap.containsKey(a.Id) ){
                
                questionAnswers aux = new questionAnswers();
                aux.questionText = a.Question_Text__c;
                aux.questionType = a.Question_Type__c;
                
                aux.answerObj = new Survey_Answer__c(
                    Answer__c = '',
                    Employee__c = employeeId,
                    Project__c = projectId,
                    Survey_Template__c = a.Survey_Template__c,
                    Survey_Question__c = a.Id
                );
                itemList.add(aux);
            }
        }
        return itemList;
    }
    
    public PageReference saveAll(){
        
        Integer itemListSize = itemList.size();
        
        if( itemListSize > 0 ){
            
            List<Survey_Answer__c> saveAnswers = new List<Survey_Answer__c>();
            for( questionAnswers a : itemList ){
                if( a.answerObj.Answer__c != '' ){
                    saveAnswers.add( a.answerObj );
                }
            }
            if( !saveAnswers.isEmpty() ){
                
                upsert saveAnswers;
                
                errorMessage = 'Las preguntas han sido guardadas.';
                errorType = 'info';   
            }
            
        	itemList = getItemList( this.empId, this.tmpId, this.proyId );
 
            if( itemList.isEmpty() ){
                errorMessage = 'Todas las preguntas han sido contestadas. Gracias por su aporte!';
                errorType = 'success';   
            }   
        }
        return null;
    }
}