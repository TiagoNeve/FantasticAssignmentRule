({
    search: function(component, event, helper) {
        var objectName = component.get("v.objectName");
        var searchString = component.get("v.searchString");

        console.log('searchString');
        console.log(searchString);

        if (searchString.length > 0) {
            var action = component.get("c.searchRecords");
           console.log("Search Records: ", action);
            action.setParams({
                objectName: objectName,
                searchString: searchString
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.records", response.getReturnValue());
                    console.log("Returned "+ objectName +": ", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.records", []);
            console.log("Cleared records");
        } 
    },
    
    
    clearSearch: function(component, event, helper) {
        console.log("Clear search function called");
        component.set("v.searchString", "");
        console.log("Search string cleared: " + component.get("v.searchString"));
        component.set("v.records", []);
        console.log("Records cleared: " + component.get("v.records"));
        
    },

    selectRecord: function(component, event, helper) {
        var selectedRecordId = event.currentTarget.dataset.record;
        var records = component.get("v.records");

        var selectedRecord = records.find(function(record) {
            console.log('selectRecord@@:  '+record.Id);
            return record.Id === selectedRecordId;
        });

        component.set("v.selectedRecord", selectedRecord);
        component.set("v.searchString", selectedRecord.Name);
        component.set("v.records", []);
    },

    clearSelectedRecord: function(component, event, helper) {
        component.set("v.selectedRecord", null);
        component.set("v.searchString", "");
    }
    
})