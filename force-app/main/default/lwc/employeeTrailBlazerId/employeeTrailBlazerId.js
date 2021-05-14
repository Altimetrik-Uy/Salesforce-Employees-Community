import {LightningElement, api, wire, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import strUserId from '@salesforce/user/Id';
import getTrailBlazerId from '@salesforce/apex/LWCEmployeeOverallController.getTrailBlazerId';
import insertTrailBlazerId from '@salesforce/apex/LWCEmployeeOverallController.insertTrailBlazerId';

export default class EmployeeTrailBlazerId extends LightningElement {
    @api employeeid;
    @track userId = strUserId;
    newTrailId;
    @track trailBlazerId;
    @track spinnerOn = true;

    toggleSpinner(status) {
        this.spinnerOn = status;
    }

    @wire(getTrailBlazerId, {uId: '$userId'})
    wiredTrailblazer({ error, data }) {
        if (data) {
            this.trailBlazerId = data;
            this.toggleSpinner(false);
        } else if (error) {
            this.trailBlazerId = undefined;
        }else {
            if (data !== undefined)
                this.toggleSpinner(false);
        }
    }

    insertTrailIdClick(){
        this.newTrailId = this.template.querySelector("lightning-input[data-id=idInput]").value;
        if(this.newTrailId){
            if(!this.trailBlazerId){
                insertTrailBlazerId({ uId: this.userId, newTrailBlazerId: this.newTrailId })
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Trailblazer Id  was updated. Data will be updated in 40 minutes aprox.',
                            variant: 'success'
                        })
                    );
                    this.trailBlazerId = this.newTrailId;
                    setTimeout(function() {
                        window.location.reload();
                    }, 1500);
                }).catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating the Trailblaizer Id.',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
            }
        } else {
            this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Warning',
                        message: 'Trailblazer Id cannot be empty.',
                        variant: 'warning'
                    })
                );
        }
    }
}