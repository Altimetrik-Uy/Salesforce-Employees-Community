import {LightningElement, api, wire, track} from 'lwc';
import strUserId from '@salesforce/user/Id';
import TrafficLightGreen from '@salesforce/resourceUrl/TrafficLightGreen';
import TrafficLightRed from '@salesforce/resourceUrl/TrafficLightRed';
import TrafficLightYellow from '@salesforce/resourceUrl/TrafficLightYellow';
import TrafficLightBalck from '@salesforce/resourceUrl/TrafficLightBlack';
import getProjectStatusImageName from '@salesforce/apex/LWCEmployeeOverallController.getProjectStatusImageName';
import getStatusImageName from '@salesforce/apex/LWCEmployeeOverallController.getStatusImageName';

export default class EmployeeOverallSubtab extends LightningElement {
    @api employeeId;
    @track userId = strUserId;
    @track error;
    @track projectStatusImageName;
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
            TrafficLight = TrafficLightRed;
            preparedAsset.AssetImageAlt = data;
                switch(data){
                    case 'Red':
                        TrafficLight = TrafficLightRed;
                        break;
                    case 'Yellow':
                        TrafficLight = TrafficLightYellow;
                        break;
                    case 'Green':
                        TrafficLight = TrafficLightGreen;
                        break;
                    case 'Black':
                        TrafficLight = TrafficLightBalck;
                        break;
                }
            preparedAsset.AssetImageAlt = data;
            preparedAsset.AssetImageSrc = TrafficLight;
            preparedAssets.push(preparedAsset);
            this.imageStatus = preparedAssets;
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
                        TrafficLight = TrafficLightRed;
                        break;
                    case 'Yellow':
                        TrafficLight = TrafficLightYellow;
                        break;
                    case 'Green':
                        TrafficLight = TrafficLightGreen;
                        break;
                }
                preparedAsset.ProjectImageSrc = TrafficLight;
                preparedAssets.push(preparedAsset);
            });
            this.projectStatusImageName = preparedAssets;
            window.console.log(JSON.stringify(this.assets));
        } else if (error) {
            this.error = error;
        }
    }
}