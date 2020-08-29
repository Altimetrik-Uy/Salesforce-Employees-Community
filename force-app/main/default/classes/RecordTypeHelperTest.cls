/**
 * @date 04/20/2020
 * @author Altimetrik
 * Test class for RecordTypeHelper 
 */
@isTest
public class RecordTypeHelperTest {

    @isTest
    static void testRecordTypeIdProject() {
        String objectName = Opportunity.class.getName();
        System.assertEquals(
            getRecordTypeId('Billable', objectName),
            RecordTypeHelper.PROJECTS.BILLABLE
        );
        System.assertEquals(
            getRecordTypeId('Internal', objectName),
            RecordTypeHelper.PROJECTS.INTERNAL
        );
    }

    private static Id getRecordTypeId(String developerName, String objectName) {
        return [
            SELECT Id 
            FROM RecordType 
            WHERE developerName = :developerName 
            AND sobjectType = :objectName 
            LIMIT 1
        ].Id;
    }
}