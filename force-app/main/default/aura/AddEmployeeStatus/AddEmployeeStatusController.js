({
    doInit: function(component, event, helper) {        
        helper.getStatusPicklist(component, event);
        helper.getCertificationStatusPicklist(component, event);
    },
    handleEmployeeStatus : function(component, event, helper) {
        event.preventDefault();
        let validForm = helper.validateForm(component);
        
        if (validForm) {
            let employee = component.get('v.selectedId');
            let status = component.get('v.status');
            let comments = component.get('v.comments');
            let redReason = component.get('v.redReason');
            let certificationStatus = component.get('v.certificationStatus');
            let certificationComments = component.get('v.certificationComments');
            
            let newEmployeeStatusAction = component.get('c.createEmployeeStatus');
            newEmployeeStatusAction.setParams({
                employee : employee,
                status : status,
                comments : (typeof comments !== 'undefined') ? comments : '',
                redReason : (typeof meetingDate !== 'undefined') ? meetingDate : '',
                certStatus: (typeof certificationStatus !== 'undefined') ? certificationStatus : '',
                certComments: (typeof certificationComments !== 'undefined') ? certificationComments : ''
            });
            
            newEmployeeStatusAction.setCallback(this, function(response) {
                
                let state = response.getState();
                
                if (state === 'SUCCESS') {
                    helper.showToast('success', 'Employee Status', 'Created');
                    
                    helper.resetForm(component);
                    
                    var compEvent = $A.get("e.c:EmployeeStatusEvent");
                    compEvent.fire();
                } else {
                    console.log('Error');
                    helper.showToast('error', 'Something happened', JSON.stringify(response.getError()[0].message));
                }
            });
            
            $A.enqueueAction(newEmployeeStatusAction);
        }
    }
})