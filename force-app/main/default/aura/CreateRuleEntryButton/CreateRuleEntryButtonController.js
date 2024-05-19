({
    init : function(component, event, helper) {

        var ref = component.get("v.pageReference");
        var state = ref.state; 
        var context = state.inContextOfRef;
        if (context.startsWith("1\.")) {
            context = context.substring(2);
            var addressableContext = JSON.parse(window.atob(context));
            console.log('addressableContext----->'+JSON.stringify(addressableContext));   // you can get your recordId and other things here.
            const ruleId = addressableContext.attributes.recordId;
            console.log(addressableContext.attributes.recordId);
            component.set('v.ruleId', ruleId);
        }

        // const getAllObjectsAction = component.get('c.getAllObjects');

        // getAllObjectsAction.setCallback(this, function(response) {
        //     const state = response.getState();

        //     switch (state) {
        //         case 'SUCCESS':
        //             const returnValue = JSON.parse( response.getReturnValue() );
        //             component.set('v.optionsObjects', returnValue);
        //             break;
                
        //         case 'INCOMPLETE':
        //             console.warn('INCOMPLETE');
        //             console.warn(JSON.parse(JSON.stringify(response)));
        //             break;

        //         case 'ERROR':
        //             const errors = response.getError();
        //             if (errors) {
        //                 if (errors[0] && errors[0].message) {
        //                     console.warn("Error message: " + 
        //                             errors[0].message);
        //                 }
        //             } else {
        //                 console.log("Unknown error");
        //             }
        //             break;
                
        //         default:
        //             console.warn('SOMETHING WRONG');
        //             break;
        //     }
        // });

        // $A.enqueueAction(getAllObjectsAction);
    },

    // Methods FORM
    handleSubmit: function(component, event, helper) {
        event.preventDefault();
        const fields = event.getParam('fields');
        fields.Rule__c = component.get('v.ruleId');
        component.find('ruleEntryRecordEditForm').submit(fields);
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
                "objectApiName":"RuleEntry__c"
            }
        };

        navService.navigate(pageReference);
    }

    , handleCancel: function(component, event, helper) {
        const urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/" + component.get('v.ruleId')
        });
        urlEvent.fire();
    }
})
