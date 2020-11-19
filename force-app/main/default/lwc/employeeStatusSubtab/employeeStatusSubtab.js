import {LightningElement, api, wire, track} from 'lwc';
import getEmployeeProjects from '@salesforce/apex/LWCEmployeeStatusController.getEmployeeProjects';
import getEmployeeStatuses from '@salesforce/apex/LWCEmployeeStatusController.getEmployeeStatuses';
import { refreshApex } from '@salesforce/apex';
let i = 0;

export default class EmployeeStatusSubtab extends LightningElement {
    @api employeeid;
    @track error; 
    @track projectItem = [];
    @track comboBoxValue = '';

    @wire(getEmployeeProjects,{empId: '$employeeid'}) wiredProjects({error,data}){
        if(data){
            for(i=0; i<data.length; i++) {
                this.projectItem = [...this.projectItem ,{value: data[i].Project__r.Id , label: data[i].Project__r.Name}];   
            }
            this.error = undefined;
        }else if (error){
            this.error = error;
            this.projectItem = undefined;
        }
    }
   
    get projectOptions() {
        console.log(this.projectItem);
        return this.projectItem;
    }
   
    handleChange(event) {
        this.comboBoxValue = event.detail.value;
        console.log('data =  ' + this.comboBoxValue);
        //here we "call" getEmployeeStatuses
        refreshApex(this.projectStatuses);
    }

    @track projectStatuses;
    @track projectStatusesTableColumns = [ 
        { fieldName: 'Status'},
        { fieldName: 'StatusDate'},
        { fieldName: 'StatusComments'},
        { fieldName: 'ManagerName'},
        { fieldName: 'ProjectName'}
        ];

    @wire(getEmployeeStatuses,{projId: '$comboBoxValue'}) getEmployeeStatuses({error,data}){
        if (data) {
            this.projectStatuses = data;
            let preparedAssets = [];
            let id = 0;
            this.projectStatuses.forEach(asset => {
                let preparedAsset = {};
                preparedAsset.Id = id++;
                preparedAsset.Status = asset.Status__c;
                preparedAsset.StatusDate = asset.Meeting_Date__c;
                preparedAsset.StatusComments = asset.Comments__c;
                preparedAsset.ManagerName = asset.CreatedBy.Name;
                preparedAsset.ProjectName = asset.Project__r.Name;
                preparedAssets.push(preparedAsset);
            });
            this.projectStatuses = preparedAssets;
        } else if (error) {
            this.error = error;
        }
    }

}