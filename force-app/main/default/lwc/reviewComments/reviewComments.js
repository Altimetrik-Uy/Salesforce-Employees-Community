import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class ReviewComments extends LightningElement {
    @api idReview;
    @api open;
    isSaved = false
    @api saveForm(){
        this.isSaved = true;
        this.template.querySelector('lightning-record-edit-form').submit();
    }
    handleSuccess(event){
        this.isSaved = false;
        const toast = new ShowToastEvent({
            title: 'Success',
            variant: 'success',
            message: 'Saved successfully'
        });
        this.dispatchEvent(toast);
    }
}