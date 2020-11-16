import { LightningElement, wire, api } from 'lwc';
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

    @wire(getRecord, {recordId: '$employeeid', fields: [NAME_FIELD, ROLE_FIELD, IMAGE_FIELD]})
    loadContactInfo({error, data}) {
        if (error) {
            console.error(error);
        }else{
            this.employeeName = getFieldValue(data, NAME_FIELD);
            this.employeeRole = getFieldValue(data, ROLE_FIELD);
            if (!this.employeeRole){
                this.employeeRole = 'not defined';
            }
            let src = this.extract(getFieldValue(data, IMAGE_FIELD));
            if (!src) {
                src = assets + '/img/noimage.jpg';
            }
            this.imgMarkup = "<p style=\"margin-top: 0px; border-left: 1px solid #D4D4D4;\"><img style=\"width: 100px; border-radius: 10px;\" src=\"" + src + "\" alt=\"" + this.employeeName + "\"></img></p>";
        }
      }

      extract(str){
        let m;
        if ((m = /src=\"(.+?)\"/.exec(str)) !== null) {
            return m.length > 1 && m[1] ? m[1] : null;
        }
        return null;
      }

}