import { LightningElement, api, wire, track} from 'lwc';
import sendMessage from '@salesforce/apex/LWCEmployeeCareerPathController.sendMessage';
import getManager from '@salesforce/apex/LWCEmployeeCareerPathController.getManager';
import getUser from '@salesforce/apex/LWCEmployeeCareerPathController.getUser';
import getRole from '@salesforce/apex/LWCEmployeeCareerPathController.getRole';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const ACTIVE_CLASS = ' slds-is-active';
const NAV_ITEM_CLASS = 'slds-vertical-tabs__nav-item';

export default class CareerPathTab extends LightningElement {
    @api employeeid;
    @api mainRole = "Developer Path";
    @track selectedrole;
    @track error; 
    @track lstManagerId = [];
    @track userName = '';

    selectedTab = 'linkdetails';
    detailsTab = NAV_ITEM_CLASS  + ACTIVE_CLASS;
    certificationsTab = NAV_ITEM_CLASS;
    salaryTab = NAV_ITEM_CLASS;

    openTab(event) {
        this.setSelectedTab (event.currentTarget.name);
    }

    get options() {
        return [
            { label: 'QA Path', value: 'QA Path' },
            { label: 'Developer Path', value: 'Developer Path' },
        ];
    }

    handleRoleChange(event) {
        this.mainRole = event.detail.value;
    }

    get isDetailsSelected(){
        return (this.selectedTab == 'linkdetails');
    }

    get isCertificationsSelected(){
        return (this.selectedTab == 'linkcertifications');
    }

    get isSalarySelected(){
        return (this.selectedTab == 'linksalary');
    }

    setSelectedTab (tabId) {
        this.selectedTab = tabId;
        this.detailsTab = NAV_ITEM_CLASS;
        this.certificationsTab = NAV_ITEM_CLASS;
        this.salaryTab = NAV_ITEM_CLASS;
        switch(tabId) {
            case 'linkcertifications':
                this.certificationsTab += ACTIVE_CLASS;
              break;
            case 'linksalary':
                this.salaryTab += ACTIVE_CLASS;
              break;
            default:
                this.detailsTab +=  ACTIVE_CLASS;
          }
    }

    handleOnRoleSelected(event) {
        this.selectedrole = event.detail;
    }
    
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

    @wire(getRole,{empId: '$employeeid'}) getRole({error,data}){
        if(data){
            if(data.includes('QA')) 
                this.mainRole = 'QA Path';
            else
                this.mainRole = 'Developer Path';
        }else if (error){
            this.error = error;
        }
    }
    
    onClickSendMessage(){
        if(this.lstManagerId[0] !== 'You dont have manager assigned'){
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
                        title: 'Warning!',
                        message: 'You must wait 24hs since the last request, to sent another one.',
                        variant: 'warning',
                    });
                    this.dispatchEvent(event);
                }
            })
        }else{
            const event = new ShowToastEvent({
                title: 'Fail!',
                message: 'Message has not been sent. Current project does not have a manager assigned to be notified.',
                variant: 'error',
            });
            this.dispatchEvent(event);
        }
    }
}