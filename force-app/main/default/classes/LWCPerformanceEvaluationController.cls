
public without sharing class LWCPerformanceEvaluationController {



        @AuraEnabled(cacheable=true)
    public static List<SObject> getEmployeeReview(String empId,string filterStatus, Integer offsetRange){
        set<String> statusFilter = new set<String>();
        if (filterStatus == 'Reviews about me'){
            statusFilter.add('Approved');
            if(offsetRange == null){
                return [SELECT Id, Review__r.Status__c, Review__r.CreatedDate, Review__r.Comments__c, Review__r.CreatedBy.Name,Review__r.Evaluated__r.name, Review__c, Evaluator__r.name FROM Review_Assignment__c WHERE Review__r.Evaluated__c =: empId AND Review__r.Status__c IN : statusFilter ORDER BY CreatedDate DESC LIMIT 4];
            }else {
                return [SELECT Id, Review__r.Status__c, Review__r.CreatedDate, Review__r.Comments__c, Review__r.CreatedBy.Name,Review__r.Evaluated__r.name, Review__c, Evaluator__r.name FROM Review_Assignment__c WHERE Review__r.Evaluated__c =: empId AND Review__r.Status__c IN : statusFilter ORDER BY CreatedDate DESC LIMIT 4 OFFSET :offsetRange];

            }

        }
         else if (filterStatus == 'Reviews done') {
            statusFilter.add('Submitted');
            statusFilter.add('Approved');
            if(offsetRange == null){
                return [SELECT Id, Review__c, Review__r.Status__c, Review__r.CreatedDate, Review__r.Comments__c, Review__r.CreatedBy.Name,Review__r.Evaluated__r.name FROM Review_Assignment__c WHERE Evaluator__c =: empId AND (Review__r.Status__c IN : statusFilter OR Submitted_by_Evaluator__c = TRUE) ORDER BY CreatedDate DESC LIMIT 4];
            }else {
                return [SELECT Id, Review__c, Review__r.Status__c, Review__r.CreatedDate, Review__r.Comments__c, Review__r.CreatedBy.Name,Review__r.Evaluated__r.name FROM Review_Assignment__c WHERE Evaluator__c =: empId AND (Review__r.Status__c IN : statusFilter OR Submitted_by_Evaluator__c = TRUE) ORDER BY CreatedDate DESC LIMIT 4 OFFSET :offsetRange];
            }
            
        }else if (filterStatus == 'Reviews to do') {
            statusFilter.add('Open');
            statusFilter.add('In Progress');
            
            if(offsetRange == null){
                return [SELECT Id, Review__c,Review__r.Status__c, Review__r.CreatedDate, Review__r.Comments__c, Review__r.CreatedBy.Name,Review__r.Evaluated__r.name FROM Review_Assignment__c WHERE Evaluator__c =:empId AND Review__r.Status__c IN : statusFilter ORDER BY CreatedDate DESC LIMIT 4];
            }else {
                return [SELECT Id, Review__c,Review__r.Status__c, Review__r.CreatedDate, Review__r.Comments__c, Review__r.CreatedBy.Name,Review__r.Evaluated__r.name FROM Review_Assignment__c WHERE Evaluator__c =:empId AND Review__r.Status__c IN : statusFilter ORDER BY CreatedDate DESC LIMIT 4  OFFSET :offsetRange];
            }
        }else {
            return null;
        }
    }
   
    @AuraEnabled(cacheable=true)
    public static Integer getEmployeeReviewCount(String empId,string filterStatus){
        system.debug('empId '+empId);
        system.debug('count review'+[SELECT COUNT() FROM Review__c WHERE Evaluated__c = :empId]);
        set<String> statusFilter = new set<String>();
        
        if (filterStatus == 'Reviews about me'){
            statusFilter.add('Approved');
            return [SELECT COUNT() FROM Review__c WHERE Evaluated__c =:empId AND Status__c IN : statusFilter];

        }
         else if (filterStatus == 'Reviews done') {
            statusFilter.add('Submitted');
            statusFilter.add('Approved');

            return [SELECT COUNT() FROM Review_Assignment__c WHERE Evaluator__c =: empId AND Review__r.Status__c IN : statusFilter];
            
        }else if (filterStatus == 'Reviews to do') {
            statusFilter.add('Open');
            statusFilter.add('In Progress');
            
            return [SELECT COUNT() FROM Review_Assignment__c WHERE Evaluator__c =:empId AND Review__r.Status__c IN : statusFilter];
        }else {
            return null;
        }
    }

    @AuraEnabled(Cacheable=false)
    public static boolean updateSubmittedByEvaluator(String reviewAssignmentId){
        try{
            Review_assignment__c reviewAssignment = [Select Id, Submitted_By_Evaluator__c from Review_assignment__c WHERE Id =: reviewAssignmentId];
            reviewAssignment.Submitted_By_Evaluator__c = true;
            update reviewAssignment;
            return true;        
        } catch (Exception e) {
            return false;
        }
    }
}