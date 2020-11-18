import {LightningElement, api, wire} from 'lwc';
import getRoleInformation from '@salesforce/apex/LWCEmployeeOverallController.getRoleInformation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
const ROLE_FIELD = 'Contact.Role__c';


export default class EmployeeCareerPathSubtab extends LightningElement {
    @api employeeid;
    roleDescription = '';
    roleName = '';
    isCollapsed = false;
    roleInfo;

    @wire(getRecord, {recordId: '$employeeid', fields: [ROLE_FIELD]})
    loadContactInfo({error, data}) {
        if (error) {
            console.log(error);
        }else if (data) {
            this.roleName = getFieldValue(data, ROLE_FIELD);
            this.getRoleInfo();
        }
    }

    getRoleInfo()
    {
        if (this.roleName !== '') {
            getRoleInformation({roleName : this.roleName})
            .then(role => {
                if (role) {
                    this.roleInfo = role
                }
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