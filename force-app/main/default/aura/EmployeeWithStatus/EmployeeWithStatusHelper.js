({
    sortData : function(component,fieldName,sortDirection){
        var data = component.get('v.data');
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;

        data.sort(function(a,b){ 
            var a = key(a) ? key(a).toLowerCase() : '';
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a>b) - (b>a));
        });    
        component.set('v.data',data);
    },
    
    showModal : function(component, event) {
        var modalBody;
        
        var row = event.getParam('row');

        var params = {};
        if (row != null) {
        	params["selectedId"] = row.employeeId;
        }

        $A.createComponent("c:AddEmployeeStatus", params,
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       body: modalBody,
                       showCloseButton: true,
                       closeCallback: function() {}
                   }).then(function (overlay) {
                       component.set('v.overlayPanel', overlay);
                   });
               }
           });
    },
    
    getRowActions: function( component, row, cb ) {
        var actions = [];
        actions.push( { label: 'Add', name: 'add' } );
        actions.push( { label: 'View', name: 'view', disabled: row.Id == '' } );
        cb( actions );
    }
})