import { LightningElement,api, track} from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PlanItemCard extends LightningElement {
    @api planitem;
    @api isreviewopen;
    @track isDialogVisible = false;

    openModal(){
        this.template.querySelector("c-plan-items-Modal").openModal();
    }
    confirmDelete(){
        this.isDialogVisible = true;
    }

    planItemUpdated(){
        const planItemUpdated = new CustomEvent("itemupdated", {
            detail: true
        });
        this.dispatchEvent(planItemUpdated); 
    }

    handleDelete(event){
        if(event.target.name === 'confirmModal'){
            if(event.detail.status === 'confirm') {
                deleteRecord(this.planitem.Id)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Plan Item deleted',
                            variant: 'success'
                        })
                    );
                    const planItemSaved = new CustomEvent("itemdeleted", {
                        detail: true
                    });
                    this.dispatchEvent(planItemSaved); 
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error deleting Plan Item',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
              }else if(event.detail.status === 'cancel'){
              }
          this.isDialogVisible = false;
      }
    }
}