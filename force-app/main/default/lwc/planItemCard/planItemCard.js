import { LightningElement,api } from 'lwc';

export default class PlanItemCard extends LightningElement {
    @api planItem;
    @api isReviewOpen;
}