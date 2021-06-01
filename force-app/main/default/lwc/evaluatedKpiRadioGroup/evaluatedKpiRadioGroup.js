import { LightningElement, api} from 'lwc';

export default class EvaluatedKpiRadioGroup extends LightningElement {
    @api kpiId;
    @api kpiName;
    @api kpiPoint;
    @api reviewStatus;
    isReviewOpen = false;

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
        if(this.reviewStatus == 'Open' || this.reviewStatus == 'In Progress'){
            this.isReviewOpen = true;
        }
    }
   
    handleChange(event) {
        this.value = event.detail.value;
        console.log('new value ' + this.value);
    }

}