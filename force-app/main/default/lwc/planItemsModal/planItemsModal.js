import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
export default class PlanItemsModal extends LightningElement {
    @api isOpenReview = false;
    @api isModalOpen = false;
    @api idReview;
    isSaved = false;
    @api planItemId;
    @api planItemName;
    
    
    @api openModal() {
        this.isSaved = false;
        this.isModalOpen = true;
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;    
    }

    submitDetails() {
        this.isSaved = true;
        this.template.querySelector('lightning-record-edit-form').submit();
    }
    
    handleSuccess(event){
        this.isSaved = true;
       
        const planItemSaved = new CustomEvent("valuechange", {
            detail: this.isSaved
        });
        this.dispatchEvent(planItemSaved); 
       
        this.isModalOpen = false;
        const toast = new ShowToastEvent({
            title: 'Success',
            variant: 'success',
            message: 'Saved successfully'
        });
        this.dispatchEvent(toast);      
    }

   
}