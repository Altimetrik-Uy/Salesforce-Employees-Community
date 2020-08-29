({
    getStatusPicklist: function(component, event) {
        var action = component.get("c.getStatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                let statusMap = [];
                for(let key in result){
                    statusMap.push({label: result[key], value: key});
                }
                component.set("v.statusMap", statusMap);
            }
        });
        $A.enqueueAction(action);
    },
    showToast : function(type, title, message){
        var toastEvent = $A.get("e.force:showToast");
        if (!$A.util.isUndefinedOrNull(toastEvent)) {
            toastEvent.setParams({
                "title" : title,
                "type" : type,
                "message" : message,
                "mode" : "dismissible ",
                "duration" : 3000
            });
            toastEvent.fire();
        } else {
            console.log('CUSTOM TOAST..TITLE :  ',title);
            console.log('CUSTOM TOAST..message :  ',message);
        }
        
    },
    validateForm : function(component) {
        var allValid = component.find('inputField').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);

        if (typeof component.get('v.selectedId') == 'undefined') {
			component.set('v.projectError', true);
			component.set('v.projectErrorComment', 'Complete this field.');
            allValid = false;
        }

        return allValid; 
    },
    resetForm : function(component) {
        component.set('v.projectStatus',{'sobjectType':'Project_Status__c', 
                                         'Project__c': '',
                                         'Sub_Project__c': '',
                                         'Status__c': '',
                                         'Comments__c': '',
                                         'Meeting_Date__c': ''});
        component.set('v.selectedId', '');
        component.set('v.selectedSubPId', '');
        component.set('v.projectError', false);
        component.set('v.projectErrorComment', '');
        component.set('v.status', '');
        component.set('v.comments', '');
        component.set('v.meetingDate', '');
    }
})