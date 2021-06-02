import { api,wire, LightningElement } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import STATUS_FIELD from '@salesforce/schema/Review__c.Status__c';
import getEmployeeReviewItem from '@salesforce/apex/LWCPerformanceEvaluationController.getEmployeeReviewItem';

export default class PerformanceEvaluationWrapper extends LightningElement {
    @api recordId;
    @api filterStatus;
    @wire(getRecord, { recordId:'$recordId', fields: [STATUS_FIELD], optionalFields: [] })
    review;

    get reviewOpen() {    
        let status;
        getEmployeeReviewItem({ reviewId: this.recordId, filterStatus : this.filterStatus })
        .then((result) => {
            this.review =  result;
                        console.log('review '+ this.review.Status__c);
                        console.log('review '+ this.review.Comments__c);
                        status = this.review.Status__c;
        })
        .catch((error) => {           
            console.log('error '+ error.name);
        });
        
        return status == 'Open' || status == 'In Progress';         
    }

    handleClick() {
        this.dispatchEvent(new CustomEvent('back'));
    }
}