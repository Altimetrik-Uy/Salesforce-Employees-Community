import {LightningElement, api, wire, track} from 'lwc';
import strUserId from '@salesforce/user/Id';
import TrafficLightGreen from '@salesforce/resourceUrl/TrafficLightGreen';
import TrafficLightRed from '@salesforce/resourceUrl/TrafficLightRed';
import TrafficLightYellow from '@salesforce/resourceUrl/TrafficLightYellow';
import getProjectStatusImageName from '@salesforce/apex/LWCEmployeeOverallController.getProjectStatusImageName';

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