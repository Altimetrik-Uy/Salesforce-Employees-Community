import { api,wire, LightningElement } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import STATUS_FIELD from '@salesforce/schema/Review__c.Status__c';

export default class PerformanceEvaluationWrapper extends LightningElement {
    @api 
    recordId;
    @wire(getRecord, { recordId:'$recordId', fields: [STATUS_FIELD], optionalFields: [] })
    review;
    get reviewOpen() {
        let status = getFieldValue(this.review.data, STATUS_FIELD);
        return status == 'Open' || status == 'In Progress';         
    }

    handleClick() {
        this.dispatchEvent(new CustomEvent('back'));
    }
    
    saveComments(){
        this.template.querySelector("c-review-comments").saveForm();
    }
}