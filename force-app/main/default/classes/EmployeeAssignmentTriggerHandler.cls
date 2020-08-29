public with sharing class EmployeeAssignmentTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;

    public Boolean isDisabled() {
        return TriggerDisabled;
    }

    public void beforeInsert(List<SObject> newItems) {}

    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

    public void beforeDelete(Map<Id, SObject> oldItems) {}

    public void afterInsert(Map<Id, SObject> newItems) {
        EmployeeAssignments.shareOpportunities(newItems.values());
    }

    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

    public void afterDelete(Map<Id, SObject> oldItems) {
        EmployeeAssignments.revokeAccessToOpportunities(oldItems.values());
    }

    public void afterUndelete(Map<Id, SObject> oldItems) {}
}