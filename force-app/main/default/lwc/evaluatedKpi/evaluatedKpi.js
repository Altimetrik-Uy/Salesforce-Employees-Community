import { LightningElement, api, wire, track } from 'lwc';
import getEvaluatedKpi from '@salesforce/apex/LWCEvaluatedKpiController.getEvaluatedKpi';

export default class EvaluatedKpi extends LightningElement {
    @api employeeid;
    @api reviewId;
    @track evaluatedKpis;
    //close review a0X4x000000SWtKEAW  - open a0X4x000000SUUbEAO
    @wire(getEvaluatedKpi,{reviewId: '$reviewId'}) wiredEvaluatedKpi({error,data}){
        if(data){
            this.evaluatedKpis = data;
        }else if (error){
            console.log('error')
            this.error = error;
        }
    }
}