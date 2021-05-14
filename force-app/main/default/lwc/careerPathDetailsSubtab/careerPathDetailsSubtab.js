/*eslint no-console: “error”*/
import { LightningElement, api } from 'lwc';

export default class CareerPathDetailsSubtab extends LightningElement {
    @api employeeid;
    @api selectedrole;

    get selectedRole() {
        //console.log (JSON.stringify(this.template.querySelector('c-employee-role')));
        let comp = this.template.querySelector('c-employee-role');
        if (comp) {
            comp.refreshRoleInfo(this.selectedrole);
        }
        return this.selectedrole;
    }
}