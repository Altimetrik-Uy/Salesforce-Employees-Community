/**
 * @date 06/16/2020
 * @author Altimetrik
 *
 * Domain class for Employee_Assignment__c
 */
public with sharing class EmployeeAssignments {
    public static void shareOpportunities(List<Employee_Assignment__c> assignments) {
        Map<Id, Id> portalUsersByEmployeeId = getPortalUsersFromContacts(assignments);
        List<OpportunityShare> shareRecords = new List<OpportunityShare>();

        for (Employee_Assignment__c assignment : assignments) {
            if (portalUsersByEmployeeId.containsKey(assignment.Employee__c)) {
                OpportunityShare optyShare = new OpportunityShare();
                optyShare.OpportunityId = assignment.Project__c;
                optyShare.UserOrGroupId = portalUsersByEmployeeId.get(assignment.Employee__c);
                optyShare.OpportunityAccessLevel = Constants.ACCESS_LEVEL.READ;

                shareRecords.add(optyShare);
            }
        }

        Database.SaveResult[] results = Database.insert(shareRecords, false);

        Integer i = 0;
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                // Get the first save result error
                Database.Error err = result.getErrors()[0];

                // Check if the error is related to a trivial access level
                // Access levels equal or more permissive than the object's default
                // access level are not allowed.
                // These sharing records are not required and thus an insert exception is
                // acceptable.
                if (
                    !(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&
                    err.getMessage().contains('AccessLevel'))
                ) {
                    // Throw an error when the error is not related to trivial access level.
                    assignments
                        .get(i)
                        .addError('Unable to grant sharing access due to following exception: ' + err.getMessage());
                }
            }
            i++;
        }
    }

    public static void revokeAccessToOpportunities(List<Employee_Assignment__c> assignments) {
        Map<Id, Id> portalUsersByEmployeeId = getPortalUsersFromContacts(assignments);
        Map<Id, Set<Id>> usersByOptyId = new Map<Id, Set<Id>>();
        Set<Id> userIds = new Set<Id>();

        for (Employee_Assignment__c assignment : assignments) {
            if (usersByOptyId.containsKey(assignment.Project__c)) {
                if (portalUsersByEmployeeId.containsKey(assignment.Employee__c)) {
                    usersByOptyId.get(assignment.Project__c).add(portalUsersByEmployeeId.get(assignment.Employee__c));
                    userIds.add(portalUsersByEmployeeId.get(assignment.Employee__c));
                }
            } else {
                usersByOptyId.put(assignment.Project__c, new Set<Id>());
                if (portalUsersByEmployeeId.containsKey(assignment.Employee__c)) {
                    usersByOptyId.get(assignment.Project__c).add(portalUsersByEmployeeId.get(assignment.Employee__c));
                    userIds.add(portalUsersByEmployeeId.get(assignment.Employee__c));
                }
            }
        }

        List<OpportunityShare> recordsToDelete = new List<OpportunityShare>();
        List<OpportunityShare> shareRecords = getOpportunityShareByUserId(userIds);

        for (OpportunityShare shareRecord : shareRecords) {
            if (usersByOptyId.containsKey(shareRecord.OpportunityId)) {
                if (userIds.contains(shareRecord.UserOrGroupId)) {
                    recordsToDelete.add(shareRecord);
                }
            }
        }

        delete recordsToDelete;
    }

    private static Map<Id, Id> getPortalUsersFromContacts(List<Employee_Assignment__c> assignments) {
        Set<Id> employeeIds = new Set<Id>();

        for (Employee_Assignment__c assignment : assignments) {
            employeeIds.add(assignment.Employee__c);
        }

        List<User> portalUsers = getUsersByContactId(employeeIds);

        Map<Id, Id> portalUsersByEmployeeId = new Map<Id, Id>();

        for (User portalUser : portalUsers) {
            portalUsersByEmployeeId.put(portalUser.ContactId, portalUser.Id);
        }

        return portalUsersByEmployeeId;
    }

    private static List<User> getUsersByContactId(Set<Id> employeeIds) {
        return [SELECT Id, ContactId FROM User WHERE ContactId IN :employeeIds];
    }

    private static List<OpportunityShare> getOpportunityShareByUserId(Set<Id> userIds) {
        return [
            SELECT Id, OpportunityId, UserOrGroupId
            FROM OpportunityShare
            WHERE UserOrGroupId IN :userIds AND RowCause = :Constants.ROW_CAUSE.MANUAL
        ];
    }
}