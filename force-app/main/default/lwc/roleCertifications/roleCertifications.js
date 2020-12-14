import { LightningElement, api, wire, track } from 'lwc';
import getPorcentaje from '@salesforce/apex/RoleCertificationsController.getPercentages';
import IsFlsUpdatable from '@salesforce/schema/UserEntityAccess.IsFlsUpdatable';
import { NavigationMixin } from 'lightning/navigation';

export default class RoleCertifications extends NavigationMixin(LightningElement) {
    @api userId;
    wrapper;
    error;
    display = false;

    @wire(getPorcentaje, { userId: '$userId' })
    wiredWrapper({ error, data }) {
        if (data) {
            if (data[0].trailblazerId == false) {
                this.error = "Please add your trailblazer Id in order to track your progress";
            } else {
                this.wrapper = data;
                this.display = true;
                this.error = undefined;
            }
        } else if (error) {
            this.error = error;
            this.wrapper = undefined;
        }
    }

    goToPath(event){
        const goToPath1 = new CustomEvent(
            'gotocpath', {
            detail: event.target.value    
        });
        this.dispatchEvent(goToPath1);
    }
}