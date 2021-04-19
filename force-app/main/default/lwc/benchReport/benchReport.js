import { LightningElement,track } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';
const columns = [
    '' ,
    '12-Feb',
    '19-Feb',
    '26-Feb',
    '5-Mar',
];
export default class BechReport extends LightningElement {
    data = [];
    columns = columns;
    @track employees = [{ Name: 'Iron man', Position__c: 'Lead'}, 
    { Name: 'Black Widow', Position__c: 'Salesforce Dev'},
    { Name: 'Hawk eye', Position__c: 'Salesforce Dev'},
    { Name: 'Capitan America', Position__c: 'Salesforce Dev'},
    { Name: 'Spider man', Position__c: 'QA'},
    { Name: 'Hulk', Position__c: 'Designer'},
    { Name: 'Thor', Position__c: 'Android Dev'}];
    @track isModalOpen = false;

   appResources = {
      employeeSilhouette: `${assets}/img/noimage.jpg`,
    };

    selectDay(event){
      this.isModalOpen = true;
    }
    openModal() {
      // to open modal set isModalOpen tarck value as true
      this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    async connectedCallback() {
        this.data={
            "columns":['','12-Feb','19-Feb','26-Feb','5-Mar'],
            "calendar" :  [ 
            {
                "Project": "Overall Non Billed Opening Count",
                "Id":"10",
                "Days" :[
                    {"Id":"date1+proyect","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect","dataFound":false, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect","dataFound":false, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
            },
            {
                "Project": "WFB Opening Count",
                "Id":"20",
                "Days" :[
                    {"Id":"date1+proyect2","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect2","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect2","dataFound":false, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect2","dataFound":false, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "WFB to Billed",
                "Id":"30",
                "Days" :[
                    {"Id":"date1+proyect3","dataFound":false, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect3","dataFound": true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect3","dataFound":false, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect3","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "WFB Closing Count",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "BU Investment Opening Count",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "BU Investment to Billed",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "BU Investment Closing Count",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },

              {
                "Project": "Corp Bench Opening Count",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "Corp Bench Deployment",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "Roll Off (Billed to Bench)",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "Roll Off Deployed",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "Corp Bench Closing Count",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
              {
                "Project": "Overall Non Billed Closing Count",
                "Id":"40",
                "Days" :[
                    {"Id":"date1+proyect4","dataFound":true, "date":"12-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date2+proyect4","dataFound":true, "date":"19-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date3+proyect4","dataFound":true, "date":"26-02-2021","employees":["id1","id2","id3"]},
                    {"Id":"date4+proyect4","dataFound":true, "date":"05-03-2021","employees":["id1","id2","id3"]}
                ]
              },
            
            ]};
    }

    
}