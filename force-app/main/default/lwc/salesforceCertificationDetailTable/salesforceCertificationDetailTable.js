import { LightningElement, track, wire } from 'lwc';
import strUserId from '@salesforce/user/Id';
import getTrailBlazerId from '@salesforce/apex/LWCEmployeeOverallController.getTrailBlazerId';
import getSalesforcePath from '@salesforce/apex/SalesforcePathByRole.getSalesforcePath'
import genericErrorMessage_lbl from '@salesforce/label/c.GenericErrorMessage_lbl';

export default class SalesforceCertificationDetailTable extends LightningElement {
    roles;
    @track userId = strUserId;
    @track trailBlazerId;
    @track spinnerOn = true;
    // error message, when set will render the error panel
    errorMsg;

    connectedCallback(){
        getSalesforcePath()
        .then(response => {
            if(response){
                this.roles = response;
            }else{

            }
        })
        .catch(error => {
            this.errorMsg = error.body.message;
        })
    }

    get genericErrorMessage() {
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
}