import { LightningElement, track, wire} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
const USER_ID_FIELD = 'User.Id';
const CONTACT_ID_FIELD = 'User.ContactId';

export default class MainTabset extends LightningElement {
    
    employeeid;

    @wire(getRecord, { recordId: USER_ID, fields: [USER_ID_FIELD, CONTACT_ID_FIELD] })
    userData({error, data}) {
        if(data) {
            this.employeeid = getFieldValue(data, CONTACT_ID_FIELD);
        } else if(error) {
            console.error(JSON.stringify(error))
        } 
    }
}