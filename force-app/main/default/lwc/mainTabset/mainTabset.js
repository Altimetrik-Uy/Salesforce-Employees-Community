import { LightningElement, track, wire} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
const USER_ID_FIELD = 'User.Id';
const CONTACT_ID_FIELD = 'User.ContactId';

export default class MainTabset extends LightningElement {
    
    employeeid;

    @track homeTab  = 'slds-default-tabs__nav-item slds-is-active';
    @track careerTab = 'slds-default-tabs__nav-item';
    @track certificationsTab = 'slds-default-tabs__nav-item';
    @track howTab = 'slds-default-tabs__nav-item'; 
 
    @track homeCont = 'slds-default-tabs__content slds-show';
    @track careerCont = 'slds-default-tabs__content slds-hide';
    @track certificationsCont = 'slds-default-tabs__content slds-hide'; 
    @track howCont = 'slds-default-tabs__content slds-hide';  

    tabClassActive = 'slds-default-tabs__nav-item slds-is-active';
    tabClassInactive = "slds-default-tabs__nav-item";
    contentClassShow = 'slds-default-tabs__content slds-show';
    contentClassHide = "slds-default-tabs__content slds-hide";

    openTab(event) {
        var targetId = event.currentTarget.id;
        //Career path tab
        if (targetId.includes('linkcareerpath')) {
            //tab section
            this.homeTab = this.tabClassInactive;
            this.careerTab = this.tabClassActive;
            this.certificationsTab = this.tabClassInactive;
            this.howTab = this.tabClassInactive;

            //content section
            this.homeCont = this.contentClassHide;
            this.careerCont = this.contentClassShow;
            this.certificationsCont = this.contentClassHide;
            this.howCont = this.contentClassHide; 

        } else 
            //Overall tab
            if (targetId.includes('linkhome')){
                //tab section
                this.homeTab = this.tabClassActive;;
                this.careerTab = this.tabClassInactive;
                this.certificationsTab = this.tabClassInactive;
                this.howTab = this.tabClassInactive; 

                //content section
                this.homeCont = this.contentClassShow;
                this.careerCont = this.contentClassHide;
                this.certificationsCont = this.contentClassHide;
                this.howCont = this.contentClassHide; 
            } else 
                //Certifications tab
                if (targetId.includes('linkcertifications')){
                    //tab section
                    this.homeTab = this.tabClassInactive;;
                    this.careerTab = this.tabClassInactive;
                    this.certificationsTab = this.tabClassActive;
                    this.howTab = this.tabClassInactive;
        
                    //content section
                    this.homeCont = this.contentClassHide;
                    this.careerCont = this.contentClassHide;
                    this.certificationsCont = this.contentClassShow;
                    this.howCont = this.contentClassHide;
                } else 
                    //How do we Work? tab
                    if (targetId.includes('linkhow')){
                        //tab section
                        this.homeTab = this.tabClassInactive;;
                        this.careerTab = this.tabClassInactive;
                        this.certificationsTab = this.tabClassInactive;
                        this.howTab = this.tabClassActive;

                        //content section
                        this.homeCont = this.contentClassHide;
                        this.careerCont = this.contentClassHide;
                        this.certificationsCont = this.contentClassHide;
                        this.howCont = this.contentClassShow;
                    }  
    }

    @wire(getRecord, { recordId: USER_ID, fields: [USER_ID_FIELD, CONTACT_ID_FIELD] })
    userData({error, data}) {
        if(data) {
            this.employeeid = getFieldValue(data, CONTACT_ID_FIELD);
        } else if(error) {
            console.error(JSON.stringify(error))
        } 
    }
}