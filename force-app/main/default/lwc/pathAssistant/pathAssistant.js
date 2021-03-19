/*eslint no-console: “error”*/
import { LightningElement, api, wire, track } from 'lwc';
import getPath from '@salesforce/apex/PathAssistant.getPath'
import getPathByMainRole from '@salesforce/apex/PathAssistant.getPathByMainRole'

import {
    ScenarioState,
    Step
} from './utils';

export default class PathAssistant extends LightningElement {
   
    @api employeeid;
    @api mainRole;
    @track isCarrerTab;
    @track error;
    @track isPreRole = true;
    @track organizedPath;
    // show/hide a loading spinner
    @track spinner = false;
    // error message, when set will render the error panel
    @track errorMsg;
    // available picklist values for current record (based on record type)
    @track possibleSteps;
    // step selected by the user
    @track selectedStepValue;
    
    @track careerPathStyle = 'slds-path__nav slds-grid slds-grid_vertical-align-center';
    
    _optionSelected;


    constructor() {
        super();
    }

    @wire(getPath,{empId: '$employeeid'}) getPath({error,data}){
        if(data){
            if (data) {
                this.isCarrerTab = false;
                let arrPossibleSteps = [];
                let index = 0;
                var roleQA = '';
                for (const objCareerPath of data) {
                    for (const role of objCareerPath.lstWrpRoles){ 
                        roleQA = role.strRole;
                        if(roleQA.includes('QA')){
                            this.careerPathStyle = 'slds-path__nav  slds-grid slds-grid_vertical-align-center';
                        }
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
                this.errorMsg = 'Impossible to load';
            }
        }
    }

    @wire(getPathByMainRole, {mainRole:'$mainRole'}) getPathWithoutEmpId({error,data}) {
        this.possibleSteps = undefined;
        this.organizedPath = undefined;
        if(data){
            if (data) {
                this.isCarrerTab = true;
                let arrPossibleSteps = [];
                let index = 0;
                var roleQA = '';
                for (const objCareerPath of data) {
                    for (const role of objCareerPath.lstWrpRoles){ 
                        roleQA = role.strRole;
                        if(roleQA.includes('QA')){
                            this.careerPathStyle = 'slds-path__nav  slds-grid slds-grid_vertical-align-center';
                        }
                        arrPossibleSteps.push(new Step(role.strRole, role.strRole, index));
                        index++;
                        if(objCareerPath.blnCurrentRole){
                            this._optionSelected = objCareerPath.strRole.replace('Salesforce ', '');
                        } 
                    }
                }
                this.possibleSteps = arrPossibleSteps;
                this.organizedPath = data;
                this.setDefault();
            } else {
                this.errorMsg = 'Impossible to load';
            }
        }
    }

    setDefault () {
        if (this.organizedPath && this.organizedPath[0].lstWrpRoles) {
            let firstStep = this.organizedPath[0].lstWrpRoles[0].strRole;
            this.dispatchRoleSelected ( firstStep );
        }
    }

    handleRolClicked (event) {
        if (this.mainRole) {
            let divs = this.template.querySelectorAll('.slds-path__item');
            for (let i=0; i < divs.length; i++){
                divs[i].className = 'slds-path__item slds-is-incomplete';
            }
            this.template.querySelector('[data-item="' + event.currentTarget.dataset.item + '"]').className='slds-path__item slds-is-active'
            this.dispatchRoleSelected (event.currentTarget.dataset.item);
        }
        console.log ('Rol Clicked ' + event.currentTarget.dataset.item);
        
    }

    dispatchRoleSelected (roleSelected) {
        // Creates the event with the contact ID data.
        const selectedEvent = new CustomEvent('roleselected', { detail: roleSelected  });
        this.dispatchEvent(selectedEvent);
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