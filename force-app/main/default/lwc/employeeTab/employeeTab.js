import { LightningElement, wire, api, track } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
const NAME_FIELD = 'Contact.Name';
const ROLE_FIELD = 'Contact.Role__c';
const IMAGE_FIELD = 'Contact.Image__c';

export default class EmployeeTab extends LightningElement {

    @api employeeid;

    imgMarkup;
    employeeName;
    employeeRole;

    @track imageStatus;
    @track projectStatusImageName;

    selectedTab;
    sTArray = [];

    @wire(getRecord, { recordId: '$employeeid', fields: [NAME_FIELD, ROLE_FIELD, IMAGE_FIELD] })
    loadContactInfo({ error, data }) {
        if (error) {
        } else {
            this.employeeName = getFieldValue(data, NAME_FIELD);
            this.employeeRole = getFieldValue(data, ROLE_FIELD);
            if (!this.employeeRole) {
                this.employeeRole = 'not defined';
            }
            let src = this.extract(getFieldValue(data, IMAGE_FIELD));
            if (!src) {
                src = assets + '/img/noimage.jpg';
            }
            this.imgMarkup = "<p style=\"margin-top: 0px; \"><img style=\"width: 150px; height: 150px; border-radius: 50%;\" src=\"" + src + "\" alt=\"" + this.employeeName + "\"></img></p>";
        }
    }

    extract(str) {
        let m;
        if ((m = /src=\"(.+?)\"/.exec(str)) !== null) {
            return m.length > 1 && m[1] ? m[1] : null;
        }
        return null;
    }

    handleEmployeeStatus(event) {
        this.imageStatus = event.detail;
    }

    handleProjectStatus(event) {
        this.projectStatusImageName = event.detail;
    }

    goToCPath() {
        this.selectedTab = this.template.querySelector('lightning-tab').value;
        var currentTab = this.selectedTab;
        if (currentTab != 'cpath') {
            this.selectedTab = 'cpath';
        } 
        this.template.querySelector('lightning-tabset').activeTabValue = this.selectedTab;
    }

    handleGoToCPath(){
        
        this.selectedTab = this.template.querySelector('lightning-tab').value;
        var currentTab = this.selectedTab;
        if (currentTab != 'cpath') {
            this.selectedTab = 'cpath';
        } 
        this.template.querySelector('lightning-tabset').activeTabValue = this.selectedTab;
    }


    renderedCallback() {
        const style = document.createElement('style');
        style.innerText = `slds-is-active {
        background-color: #54C2B2;
        }`;
        this.template.querySelector('lightning-tab').appendChild(style);
    }

}