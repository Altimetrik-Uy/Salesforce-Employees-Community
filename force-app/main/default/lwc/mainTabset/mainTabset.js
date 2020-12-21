import { LightningElement, track, wire} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
const USER_ID_FIELD = 'User.Id';
const CONTACT_ID_FIELD = 'User.ContactId';

export default class MainTabset extends LightningElement {
    
    employeeid;

    @track homeTab  = 'slds-tabs--default__item slds-active';
    @track careerTab = 'slds-tabs--default__item';
    @track certificationsTab = 'slds-tabs--default__item';
    @track howTab = 'slds-tabs--default__item'; 
 
    @track homeCont = 'slds-tabs--default__content slds-show';
    @track careerCont = 'slds-tabs--default__content slds-hide';
    @track certificationsCont = 'slds-tabs--default__content slds-hide'; 
    @track howCont = 'slds-tabs--default__content slds-hide';  

    tabClassActive = 'slds-tabs--default__item slds-active';
    tabClassInactive = 'slds-tabs--default__item';
    contentClassShow = 'slds-tabs--default__content slds-show';
    contentClassHide = 'slds-tabs--default__content slds-hide';

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