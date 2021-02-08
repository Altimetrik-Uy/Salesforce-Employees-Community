import { LightningElement, api, track } from 'lwc';

export default class CustomAccordion extends LightningElement {
    @api projectInformation;
    @track isCollapsed = true;

    handleClick() {
        this.isCollapsed = !this.isCollapsed;     
     }
     
     get cssClass(){
         return (this.isCollapsed ? 'slds-hide' : 'slds-is-open' );
     }
}