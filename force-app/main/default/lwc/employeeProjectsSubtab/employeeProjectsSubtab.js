import { LightningElement, track, api, wire} from 'lwc';

import getEmployeeProjects from '@salesforce/apex/LWCEmployeeProjectsController.getEmployeeProjects';
import getEmployeeProjectsCount from '@salesforce/apex/LWCEmployeeProjectsController.getEmployeeProjectsCount';

export default class EmployeeProjectsSubtab extends LightningElement {
    @api employeeid;
    @track paginationRange = [];
    @track totalRecords;
    @track error;
    @track projectTable;

    handlePaginationClick(event) {
        let offsetNumber = event.target.dataset.targetNumber;

        //reduce 1 from the clciked number and multiply it with 4, 
        //since we are showing 4 records per page and pass the offset to apex class 
        getEmployeeProjects({empId: this.employeeid, offsetRange: 4 * (offsetNumber - 1) })
            .then(data => {
                if (data) {
                    this.projectTable = data;
                    let preparedAssets = [];
                    let id = 0;
                    this.projectTable.forEach(asset => {
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
                    this.projectTable = preparedAssets;
                } else if (error) {
                    this.error = error;
                } 
            })
            .catch(error => {
                // eslint-disable-next-line no-console
                console.log(error);
            });
    } 

    @wire(getEmployeeProjects,{empId: '$employeeid'}) wiredEmployeeCurrentProjects({error,data}){
        try{
            if(this.employeeid != ''){
                getEmployeeProjectsCount({empId: this.employeeid}).then(projectCount =>{ 
                    if(projectCount){
                        this.totalRecords = projectCount;
                        let i = 1;
                        if (data) {
                            this.projectTable = data;
                            let preparedAssets = [];
                            let id = 0;
                            this.projectTable.forEach(asset => {
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
                            this.projectTable = preparedAssets;
                        } else if (error) {
                            this.error = error;
                        }
                        //looking at displaying 4 recrods per page
                        const paginationNumbers = Math.ceil(this.totalRecords / 4);
                        //create an array with size equals to paginationNumbers
                        //this.paginationRange = [];
                        while (
                            this.paginationRange.push(i++) < paginationNumbers
                            // eslint-disable-next-line no-empty
                        ) {}
                    }
                });
            }
        }catch(error){
            console.error();
        }
    }
} 
