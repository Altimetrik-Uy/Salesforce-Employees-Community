import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getEvaluatedKpi from '@salesforce/apex/LWCEvaluatedKpiController.getEvaluatedKpi';
import getEvaluatedKpiBySection from '@salesforce/apex/LWCEvaluatedKpiController.getEvaluatedKpiBySection';
import setEvaluatedKpi from '@salesforce/apex/LWCEvaluatedKpiController.setEvaluatedKpi';

export default class EvaluatedKpi extends LightningElement {
    @api reviewId; 
    @api isReviewOpen;
    @track evaluatedKpis= [];

    kpiValues;
    activeSections= [];
    
    @wire(getEvaluatedKpiBySection,{reviewId: '$reviewId'}) wiredEvaluatedKpi(result){
        this.kpiValues = result;
        this.evaluatedKpis= [];
        const {data, error} = result;
        if(data){
            //this.evaluatedKpis = data;
            for(let key in data) {
                if (data.hasOwnProperty(key)) { 
                    this.activeSections.push(key);
                    this.evaluatedKpis.push({key: key, value: data[key]});
                }
            }
        }else if (error){
            console.log('error')
            this.error = error;
        }
    }
    
    @api getEvaluatedKpi() {
        var arrEvaluatedKpis = [];
        let reasonNeeded = false;  
        this.template
          .querySelectorAll("c-evaluated-kpi-radio-group")
          .forEach(element => {
            var evalKpis = element.getKpiValue();
            arrEvaluatedKpis.push(evalKpis);
            reasonNeeded = ((evalKpis[0].point == '1' || evalKpis[0].point == '2') && !evalKpis[0].reason); 
          });
          if(reasonNeeded) {   
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Missing reason',
                    message: 'Please provide the required reason for the review',
                    variant: 'error'
                })
            ); 
          }else { 
            setEvaluatedKpi({evaluatedKpis: JSON.stringify(arrEvaluatedKpis)})
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Evaluated Kpis was saved.',
                        variant: 'success'
                    })
                );
                refreshApex(this.kpiValues);
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

      @api
      getMissingKPiValues() {
        let missedKPIValues = [];
        this.template
        .querySelectorAll("c-evaluated-kpi-radio-group")
        .forEach(element => {
            let evalKpis = element.getKpiValue();
            if(!evalKpis[0].point) {
                missedKPIValues.push(evalKpis);
            }
        });
        return missedKPIValues; 
      }
    
}