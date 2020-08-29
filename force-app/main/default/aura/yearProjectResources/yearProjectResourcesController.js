({
	doInit: function(component, event, helper) {
        
        component.set("v.removeFinishedProjects", true);
        
        helper.getAccounts(component);
        
    },
    activeProjects: function(component, event, helper){
       	component.set("v.ready", false);
        var checked = event.getSource().get("v.checked");
        component.set("v.removeFinishedProjects", checked);
        
        helper.getDataToShow(component);
    },
    forecastedProjects: function(component, event, helper){
       	component.set("v.ready", false);
        var checked = event.getSource().get("v.checked");
        component.set("v.forecastedProjects", checked);
        
        helper.getDataToShow(component);
    },
    byAccounts: function(component, event, helper){
       	var checked = event.getSource().get("v.checked");
        component.set("v.auxName",  event.getSource().get("v.value"));
        if (checked){
            helper.addAccounts(component);
        }else{
            helper.removeAccounts(component);
        }
    },
})