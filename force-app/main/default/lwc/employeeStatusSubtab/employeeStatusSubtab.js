import {LightningElement, api, wire, track} from 'lwc';
import getEmployeeProjects from '@salesforce/apex/LWCEmployeeStatusController.getEmployeeProjects';
import getEmployeeStatuses from '@salesforce/apex/LWCEmployeeStatusController.getEmployeeStatuses';
import sendMessage from '@salesforce/apex/LWCEmployeeStatusController.sendMessage';
import getManager from '@salesforce/apex/LWCEmployeeStatusController.getManager';
import getUser from '@salesforce/apex/LWCEmployeeStatusController.getUser';
import getEmployeeStatusCount from '@salesforce/apex/LWCEmployeeStatusController.getEmployeeStatusCount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
let i = 0;

export default class EmployeeStatusSubtab extends LightningElement {
    @api employeeid;
    @track error; 
    @track projectItem = [];
    @track comboBoxValue = '';
    @track lstManagerId = [];
    @track userName = '';
    @track allSelected = false;
    @track projectStatuses=[];
    @track paginationRange = [];
    @track totalRecords;

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
   
    @wire(getEmployeeStatuses,{ empId: '$employeeid'}) getEmployeeStatuses({error,data}){
        try{
            if(this.employeeid != '' ){
                getEmployeeStatusCount({empId: this.employeeid}).then(projectCount =>{ 
                    if(projectCount){
                    this.projectStatuses = [];
                    this.totalRecords = projectCount;
                        let i = 1;
                        if (data) {
                            this.projectStatuses = data;
                            let preparedAssets = [];
                            let id = 0;
                            this.projectStatuses.forEach(asset => {
                                let preparedAsset = {};
                                preparedAsset.Id = id++;
                                preparedAsset.Status = asset.Status__c;
                                preparedAsset.StatusDate = asset.CreatedDate;
                                preparedAsset.StatusComments = asset.Comments__c;
                                preparedAsset.ManagerName = asset.CreatedBy.Name;
                                preparedAssets.push(preparedAsset);
                            });
                            this.projectStatuses = preparedAssets;
                        } else if (error) {
                            this.error = error;
                        }
                        //looking at displaying 4 recrods per page
                        const paginationNumbers = Math.ceil(this.totalRecords / 4);
                        //create an array with size equals to paginationNumbers
                        this.paginationRange = [];
                        while (
                            this.paginationRange.push(i++) < paginationNumbers
                            // eslint-disable-next-line no-empty
                        ) {}
                    }else{
                        this.projectStatuses = [];
                        this.paginationRange = [];
                    }
                });
            }
        }catch(error){
            console.log(error);
        }
    } 

    @wire(getManager,{empId: '$employeeid'}) getManager({error,data}){
        if(data){
            this.lstManagerId = data;
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
    
    onClickSendMessage(){
        sendMessage({lstManagersId:this.lstManagerId, userName:this.userName})
        .then (s=>{
            if(s){
                const event = new ShowToastEvent({
                    title: 'Success!',
                    message: 'Manager has been notified.',
                    variant: 'success',
                });
                this.dispatchEvent(event);
            }else{
                const event = new ShowToastEvent({
                    title: 'Fail!',
                    message: 'No active project assignment or manager assigned. Contact your administrator for more details',
                    variant: 'error',
                });
                this.dispatchEvent(event);
            }
        })
    }

    handlePaginationClick(event) {
        let offsetNumber = event.target.dataset.targetNumber;
        //reduce 1 from the clciked number and multiply it with 4, 
        //since we are showing 4 records per page and pass the offset to apex class 
        getEmployeeStatuses({empId: this.employeeid, offsetRange: 4 * (offsetNumber - 1) })
            .then(data => {
                if (data) {
                    this.projectStatuses = data;
                    let preparedAssets = [];
                    let id = 0;
                    this.projectStatuses.forEach(asset => {
                        let preparedAsset = {};
                        preparedAsset.Id = id++;
                        preparedAsset.Status = asset.Status__c;
                        preparedAsset.StatusDate = asset.CreatedDate;
                        preparedAsset.StatusComments = asset.Comments__c;
                        preparedAsset.ManagerName = asset.CreatedBy.Name;
                        preparedAssets.push(preparedAsset);
                    });
                    this.projectStatuses = preparedAssets;
                } else if (error) {
                    this.error = error;
                }
            })
            .catch(error => {
                // eslint-disable-next-line no-console
                console.log(error);
            });
    } 
}