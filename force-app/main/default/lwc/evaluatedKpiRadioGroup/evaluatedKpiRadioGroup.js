import { LightningElement, api} from 'lwc';

export default class EvaluatedKpiRadioGroup extends LightningElement {
    @api kpiId;
    @api kpiName;
    @api kpiPoint;
    @api reviewStatus;
    @api isReviewOpen;
    describeReason; 

    value = '';

    get options() {
        return [
            { label: '1', value: '1' },
            { label: '2', value: '2' },
            { label: '3', value: '3' },
            { label: '4', value: '4' },
            { label: '5', value: '5' },
        ];
    }

    connectedCallback() {
        if(this.kpiPoint){
            this.value = this.kpiPoint.toString();
        }
    }
   
    handleChange(event) {
        this.value = event.detail.value;
        this.describeReason = (event.detail.value == "1" ||  event.detail.value == "2") ? true:false; 
    }

    @api getKpiValue() { 
        var mapKpi = []; 
        let reasonDescription = this.template.querySelector('[data-id="description"]');
        mapKpi.push({kpiId: this.kpiId, point: this.value, reason: reasonDescription.value});
        return mapKpi;
      }
      
}