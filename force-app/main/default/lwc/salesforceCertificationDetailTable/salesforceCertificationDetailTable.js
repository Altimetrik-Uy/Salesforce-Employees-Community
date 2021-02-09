<<<<<<< HEAD
import { LightningElement, track } from 'lwc';
=======
import { LightningElement, track, wire } from 'lwc';
import strUserId from '@salesforce/user/Id';
import getTrailBlazerId from '@salesforce/apex/LWCEmployeeOverallController.getTrailBlazerId';
>>>>>>> commit to fix salesforcepathrole
import getSalesforcePath from '@salesforce/apex/SalesforcePathByRole.getSalesforcePath'
import genericErrorMessage_lbl from '@salesforce/label/c.GenericErrorMessage_lbl';

export default class SalesforceCertificationDetailTable extends LightningElement {
<<<<<<< HEAD
    @track roles = undefined;

    // error message, when set will render the error panel
    @track errorMsg;

    connectedCallback(){
        getSalesforcePath()
        .then(response=>{
=======
    roles;
    @track userId = strUserId;
    @track trailBlazerId;
    @track spinnerOn = true;
    // error message, when set will render the error panel
    errorMsg;

    connectedCallback(){
        getSalesforcePath()
        .then(response => {
>>>>>>> commit to fix salesforcepathrole
            if(response){
                this.roles = response;
            }else{

            }
        })
<<<<<<< HEAD
        .catch(error=>{
            console.log('Error -->'+error);
            this.errorMsg = error;
=======
        .catch(error => {
            this.errorMsg = error.body.message;
>>>>>>> commit to fix salesforcepathrole
        })
    }

    get genericErrorMessage() {
<<<<<<< HEAD
        // note: you can store this in a custom label if you need
        return genericErrorMessage_lbl;
    }
=======
        return genericErrorMessage_lbl;
    }

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
>>>>>>> commit to fix salesforcepathrole
}