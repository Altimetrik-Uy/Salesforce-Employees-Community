import { LightningElement,api, track } from 'lwc';
import { loadScript,loadStyle} from 'lightning/platformResourceLoader';
import apexchjs from '@salesforce/resourceUrl/apexcharts';
export default class Radialcharts extends LightningElement {
    @track loadintialize = false;
    librariesLoaded =false;
    initializeLib =false;
    @track seriesValue =[];
    @track chartt;
    @api rolesWrapper;
    isFirstTime = true;
 
    connectedCallback(){
        this.seriesValue.push(75);
      }
    renderedCallback(){
        if(this.initializeLib){
            return;
        }
        this.initializeLib=true;
        Promise.all([
            loadScript(this, apexchjs + '/dist/apexcharts.min.js'),
            loadScript(this, apexchjs + '/dist/apexcharts.js'),                
            loadStyle(this, apexchjs +'/dist/apexcharts.css'),
        ]) 
        .then(() =>{
            this.loadchart();
        })
        .catch(error =>{
            console.log('--error--:', error);
        })
    }
    
    loadchart(){
          this.isFirstTime = false;
          var role;
          var porcentaje = 0;
          if(this.rolesWrapper){
            if(this.rolesWrapper.isCurrent){
              porcentaje = Math.trunc(this.rolesWrapper.porcentaje);                        
              role = [this.rolesWrapper.role];
              
            }
            else{
              porcentaje = Math.trunc(this.rolesWrapper.porcentaje);                        
              role = this.rolesWrapper.role;                        
            }
          }         
          
          var options = {
            series: [porcentaje],
            chart: {
            id: role,
            height: 180,
            type: 'radialBar',
          },
          plotOptions: {
            radialBar: {
              dataLabels: {
                name: {
                  fontSize: '15px',
                  offsetY: 85,
                  color: '#1589EE',
                },
                value: {
                  offsetY: -12,
                  fontSize: '16px',
                  color: '#1589EE',
                  fontWeight: 'bold',
                }
              },
              hollow: {
                size: '60%',
              },
            },
          },
          labels: [role],
          };
          const ctx = this.template.querySelector('div.chart');
          this.chartt = new ApexCharts(ctx, options);
          this.chartt.render();
          this.chartt= ApexCharts.exec(role, 'updateSeries', [
            porcentaje
         ], true);
    }
}