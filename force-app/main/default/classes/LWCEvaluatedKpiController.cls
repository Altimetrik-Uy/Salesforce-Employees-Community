public with sharing class LWCEvaluatedKpiController {
   
    @AuraEnabled(cacheable=true)
    public static List<Evaluated_Kpi__c> getEvaluatedKpi(String reviewId){
        
        List<Evaluated_Kpi__c> evaluatedKpiList = [
                SELECT Name, Point__c, KPI__c, Review__r.Status__c, Reason__c, KPI__r.Description__c
                FROM Evaluated_Kpi__c
                WHERE Review__r.Id = :reviewId
                ];
            return evaluatedKpiList;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, List<Evaluated_Kpi__c>> getEvaluatedKpiBySection(String reviewId){
        Map<String, List<Evaluated_Kpi__c>> mapSectionKpi = new Map<String, List<Evaluated_Kpi__c>>(); 
        for (Evaluated_Kpi__c evKpi: [SELECT Name, Point__c, KPI__c, Review__r.Status__c, KPI__r.Section__c, Reason__c, KPI__r.Description__c
                                        FROM Evaluated_Kpi__c
                                        WHERE Review__r.Id = :reviewId]){
                                            if (!mapSectionKpi.containsKey(evKpi.KPI__r.Section__c)){
                                                mapSectionKpi.put(evKpi.KPI__r.Section__c, new List<Evaluated_Kpi__c>());
                                            }
                                            List<Evaluated_Kpi__c> listKPI= mapSectionKpi.get(evKpi.KPI__r.Section__c);
                                            listKPI.add(evKpi);
                                            mapSectionKpi.put(evKpi.KPI__r.Section__c, listKPI);

                }
        return mapSectionKpi;
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
                newEvaluatedKpi.Reason__c = kpi.reason;
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
