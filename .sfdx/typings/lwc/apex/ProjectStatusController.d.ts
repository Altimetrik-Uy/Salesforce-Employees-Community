declare module "@salesforce/apex/ProjectStatusController.getUserProjectStatus" {
  export default function getUserProjectStatus(): Promise<any>;
}
declare module "@salesforce/apex/ProjectStatusController.createProjectStatus" {
  export default function createProjectStatus(param: {project: any, subProject: any, status: any, comments: any, meetingDate: any}): Promise<any>;
}
declare module "@salesforce/apex/ProjectStatusController.getStatus" {
  export default function getStatus(): Promise<any>;
}
