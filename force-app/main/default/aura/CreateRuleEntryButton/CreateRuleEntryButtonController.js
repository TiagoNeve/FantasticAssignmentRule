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
        
        // Set the Logic default right now
        console.log('fields');
        console.log(fields);
        const criterias = component.get('v.criterias');
        const criteriaAtualizado = JSON.parse(JSON.stringify( criterias ));
        console.log( criteriaAtualizado );
        fields.Criteria__c = JSON.stringify(criteriaAtualizado);

        let logic = '1 ';
        criterias.forEach((criteria, idx) => {
            if (idx != 0) {
                logic += 'AND ' + (idx + 1);
            }
        });

        console.log('logic');
        console.log(logic);

        fields.Logic__c = logic;

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

    , handleAddNewCriteria: function(component, event, helper) {
        const criterias = component.get('v.criterias');

        var newObjectDeserializado = {};
        newObjectDeserializado.field = '';
        newObjectDeserializado.operation = '';
        newObjectDeserializado.value = '';

        console.log(criterias[0]);
        
        criterias.push( newObjectDeserializado );
        
        console.log('criterias');
        console.log( criterias );

        component.set('v.criterias', criterias);
    }

    , handleRemoveLastCriteria: function(component, event, helper) {
        const criterias = component.get('v.criterias');
        criterias.pop();
        component.set('v.criterias', criterias);
    }
})