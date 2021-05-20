import { LightningElement, api, track } from 'lwc';

export default class PlanItemIcon extends LightningElement {
    @api status;
    @track statusToDisplay;
    connectedCallback() {
       switch (this.status) {
        case 'Non Started':
            this.statusToDisplay = 'red-icon';
            break;
        case 'Started':
            this.statusToDisplay = 'yellow-icon';
            break;
        case 'Completed':
            this.statusToDisplay = 'green-icon';
            break;
        default:
            console.log('default');
      }
    }
}