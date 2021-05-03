import { LightningElement,track } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';
import getData from '@salesforce/apex/LWCBenchReportController.getData';
const columns = [
    '' ,
    '12-Feb',
    '19-Feb',
    '26-Feb',
    '5-Mar',
];
export default class BechReport extends LightningElement {
    data = [];
    @track employees;
    /*@track employees = [{ Name: 'Iron man', Position__c: 'Lead'}, 
    { Name: 'Black Widow', Position__c: 'Salesforce Dev'},
    { Name: 'Hawk eye', Position__c: 'Salesforce Dev'},
    { Name: 'Capitan America', Position__c: 'Salesforce Dev'},
    { Name: 'Spider man', Position__c: 'QA'},
    { Name: 'Hulk', Position__c: 'Designer'},
    { Name: 'Thor', Position__c: 'Android Dev'}];*/
    @track isModalOpen = false;
    errorMsg;
    
    appResources = {
      employeeSilhouette: `${assets}/img/noimage.jpg`,
    };

    selectDay(event){
      this.isModalOpen = true;
      var id = event.target.value;
      var res = id.split("-");
      var week = res[0];
      var proj = res[1];
      var days = this.data.calendar[proj].Days;
      this.employees = days[week].employees;
    }
    openModal() {
      // to open modal set isModalOpen tarck value as true
      this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    async connectedCallback() {
      getData()
      .then(response => {
          if(response){
              this.data = response;
              console.log(this.data);
          }else{
          }
      })
      .catch(error => {
          this.errorMsg = error.body.message;
      })
    }
}