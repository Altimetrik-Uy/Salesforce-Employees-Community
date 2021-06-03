import { LightningElement,api,wire,track } from 'lwc';
import getPlanItems from '@salesforce/apex/LWCReviewPlanItemsController.getPlanItems';

export default class ReviewPlanItems extends LightningElement {
    @api isreviewopen;
    @api reviewId;
    @track planItems;
    
    @wire(getPlanItems,{reviewId: '$reviewId'}) wiredPlanItems({error,data}){
        if(data){
            this.planItems = data;
        }else if (error){
            this.error = error;
        }
    }
    
}