import { LightningElement, api } from 'lwc';

const ACTIVE_CLASS = ' slds-is-active';
const NAV_ITEM_CLASS = 'slds-vertical-tabs__nav-item';


export default class CareerPathTab extends LightningElement {
    @api employeeid;

    selectedTab = 'linkdetails';
    detailsTab = NAV_ITEM_CLASS  + ACTIVE_CLASS;
    certificationsTab = NAV_ITEM_CLASS;
    salaryTab = NAV_ITEM_CLASS;

    openTab(event) {
        this.setSelectedTab (event.currentTarget.name);
        console.log (event.currentTarget);
        console.log (this.selectedTab);
    }

    get isDetailsSelected(){
        return (this.selectedTab == 'linkdetails');
    }

    get isCertificationsSelected(){
        return (this.selectedTab == 'linkcertifications');
    }

    get isSalarySelected(){
        return (this.selectedTab == 'linksalary');
    }

    setSelectedTab (tabId) {
        this.selectedTab = tabId;
        this.detailsTab = NAV_ITEM_CLASS;
        this.certificationsTab = NAV_ITEM_CLASS;
        this.salaryTab = NAV_ITEM_CLASS;
        switch(tabId) {
            case 'linkcertifications':
                this.certificationsTab += ACTIVE_CLASS;
              break;
            case 'linksalary':
                this.salaryTab += ACTIVE_CLASS;
              break;
            default:
                this.detailsTab +=  ACTIVE_CLASS;
          }
    }
}