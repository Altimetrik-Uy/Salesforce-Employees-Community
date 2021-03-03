import {LightningElement, api, wire, track} from 'lwc';
import sendMessage from '@salesforce/apex/LWCEmployeeCareerPathController.sendMessage';
import getManager from '@salesforce/apex/LWCEmployeeCareerPathController.getManager';
import getUser from '@salesforce/apex/LWCEmployeeCareerPathController.getUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmployeeCareerPathSubtab extends LightningElement {
    @api employeeid;
    @track error; 
    @track lstManagerId = [];
    @track userName = '';

    @wire(getManager,{empId: '$employeeid'}) getManager({error,data}){
        if(data){
            this.lstManagerId = data;
        }else if (error){
            this.error = error;
        }
    }

    @wire(getUser,{empId: '$employeeid'}) getUser({error,data}){
        if(data){
            this.userName = data;
        }else if (error){
            this.error = error;
        }
    }
    
    onClickSendMessage(){
        sendMessage({lstManagersId:this.lstManagerId, userName:this.userName})
        .then (s=>{
            if(s){
                const event = new ShowToastEvent({
                    title: 'Success!',
                    message: 'Message has been sent.',
                    variant: 'success',
                });
                this.dispatchEvent(event);
            }else{
                const event = new ShowToastEvent({
                    title: 'Fail!',
                    message: 'Message has not been sent. Current project does not have a manager assigned to be notified.',
                    variant: 'error',
                });
                this.dispatchEvent(event);
            }
        })
    }
}