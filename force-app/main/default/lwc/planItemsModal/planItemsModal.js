import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
export default class PlanItemsModal extends LightningElement {
    @api isOpenReview = false;
    @api isModalOpen = false;
    @api idReview;
    isSaved = false
    recordId;
    
    
    @api openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;    }
    submitDetails() {
        this.isSaved = true;
        this.template.querySelector('lightning-record-edit-form').submit();
    }
    
    handleSuccess(event){
        this.isSaved = true;
        this.isModalOpen = false;
        const toast = new ShowToastEvent({
            title: 'Success',
            variant: 'success',
            message: 'Saved successfully'
        });
        this.dispatchEvent(toast);
    }

   
}