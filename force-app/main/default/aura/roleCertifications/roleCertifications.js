import { LightningElement, api, wire } from 'lwc';
import getPorcentaje from '@salesforce/apex/RoleCertificationsController.getPercentages';

export default class RoleCertifications extends LightningElement {
    @api userId;
    wrapper;
    error;

    @wire(getPorcentaje, { userId: '$userId' })
    wiredWrapper({ error, data }) {
        if (data) {
            console.log('RoleCertifications.this.userId ' + this.userId);
            console.log('RoleCertifications.data ', data);
            console.log('RoleCertifications.dataTraliblazerId ', data[0].trailblazerId);
            if (data[0].trailblazerId == false) {
                this.error = "Please add your trailblazer Id in order to track your progress";
            } else {
                this.wrapper = data;
                this.error = undefined;
            }
        } else if (error) {
            console.log('RoleCertifications.this.userId ' + this.userId);
            console.log('RoleCertifications.error ' + error);
            this.error = error;
            this.wrapper = undefined;
        }
    }

   
    goToPath(event){
        console.log('Hello world');
        const goToPath1 = new CustomEvent(
            'gotocpath', {
            detail: event.target.value
        });
        this.dispatchEvent(goToPath1);
    }
}