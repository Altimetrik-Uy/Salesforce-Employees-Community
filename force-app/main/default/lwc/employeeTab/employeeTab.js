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
            this.imgMarkup = "<p style=\"margin-top: 0px; \"><img class=\"image-style;\" src=\"" + src + "\" alt=\"" + this.employeeName + "\"></img></p>";
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


}