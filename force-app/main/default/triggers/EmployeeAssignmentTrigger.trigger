trigger EmployeeAssignmentTrigger on Employee_Assignment__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new EmployeeAssignmentTriggerHandler());
}