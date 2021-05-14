import {LightningElement, api, wire, track} from 'lwc';
import strUserId from '@salesforce/user/Id';
import getProjectStatusImageName from '@salesforce/apex/LWCEmployeeOverallController.getProjectStatusImageName';
import getStatusImageName from '@salesforce/apex/LWCEmployeeOverallController.getStatusImageName';

export default class EmployeeOverallSubtab extends LightningElement {
    @api employeeId;
    @track userId = strUserId;
    @track error;
    @track imageStatus;
    @track statusTableColumns = [
        { label: 'Profile Pic', fieldName: 'AssetImageSrc', type:'image'},
        { label: 'alt', fieldName: 'AssetImageAlt'},
    ];
    @track projectStatusImageName;
    @track rolesWrapper;
    @track projectStatusImageNameTableColumns = [ 
        { fieldName: 'ProjectName' },
        { fieldName: 'ProjectImageSrc', type:'image' },
        { fieldName: 'ProjectImageAlt' }
    ];
    @track imageStatus;
    @track statusTableColumns = [
        { label: 'Profile Pic', fieldName: 'AssetImageSrc', type:'image'},
        { label: 'alt', fieldName: 'AssetImageAlt'},
    ];

    @wire(getStatusImageName,{uId: '$userId'}) wiredImage({error,data}){
        let TrafficLight;
        let id = 0;
        if (data) {
            this.imageStatus = data;
            let preparedAssets = [];
            let preparedAsset = {};
            preparedAsset.Id = id;
            preparedAsset.AssetImageAlt = data;
                switch(data){
                    case 'Red':
                        TrafficLight = 'Red';
                        break;
                    case 'Yellow':
                        TrafficLight = 'Yellow';
                        break;
                    case 'Green':
                        TrafficLight = 'Green';
                        break;
                    case 'Black':
                        TrafficLight = 'Black';
                        break;
                }
            preparedAsset.AssetImageAlt = data;
            preparedAsset.AssetImageSrc = TrafficLight;
            preparedAssets.push(preparedAsset);
            this.imageStatus = preparedAssets;
            const employeeStatusEvent = new CustomEvent('estatus', {
                detail: preparedAssets
            });
            this.dispatchEvent(employeeStatusEvent);
        } else if (error) {
            this.error = error;
        }
    }
    
    @wire(getProjectStatusImageName,{uId: '$userId'}) wiredProjectStatusImageName({error,data}){
        if (data) {
            this.projectStatusImageName = data;
            let preparedAssets = [];
            let TrafficLight;
            let id = 0;
            this.projectStatusImageName.forEach(asset => {
                let preparedAsset = {};
                preparedAsset.Id = id++;
                preparedAsset.ProjectName = asset.Project__r.Name;
                preparedAsset.ProjectImageAlt = asset.Status__c;
                switch(asset.Status__c){
                    case 'Red':
                        TrafficLight = 'Red';
                        break;
                    case 'Yellow':
                        TrafficLight = 'Yellow';
                        break;
                    case 'Green':
                        TrafficLight = 'Green';
                        break;
                }
                preparedAsset.ProjectImageSrc = TrafficLight;
                preparedAssets.push(preparedAsset);
            });
            this.projectStatusImageName = preparedAssets;
            const projectStatusEvent = new CustomEvent('pstatus', {
                detail: preparedAssets
            });
            this.dispatchEvent(projectStatusEvent);
        } else if (error) {
            this.error = error;
        }
    }   

    handleGoToCPath(event){
        const goToCPath = new CustomEvent(
            'gotocpath', {
            detail: event.target.value
        });
        this.dispatchEvent(goToCPath);
    }

}