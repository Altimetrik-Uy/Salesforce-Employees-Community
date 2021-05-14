import { LightningElement, api, track, wire } from 'lwc';
import strUserId from '@salesforce/user/Id';
import getTrailBlazerId from '@salesforce/apex/LWCEmployeeOverallController.getTrailBlazerId';
import getSalesforcePath from '@salesforce/apex/SalesforcePathByRole.getSalesforcePath'
import getSalesforcePathFromSelectedRole from '@salesforce/apex/SalesforcePathByRole.getSalesforcePathFromSelectedRole'
import genericErrorMessage_lbl from '@salesforce/label/c.GenericErrorMessage_lbl';
export default class SalesforceCertificationDetailTable extends LightningElement {
    roles;
    @api selectedrole;
    @track userId = strUserId;
    @track trailBlazerId;
    @track spinnerOn = true;
    trailBlazerIdOrSelectedRole;
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

    get trailBlazerIdOrSelectedRole(){
        if(this.trailBlazerId != null || this.selectedrole != null){
            return true;
        }
        return false;
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

    @wire(getSalesforcePathFromSelectedRole,{selectedRole: '$selectedrole'}) 
    getSalesforcePathFromSelectedRole({error,data}) {
        console.log('wire getSalesforcePath: '+this.selectedrole);
        if(data){
            console.log('wire getSalesforcePath: data');
            this.roles = data;
            console.log(this.roles);
            this.toggleSpinner(false);
        }else if(error) {
            console.log('wire getSalesforcePath: error');
            this.errorMsg = error.body.message;
            this.toggleSpinner(false);
        }else {
            console.log('wire getSalesforcePath: else');
        }
    }
}