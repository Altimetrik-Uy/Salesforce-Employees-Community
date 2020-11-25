import {LightningElement, api, wire} from 'lwc';
import getRoleDescription from '@salesforce/apex/LWCEmployeeOverallController.getRoleDescription';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
const ROLE_FIELD = 'Contact.Role__c';


export default class EmployeeCareerPathSubtab extends LightningElement {
    @api employeeid;
    roleDescription = '';
    roleName = '';
    isCollapsed = false;

    @wire(getRecord, {recordId: '$employeeid', fields: [ROLE_FIELD]})
    loadContactInfo({error, data}) {
        if (error) {
            console.error(error);
        }else if (data) {
            this.roleName = getFieldValue(data, ROLE_FIELD);
            this.getDescription();
        }
    }

    getDescription()
    {
        if (this.roleName !== '') {
            getRoleDescription({roleName : this.roleName})
            .then(roleDesc => {
                this.roleDescription = roleDesc;
            })
            .catch(error => {
                console.log (error);
            });
        } 
    }

    handleClick() {
        this.isCollapsed = !this.isCollapsed;
    }

    get cssClass(){
        return (this.isCollapsed ? 'slds-hide' : 'slds-accordion__content' ) + ' slds-var-p-left_small';
    }

    get iconName(){
        return this.isCollapsed ? 'utility:chevronright' : 'utility:chevrondown' ;
    }
}