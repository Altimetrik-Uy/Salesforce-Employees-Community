import { LightningElement, api, wire, track } from 'lwc';
import getPath from '@salesforce/apex/PathAssistant.getPath'

import {
    ScenarioState,
    Step
} from './utils';

export default class PathAssistant extends LightningElement {
   
    @api employeeid;
    @track error;
    @track organizedPath;
    // show/hide a loading spinner
    @track spinner = false;
    // error message, when set will render the error panel
    @track errorMsg;
    // available picklist values for current record (based on record type)
    @track possibleSteps;
    // step selected by the user
    @track selectedStepValue;

    _optionSelected;

    constructor() {
        super();
    }

    @wire(getPath,{empId: '$employeeid'}) getPath({error,data}){
        if(data){
            if (data) {
                let arrPossibleSteps = [];
                let index = 0; 
                for (const objCareerPath of data) {
                    for (const role of objCareerPath.lstWrpRoles) {
                        arrPossibleSteps.push(new Step(role.strRole, role.strRole, index));
                        index++;
                        if(objCareerPath.blnCurrentRole){
                            this._optionSelected = objCareerPath.strRole.replace('Salesforce ', '');
                        }
                    }
                }
                this.possibleSteps = arrPossibleSteps;
                this.organizedPath = data;
            } else {
                this.errorMsg = `Impossible to load`;
            }
        }
    }

    // true when all required data is loaded
    get isLoaded() {
        const res = this.possibleSteps;
        return res;
    }

    // true if either spinner = true or component is not fully loaded
    get hasToShowSpinner() {
        return this.spinner || !this.isLoaded;
    }

    get genericErrorMessage() {
        // note: you can store this in a custom label if you need
        return 'An unexpected error occurred. Please contact your System Administrator.';
    }
}