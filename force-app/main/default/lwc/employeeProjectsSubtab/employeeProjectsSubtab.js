import {LightningElement, api, wire, track} from 'lwc';
import getEmployeeProjects from '@salesforce/apex/LWCEmployeeProjectsController.getEmployeeProjects';

export default class EmployeeProjectsSubtab extends LightningElement {
    @api employeeid;
    @track error;
    @track projectStatusImageName;
    @track projectStatusImageNameTableColumns = [ 
        { fieldName: 'ProjectName'},
        { fieldName: 'ProjectJoinDate'},
        { fieldName: 'ProjectEndDate'},
        { fieldName: 'ProjectCurrent'},
        { fieldName: 'ProjectInformation'}
    ];
    
    @wire(getEmployeeProjects,{empId: '$employeeid'}) wiredEmployeeCurrentProjects({error,data}){
        if (data) {
            this.projectStatusImageName = data;
            let preparedAssets = [];
            let id = 0;
            this.projectStatusImageName.forEach(asset => {
                let preparedAsset = {};
                preparedAsset.Id = id++;
                preparedAsset.ProjectName = asset.Project__r.Name;
                preparedAsset.ProjectJoinDate = asset.Start_Date__c;
                preparedAsset.ProjectEndDate = asset.End_Date__c;
                preparedAsset.ProjectInformation = asset.Project__r.Description;
                if(asset.Active__c == true){
                    preparedAsset.ProjectCurrent = asset.Active__c;
                }
                preparedAssets.push(preparedAsset);
            });
            this.projectStatusImageName = preparedAssets;
        } else if (error) {
            this.error = error;
        }
    }
}