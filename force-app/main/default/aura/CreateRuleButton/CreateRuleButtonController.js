({
    init : function(component, event, helper) {
        const getAllObjectsAction = component.get('c.getAllObjects');

        getAllObjectsAction.setCallback(this, function(response) {
            const state = response.getState();

            switch (state) {
                case 'SUCCESS':
                    const returnValue = JSON.parse( response.getReturnValue() );
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
        event.preventDefault();
        const fields = event.getParam('fields');
        fields.Object__c = component.get('v.objectSelected');
        component.find('ruleRecordEditForm').submit(fields);
    }

    , handleSuccess : function(component,event,helper) {
        const record = event.getParams();  
        const recordId = record.response.id;

        const navService = component.find("navService");        
        var pageReference = {
            "type": 'standard__recordPage',         
            "attributes": {              
                "recordId": recordId,
                "actionName": "view",
                "objectApiName":"Rule__c"
            }        
        };

        navService.navigate(pageReference);
    }

    , handleCancel: function(component, event, helper) {
        const urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/o/Rule__c/list"
        });
        urlEvent.fire();
    }
})
