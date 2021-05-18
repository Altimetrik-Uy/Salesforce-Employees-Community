import { LightningElement, api } from 'lwc';

export default class PlanItemIcon extends LightningElement {
    @api status;
    statusToDisplay;
    connectedCallback() {
       switch (this.status) {
        case 'Non Started':
            this.statusToDisplay = 'slds-progress-ring slds-progress-ring_expired';
            break;
        case 'Started':
            this.statusToDisplay = 'slds-progress-ring .slds-progress-ring_warning';
            break;
        case 'Completed':
            this.statusToDisplay = 'slds-progress-ring slds-progress-ring_complete';
          break;
        default:
            
      }
    }
}