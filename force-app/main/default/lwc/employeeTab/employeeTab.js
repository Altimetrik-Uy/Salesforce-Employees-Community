import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import assets from '@salesforce/resourceUrl/assets';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import strUserId from '@salesforce/user/Id';
import getTrailBlazerId from '@salesforce/apex/LWCEmployeeOverallController.getTrailBlazerId';
import insertTrailBlazerId from '@salesforce/apex/LWCEmployeeOverallController.insertTrailBlazerId';

const NAME_FIELD = 'Contact.Name';
const ROLE_FIELD = 'Contact.Role__c';
const IMAGE_FIELD = 'Contact.Image__c';

export default class EmployeeTab extends LightningElement {

    @api employeeid;
    @track userId = strUserId;
    @track trailBlazerId;
    newTrailId;
    hrefTrailId;
    @track pressEditTrailblazerId = false;

    imgMarkup;
    employeeName;
    employeeRole;

    @track overallTab  = 'slds-vertical-tabs__nav-item slds-is-active';
    @track careerTab = 'slds-vertical-tabs__nav-item';
    @track statusTab = 'slds-vertical-tabs__nav-item';
    @track projectsTab = 'slds-vertical-tabs__nav-item'; 
    @track performanceTab = 'slds-vertical-tabs__nav-item';

    @track overallCont = 'slds-vertical-tabs__content slds-show';
    @track careerCont = 'slds-vertical-tabs__content slds-hide';
    @track statusCont = 'slds-vertical-tabs__content slds-hide'; 
    @track projectsCont = 'slds-vertical-tabs__content slds-hide'; 
    @track performanceCont = 'slds-vertical-tabs__content slds-hide'; 

    tabClassActive = 'slds-vertical-tabs__nav-item slds-is-active';
    tabClassInactive = "slds-vertical-tabs__nav-item";
    contentClassShow = 'slds-vertical-tabs__content slds-show';
    contentClassHide = "slds-vertical-tabs__content slds-hide";

    @track imageStatus;
    @track projectStatusImageName;

    selectedTab;
    sTArray = [];
    
    openTab(event) {
        var targetId = event.currentTarget.id;
        //Career path tab
        this.changeTab(targetId);
    }

    changeTab(targetId){
        if (targetId.includes('linkcareerpath')) {
            //tab section
            this.overallTab = this.tabClassInactive;
            this.careerTab = this.tabClassActive;
            this.statusTab = this.tabClassInactive;
            this.projectsTab = this.tabClassInactive;
            this.performanceTab = this.tabClassInactive;

            //content section
            this.overallCont = this.contentClassHide;
            this.careerCont = this.contentClassShow;
            this.statusCont = this.contentClassHide;
            this.projectsCont = this.contentClassHide;
            this.performanceCont = this.contentClassHide;

        } else 
            //Overall tab
            if (targetId.includes('linkoverall')){
                //tab section
                this.overallTab = this.tabClassActive;;
                this.careerTab = this.tabClassInactive;
                this.statusTab = this.tabClassInactive;
                this.projectsTab = this.tabClassInactive;
                this.performanceTab = this.tabClassInactive;

                //content section
                this.overallCont = this.contentClassShow;
                this.careerCont = this.contentClassHide;
                this.statusCont = this.contentClassHide;
                this.projectsCont = this.contentClassHide;
                this.performanceCont = this.contentClassHide;
            } else 
                //Status tab
                if (targetId.includes('linkstatus')){
                    //tab section
                    this.overallTab = this.tabClassInactive;;
                    this.careerTab = this.tabClassInactive;
                    this.statusTab = this.tabClassActive;
                    this.projectsTab = this.tabClassInactive;
                    this.performanceTab = this.tabClassInactive;
        
                    //content section
                    this.overallCont = this.contentClassHide;
                    this.careerCont = this.contentClassHide;
                    this.statusCont = this.contentClassShow;
                    this.projectsCont = this.contentClassHide;
                    this.performanceCont = this.contentClassHide;
                }  else 
                    //Projects tab
                    if (targetId.includes('linkprojects')){
                        //tab section
                        this.overallTab = this.tabClassInactive;;
                        this.careerTab = this.tabClassInactive;
                        this.statusTab = this.tabClassInactive;
                        this.projectsTab = this.tabClassActive;
                        this.performanceTab = this.tabClassInactive;

                        //content section
                        this.overallCont = this.contentClassHide;
                        this.careerCont = this.contentClassHide;
                        this.statusCont = this.contentClassHide;
                        this.projectsCont = this.contentClassShow;
                        this.performanceCont = this.contentClassHide;
                    } else 
                        //Performance tab
                        if (targetId.includes('linkperformance')){
                            //tab section
                            this.overallTab = this.tabClassInactive;;
                            this.careerTab = this.tabClassInactive;
                            this.statusTab = this.tabClassInactive;
                            this.projectsTab = this.tabClassInactive;
                            this.performanceTab = this.tabClassActive;

                            //content section
                            this.overallCont = this.contentClassHide;
                            this.careerCont = this.contentClassHide;
                            this.statusCont = this.contentClassHide;
                            this.projectsCont = this.contentClassHide;
                            this.performanceCont = this.contentClassShow;
                        }    
    }
    
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
            this.imgMarkup = "<img style=\"width: 100%; height: 100%; object\-fit: cover; color: transparent; text-indent: 10000px; text-allign: center;\" src=\"" + src + "\" alt=\"" + this.employeeName + "\"></img>";
        }
    }
   
    @wire(getTrailBlazerId, {uId: '$userId'})
    wiredTrailblazer({ error, data }) {
        if (data) {
            this.trailBlazerId = data;
            this.hrefTrailId = "https://trailblazer.me/id/"+this.trailBlazerId;
        } else if (error) {
            this.trailBlazerId = undefined;
        }
    }
    
    editTrailblazerId(){
        this.pressEditTrailblazerId = true;
        this.newTrailId = this.trailBlazerId;
    }

    cancelTrailId(){
        this.pressEditTrailblazerId = false;
    }

    handleInput(event) {
        this.newTrailId = event.target.value;
    }

    keyCheck({code}){
        //checks for "enter" key
        if (('Enter' === code) || ('NumpadEnter' === code)){
            this.insertTrailIdClick();
        }
    }
    
    insertTrailIdClick(){
        if(this.newTrailId){
            if(this.newTrailId != this.trailBlazerId){
                insertTrailBlazerId({ uId: this.userId, newTrailBlazerId: this.newTrailId })
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Trailblazer Id was updated. Data may take up to 40 minutes to be updated',
                            variant: 'success'
                        })
                    );
                    this.trailBlazerId = this.newTrailId;
                    this.pressEditTrailblazerId = false;
                }).catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error updating the Trailblaizer Id',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
            } else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Info',
                        message: 'Trailblazer id should be different.',
                        variant: 'info'
                    })
                );
                this.pressEditTrailblazerId = false;
            }
        }else{
                this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Warning',
                            message: 'Trailblazer Id cannot be empty.',
                            variant: 'warning'
                        })
                    );
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

    handleGoToCPath(){
        this.changeTab('linkcareerpath');
    }
}