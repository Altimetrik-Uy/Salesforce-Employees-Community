declare module "@salesforce/apex/EmployeeStatusController.getUserEmployeeStatus" {
  export default function getUserEmployeeStatus(): Promise<any>;
}
declare module "@salesforce/apex/EmployeeStatusController.createEmployeeStatus" {
  export default function createEmployeeStatus(param: {employee: any, status: any, comments: any, redReason: any, certStatus: any, certComments: any}): Promise<any>;
}
declare module "@salesforce/apex/EmployeeStatusController.getStatus" {
  export default function getStatus(): Promise<any>;
}
declare module "@salesforce/apex/EmployeeStatusController.getCertificationStatus" {
  export default function getCertificationStatus(): Promise<any>;
}
