import { LightningElement,api, track} from 'lwc';
export default class PlanItemCard extends LightningElement {
    @api planitem;
    @api isreviewopen;

    openModal(){
        this.template.querySelector("c-plan-items-Modal").openModal();
    }
}