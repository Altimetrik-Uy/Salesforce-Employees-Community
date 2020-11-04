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
                preparedAsset.ProjectJoinDate = asset.CreatedDate;
                preparedAsset.ProjectEndDate = asset.Project__r.End_Date__c;
                preparedAsset.ProjectInformation = 'Comming Soon (will be in the second phase)';
                preparedAssets.push(preparedAsset);
            });
            this.projectStatusImageName = preparedAssets;
            window.console.log(JSON.stringify(this.assets));
        } else if (error) {
            this.error = error;
        }
    }
}