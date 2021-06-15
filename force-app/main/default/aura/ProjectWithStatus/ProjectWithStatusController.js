({
	doInit : function(component, event, helper) {

        var actions = helper.getRowActions.bind(this, component);

		component.set('v.columns', [
            {label: 'Status', sortable: true, initialWidth: 75,  fieldName: 'status', type: 'text', cellAttributes: { class: { fieldName: 'status' } } },
            {label: 'Project', sortable: true, fieldName: 'projectId', type: 'url', typeAttributes: { label: { fieldName: 'project' }}},
            {label: 'Sub Project', sortable: true, fieldName: 'subProject', type: 'text'},
            {label: 'Last Update', sortable: true, fieldName: 'lastdate', type: 'date'},
            { type: 'action', fieldName: 'Id', typeAttributes: { rowActions: actions } }
        ]);
        
        let retrieveProjects = component.get('c.getProjectWithLastStatus');
        retrieveProjects.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                var records =response.getReturnValue();
                console.log('==== records ', records);
                records.forEach(function(record){
                    if( record.id == '' ){
                        record.Id = '';
                    }else{
                        record.Id = record.id;
                    }
                });
                for(var i=0; i<records.length; i++) {
                    records[i].projectId = '/' + records[i].projectId;
                }
                component.set('v.data', records );
            } else {
                console.error(reponse.getError());
            }
        });
        
        $A.enqueueAction(retrieveProjects);
        
        var overlayPanel = component.get('v.overlayPanel');
        if (typeof overlayPanel[0] !== 'undefined') {
            overlayPanel[0].close();   
        }
	},
    
    handleShowModal: function(component, event, helper) {
        helper.showModal(component, event);
    },

    handleSort : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        helper.sortData(component,sortBy,sortDirection);
    },
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'add':
                helper.showModal(component, event);
            break;
            case 'view':
                if( row.Id == '' || row.Id == undefined ){
                	helper.showModal(component, event);
                }else{
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": row.Id,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }
            break;
        }
    }
})