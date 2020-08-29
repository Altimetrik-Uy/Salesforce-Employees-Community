({
    doInit: function(component, event, helper) {
        helper.getStatusPicklist(component, event);
        console.log('======== init ',component.get('v.selectedSubPId'));
    },
    handleProjectStatus : function(component, event, helper) {
        event.preventDefault();
        let validForm = helper.validateForm(component);
        
        if (validForm) {
            let project = component.get('v.selectedId');
            let subproject = component.get('v.selectedSubPId');
            console.log('======== subproject = ', subproject);
            let status = component.get('v.status');
            let comments = component.get('v.comments');
            let meetingDate = component.get('v.meetingDate');
            
            let newProjectStatusAction = component.get('c.createProjectStatus');
            newProjectStatusAction.setParams({
                project : project,
                subProject : subproject,
                status : status,
                comments : (typeof comments !== 'undefined') ? comments : '',
                meetingDate : (typeof meetingDate !== 'undefined') ? meetingDate : ''
            });
            
            newProjectStatusAction.setCallback(this, function(response) {
                
                let state = response.getState();
                
                if (state === 'SUCCESS') {
                    helper.showToast('success', 'Project Status', 'Created');
                    
                    helper.resetForm(component);
                    
                    var compEvent = $A.get("e.c:ProjectStatusEvent");
                    compEvent.fire();
                } else {
                    helper.showToast('error', 'Something happened', JSON.stringify(response.getError()[0].message));
                }
            });
            
            $A.enqueueAction(newProjectStatusAction);
        }
    }
})