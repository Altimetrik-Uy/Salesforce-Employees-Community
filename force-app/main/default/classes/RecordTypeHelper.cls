/**
 * @date 04/20/2020
 * @author Altimetrik
 * Helper to unify the way record types ID are retrived. 
 */
public class RecordTypeHelper {
    public static final ProjectRecordType Projects = new ProjectRecordType();

    public abstract class ObjectRecordType {
        public Id getRecordTypeId(String recordTypeDeveloperName) {
            // https://salesforce.stackexchange.com/questions/218982/why-is-schema-describesobjectstypes-slower-than-schema-getglobaldescribe
            Type objectType = getObjectType();
            SObject mySObject = (SObject) objectType.newInstance();
            Schema.RecordTypeInfo myRecordtypeInfo = mySObject.getSObjectType()
                    .getDescribe()
                    .getRecordTypeInfosByDeveloperName()
                    .get(recordTypeDeveloperName);
            if (myRecordtypeInfo != null) {
                return myRecordtypeInfo.getRecordTypeId();
            } else {
                throw new InvalidRecordTypeDeveloperNameException();
            }
        }

        public abstract Type getObjectType();
    }

    public class InvalidRecordTypeDeveloperNameException extends Exception {}

    public class ProjectRecordType extends ObjectRecordType {
        public final Id BILLABLE { get { return getRecordTypeId('Billable'); } }
        public final Id INTERNAL { get { return getRecordTypeId('Internal'); } }

        public override Type getObjectType() {
            return Opportunity.class;
        }
    }
}