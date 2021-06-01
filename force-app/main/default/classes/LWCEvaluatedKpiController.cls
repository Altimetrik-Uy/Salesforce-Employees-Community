public with sharing class LWCEvaluatedKpiController {
   
    @AuraEnabled(cacheable=true)
    public static List<Evaluated_Kpi__c> getEvaluatedKpi(String reviewId){
        List<Evaluated_Kpi__c> evaluatedKpiList = [
                SELECT Name, Point__c, KPI__c, Review__r.Status__c
                FROM Evaluated_Kpi__c
                WHERE Review__r.Id = :reviewId
                ];
            return evaluatedKpiList;
    }

    // @AuraEnabled(cacheable=true)
    // public static List<Evaluated_Kpi__c> setEvaluatedKpi(String reviewId, String evaluatedKpi, Integer point){
        
    // }
}
