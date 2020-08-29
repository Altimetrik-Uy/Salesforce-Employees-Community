/**
*   @date: 04/20/202
*   @author: Altimetrik
*   The class must contain public constant values
*   The constants must be grouped by objects through inner classes
*   Named convention: FIELD_VALUE
*   Example: CASE_STATUS_OPEN
*/

public with sharing class Constants {

    public static final ProjectConstants PROJECTS = new ProjectConstants();
    public static final ProjectStatusConstants PROJECT_STATUS = new ProjectStatusConstants();
    public static final EmployeeStatusConstants EMPLOYEE_STATUS = new EmployeeStatusConstants();
    public static final AccessLevelConstants ACCESS_LEVEL = new AccessLevelConstants();
    public static final RowCauseConstants ROW_CAUSE = new RowCauseConstants();

    public class ProjectConstants {
        public final String STAGE_PROSPECTING { get { return 'Prospecting'; } }
    }
    
    public class ProjectStatusConstants {
        public final String STATUS_GREEN { get { return 'Green'; } }
    }
    
    public class EmployeeStatusConstants {
        public final String STATUS_GREEN { get { return 'Green'; } }
        public final String CERTIFICATION_STATUS_GREEN { get { return 'Green'; } }
    }

    public class AccessLevelConstants {
        public final String READ { get { return 'Read'; } }
    }

    public class RowCauseConstants {
        public final String MANUAL { get { return 'Manual'; } }
    }
}