import { api, wire, track, LightningElement } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import assets from '@salesforce/resourceUrl/assets';

import STATUS_FIELD from '@salesforce/schema/Review__c.Status__c';
import EVALUATED_FIELD from '@salesforce/schema/Review__c.Evaluated__r.Name';
import ID_FIELD from '@salesforce/schema/Review__c.Evaluated__c';
import IMAGE_FIELD from '@salesforce/schema/Review__c.Evaluated__r.Image__c';
import EVALUATOR_FIELD from '@salesforce/schema/Review_Assignment__c.Evaluator__r.Name';
import IMAGE_EVALUATOR_FIELD from '@salesforce/schema/Review_Assignment__c.Evaluator__r.Image__c';

export default class PerformanceEvaluationWrapper extends LightningElement {
    @api recordId;
    @api filterStatus;
    @api reviewAssgId;
    @api employee;
    @track spinnerOn = true;

    statusReview;
    
    toggleSpinner(status) {
        this.spinnerOn = status;
    }    
    
    @wire(getRecord, { recordId:'$reviewAssgId', fields: [EVALUATOR_FIELD, IMAGE_EVALUATOR_FIELD], optionalFields: [] })
    reviewAssg;
  
    @wire(getRecord, { recordId:'$recordId', fields: [STATUS_FIELD, EVALUATED_FIELD, IMAGE_FIELD,ID_FIELD], optionalFields: [] })
    review;
    
    get reviewOpen() {
        let status = getFieldValue(this.review.data, STATUS_FIELD);
        this.statusReview = status; 
        this.toggleSpinner(false); 
        return status == 'Open' || status == 'In Progress';         
    }

    get image(){
        let userid =  getFieldValue(this.review.data, ID_FIELD); 
        let src;
        if (userid != this.employee){
            src = this.extract(getFieldValue(this.review.data, IMAGE_FIELD));
        } else {
            src = this.extract(getFieldValue(this.reviewAssg.data, IMAGE_EVALUATOR_FIELD));
        }
        if (!src) {
            src = assets + '/img/noimage.jpg';
        }        
        return "<img style=\"width: 100%; height: 100%; object\-fit: cover; color: transparent; text-indent: 10000px; text-allign: center;\" src=\"" + src + "\" alt=\"" + 'some' + "\"></img>";

    }

    get evaluated(){
        let userid =  getFieldValue(this.review.data, ID_FIELD); 
        if (userid != this.employee){
            return getFieldValue(this.review.data, EVALUATED_FIELD); 
        }
        else {
            return getFieldValue(this.reviewAssg.data, EVALUATOR_FIELD); 
        }             
    }

    handleClick() {
        this.dispatchEvent(new CustomEvent('back'));
    }
    @api saveComments(){
        this.template.querySelector("c-review-comments").saveForm();
        
        this.template.querySelector("c-evaluated-kpi").getEvaluatedKpi();
    }
    openReviewComments(){
        this.template.querySelector("c-plan-items-Modal").openModal();
    }

    handleSubmit(){
        this.dispatchEvent(new CustomEvent('submit'));
    }

    extract(str) {
        let m;
        if ((m = /src=\"(.+?)\"/.exec(str)) !== null) {
            return m.length > 1 && m[1] ? m[1] : null;
        }
        return null;
    }
}