import {LightningElement, api, wire, track} from 'lwc';
import getEmployeeProjects from '@salesforce/apex/LWCEmployeeStatusController.getEmployeeProjects';
import getEmployeeStatuses from '@salesforce/apex/LWCEmployeeStatusController.getEmployeeStatuses';
import sendMessage from '@salesforce/apex/LWCEmployeeStatusController.sendMessage';
import getManager from '@salesforce/apex/LWCEmployeeStatusController.getManager';
import getUser from '@salesforce/apex/LWCEmployeeStatusController.getUser';
import getProjectActiveStauts from '@salesforce/apex/LWCEmployeeStatusController.getProjectActiveStauts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { refreshApex } from '@salesforce/apex';
let i = 0;

export default class EmployeeStatusSubtab extends LightningElement {
    @api employeeid;
    @track error; 
    @track projectItem = [];
    @track comboBoxValue = '';
    @track managerId = '';
    @track userName = '';

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
        return this.projectItem;
    }
   
    handleChange(event) {
        this.comboBoxValue = event.detail.value;
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

    @wire(getManager,{projId: '$comboBoxValue'}) getManager({error,data}){
        if(data){
            this.managerId = data;
        }else if (error){
            this.error = error;
        }
    }

    @wire(getUser,{empId: '$employeeid'}) getUser({error,data}){
        if(data){
            this.userName = data;
        }else if (error){
            this.error = error;
        }
    }
    
    @wire(getProjectActiveStauts,{empId:'$employeeid', projId:'$comboBoxValue'}) isActive;
    onClickSendMessage(){
        sendMessage({managerId:this.managerId, userName: this.userName})
        .then (s=>{
            if(s){
                const event = new ShowToastEvent({
                    title: 'Success!',
                    message: 'Message has been sended.',
                    variant: 'success',
                });
                this.dispatchEvent(event);
            }else{
                const event = new ShowToastEvent({
                    title: 'Fail!',
                    message: 'Message has not been sended.',
                    variant: 'error',
                });
                this.dispatchEvent(event);
            }
        })
    }
}