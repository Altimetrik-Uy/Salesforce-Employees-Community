import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getEvaluatedKpi from '@salesforce/apex/LWCEvaluatedKpiController.getEvaluatedKpi';
import setEvaluatedKpi from '@salesforce/apex/LWCEvaluatedKpiController.setEvaluatedKpi';

export default class EvaluatedKpi extends LightningElement {
    @api reviewId;
    @api isReviewOpen;
    @track evaluatedKpis;
    
    @wire(getEvaluatedKpi,{reviewId: '$reviewId'}) wiredEvaluatedKpi({error,data}){
        if(data){
            this.evaluatedKpis = data;
        }else if (error){
            console.log('error')
            this.error = error;
        }
    }
    
    @api getEvaluatedKpi() {
        var arrEvaluatedKpis = [];
        this.template
          .querySelectorAll("c-evaluated-kpi-radio-group")
          .forEach(element => {
            arrEvaluatedKpis.push(element.getKpiValue());
          });
          setEvaluatedKpi({evaluatedKpis: JSON.stringify(arrEvaluatedKpis)})
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Evaluated Kpis was saved.',
                        variant: 'success'
                    })
                );
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error saving Kpis.',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
      }
    
}