import { LightningElement,api,wire,track } from 'lwc';
import getPlanItems from '@salesforce/apex/LWCReviewPlanItemsController.getPlanItems';
import { refreshApex } from '@salesforce/apex';

export default class ReviewPlanItems extends LightningElement {
    @api isreviewopen;
    @api reviewId;
    @api planItems;
    responsePlanItem;
    
    @api
    getPlantItems() {
        return this.responsePlanItem;
    }

    @wire(getPlanItems,{reviewId: '$reviewId'}) wiredPlanItems(response) {
        this.responsePlanItem = response;
        if (response.data) {
            this.planItems = response.data;
        } else if(response && response.error) {
            let error = response.error;
            console.log(error);
        }
    }
    
    openReviewComments() {
        this.template.querySelector("c-plan-items-Modal").openModal();
    }
    
    refreshPlanItems(event) {
        const isSaved = event.detail;
        if (isSaved) {
            refreshApex(this.responsePlanItem);
        }
    }
}