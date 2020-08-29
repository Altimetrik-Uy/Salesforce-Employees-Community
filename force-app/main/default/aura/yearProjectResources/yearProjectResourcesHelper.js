({
	getDataToShow: function(component) {
       
        var action = component.get("c.yearProgressT");
        action.setParams({  removeFinishedProjects : component.get("v.removeFinishedProjects"), forecastedProjects : component.get("v.forecastedProjects"), accounts: component.get("v.selectedAccounts")  });

        action.setCallback(this, function(response) {
            
            var today = new Date();
            var currentDate = String(today.getMonth() + 1).padStart(2, '0') + '-' + String(today.getFullYear());
            component.set("v.currentDate", currentDate);
            var state = response.getState();
            
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                let dataMap = []; // totals
                let dataMapByProject = []; //byproject
                let dataMapByProjectFuture = []; //future project
                for(let key in result[0]){
                    let innerDataMap = [];
                    
                    for (let key1 in result[0][key]){
                        innerDataMap.push({label: result[0][key][key1], value: key1, futureLabel:result[3][key][key1]});
                    }
                    
                    dataMap.push({label: innerDataMap, value: key});
                }
                component.set("v.dataMap", dataMap);
                for(let key in result[1]){
                    let innerDataMap = [];
                    for (let key1 in result[1][key]){
                        innerDataMap.push({label: result[1][key][key1], value: key1, futureLabel: 0+result[1][key][key1]+result[2][key][key1]});
                    }
                    
                    dataMapByProject.push({label: innerDataMap, value: key});
                }
                component.set("v.dataMapByProject", dataMapByProject);
                component.set("v.ready", true);
                
            }
        });
        $A.enqueueAction(action);
    },
    getAccounts: function(component){
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(response) {
        	var state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                component.set("v.accounts", result);
                component.set("v.selectedAccounts", result);
                this.getDataToShow(component);
            }
        });
        $A.enqueueAction(action);
    },
    addAccounts: function(component){  
        var name = component.get("v.auxName");
        var l = component.get("v.selectedAccounts");
        if (l.indexOf(name) == -1){
            l.push(name); 
            component.set("v.selectedAccounts", l);
        	this.getDataToShow(component);
        }
        
        
    },
    removeAccounts: function(component){     
        var name = component.get("v.auxName");
        var l = component.get("v.selectedAccounts");
        var index = l.indexOf(name);
        while (index != -1){  
            l.splice(index, 1);
            index = l.indexOf(name); 
        }
        
        component.set("v.selectedAccounts", l);

        this.getDataToShow(component);
    }
})