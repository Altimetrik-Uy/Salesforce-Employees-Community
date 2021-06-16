({
	doInit : function(component, event, helper) {
        
        var actions = helper.getRowActions.bind(this, component);

		component.set('v.columns', [
            {label: 'Status', sortable: true, initialWidth: 75,  fieldName: 'status', type: 'text', cellAttributes: { class: { fieldName: 'status' } } },
            {label: 'Employee', sortable: true, fieldName: 'employeeId', type: 'url', typeAttributes: { label: { fieldName: 'employee' }}},
            {label: 'Last Update', sortable: true, fieldName: 'lastdate', type: 'date'},
            { type: 'action', fieldName: 'Id', typeAttributes: { rowActions: actions } }
        ]);
        
        let retrieveEmployees = component.get('c.getEmployeeWithLastStatus');
        retrieveEmployees.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    if( record.id == '' ){
                        record.Id = '';
                    }else{
                        record.Id = record.id;
                    }
                    record.employeeId = '/' + record.employeeId;
                });
                
                component.set('v.data', records );
            } else {
                console.error(reponse.getError());
            }
        });
        
        $A.enqueueAction(retrieveEmployees);
        
        var overlayPanel = component.get('v.overlayPanel');
        if (typeof overlayPanel[0] !== 'undefined') {
            overlayPanel[0].close();   
        }
	},
    
    handleShowModal: function(component, event, helper) {
        helper.showModal(component, event);
    },
    
    //Method gets called by onsort action,
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