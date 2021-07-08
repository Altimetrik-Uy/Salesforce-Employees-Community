public with sharing class LWCEvaluatedKpiController {
   
    @AuraEnabled(cacheable=true)
    public static List<Evaluated_Kpi__c> getEvaluatedKpi(String reviewId){
        
        List<Evaluated_Kpi__c> evaluatedKpiList = [
                SELECT Name, Point__c, KPI__c, Review__r.Status__c, Reason__c
                FROM Evaluated_Kpi__c
                WHERE Review__r.Id = :reviewId
                ];
            return evaluatedKpiList;
    } 
        
    @AuraEnabled
    public static void setEvaluatedKpi(String evaluatedKpis){
        
        List<Evaluated_Kpi__c> evaluatedKpisToSet = new List<Evaluated_Kpi__c>();
        List<List<EvaluatedKpisWrapper>> evaluatedKpiWrapper = parse(evaluatedKpis);
        
        for( List<EvaluatedKpisWrapper> kpisList: evaluatedKpiWrapper ){
            for( EvaluatedKpisWrapper kpi: kpisList ){
                Evaluated_Kpi__c newEvaluatedKpi = new Evaluated_Kpi__c();
                newEvaluatedKpi.Id = kpi.kpiId;
                newEvaluatedKpi.Point__c = decimal.valueOf(kpi.point);
                evaluatedKpisToSet.add(newEvaluatedKpi);
            }
        }
        update evaluatedKpisToSet;
    }

    private class EvaluatedKpisWrapper {
        public String kpiId;
        public String point;
        public String reason;

    }

    public static List<List<EvaluatedKpisWrapper>> parse(String json) {
        return (List<List<EvaluatedKpisWrapper>>) System.JSON.deserialize(json, List<List<EvaluatedKpisWrapper>>.class);
    }
}
