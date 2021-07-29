import { api, wire, track, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import STATUS_FIELD from '@salesforce/schema/Review__c.Status__c';

export default class PerformanceEvaluationWrapper extends LightningElement {
    @api recordId;
    @api filterStatus;
    statusReview;
    @track spinnerOn = true;

    toggleSpinner(status) {
        this.spinnerOn = status;
    }
    
    @wire(getRecord, { recordId:'$recordId', fields: [STATUS_FIELD], optionalFields: [] })
    review;
    get reviewOpen() {
        let status = getFieldValue(this.review.data, STATUS_FIELD);
        this.statusReview = status; 
        this.toggleSpinner(false); 
        return status == 'Open' || status == 'In Progress';         
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
        let pass = this.missingValues();
        if (!pass){
            this.dispatchEvent(new CustomEvent('submit'));
        }
        
    }

    missingValues(){
        let missedComment = this.template.querySelector("c-review-comments").getComments()
                            ? this.template.querySelector("c-review-comments").getComments().replaceAll('<p>','').replaceAll('</p>','').trim().length<=0 
                            : true;
        let missedKpiValues = this.template.querySelector("c-evaluated-kpi").getMissingKPiValues().length>0;
        let missedPlanItems = this.template.querySelector("c-review-plan-items").getPlantItems().data.length<=0;
        console.log('pass');
        if(missedComment || missedKpiValues || missedPlanItems) {    
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Comments and KPIs evaluation/reason are required',
                    variant: 'error'
                })
            );        
            return true;
        }
        else {
            return false
        }
    }

}