({
    init : function(component, event, helper) {
        // TODO: Check if can we use Schema.getGlobalDescribe() to set in attribute v.options
        const getAllObjectsAction = component.get('c.getAllObjects');

        getAllObjectsAction.setCallback(this, function(response) {
            const state = response.getState();

            switch (state) {
                case 'SUCCESS':
                    console.log('SUCCESS');
                    const returnValue = JSON.parse( response.getReturnValue() );
                    console.log('returnValue');
                    console.log(returnValue);
                    component.set('v.optionsObjects', returnValue);
                    break;
                
                case 'INCOMPLETE':
                    console.warn('INCOMPLETE');
                    console.warn(JSON.parse(JSON.stringify(response)));
                    break;

                case 'ERROR':
                    const errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.warn("Error message: " + 
                                    errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    break;
                
                default:
                    console.warn('SOMETHING WRONG');
                    break;
            }
        });

        $A.enqueueAction(getAllObjectsAction);
    },

    // Methods FORM
    handleSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        fields.Object__c = component.get('v.objectSelected');
        component.find('ruleRecordEditForm').submit(fields);
    }
    // handleSuccess: function(component, event) {
    //     var updatedRecord = JSON.parse(JSON.stringify(event.getParams()));
    //     console.log('onsuccess: ', updatedRecord.id);
    //     // Navigate to record here.
    // }
})
