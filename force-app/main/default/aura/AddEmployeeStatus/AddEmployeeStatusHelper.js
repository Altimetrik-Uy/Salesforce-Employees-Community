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
    getCertificationStatusPicklist: function(component, event) {
        var action = component.get("c.getCertificationStatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                let statusMap = [];
                for(let key in result){
                    statusMap.push({label: result[key], value: key});
                }
                component.set("v.certificationStatusMap", statusMap);
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
        component.set('v.employeeStatus',{'sobjectType':'Employee_Status__c',
                                          'Employee': '',
                                          'Status__c': '',
                                          'Comments__c': '',
                                          'Red_Reason__c ': '',
                                          'Certification_Status__c': '',
                                          'Certification_Comments__c': ''});
        component.set('v.selectedId', '');
        component.set('v.projectError', false);
        component.set('v.projectErrorComment', '');
        component.set('v.status', '');
        component.set('v.comments', '');
        component.set('v.redReason', '');
        component.set('v.certificationStatus', '');
        component.set('v.certificationComments', '');
    }
})