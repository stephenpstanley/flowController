({
    doInit : function(cmp, event, helper) {
        helper.getFlows(cmp);
    },
    handleToggleSelectedFlows : function(cmp, event, helper){
        helper.showLoading(cmp);
        let flows = cmp.get("v.selectedFlows");
        console.log(flows);
        if (flows && flows.length > 0){
            let promises = [];
            flows.forEach(function(row) {
                promises.push(helper.updateFlowPromise(cmp, row));
            });
            Promise.all(promises).then(function(results){
                console.log(results);
                helper.getFlows(cmp);
                helper.hideLoading(cmp);
            });
        }
        helper.handleShowToast("Successfully toggled. Activated Flows have activated the LATEST Flow version")
    },
    handleEnableAllFlows : function(cmp, event, helper){
        var flowsToActivate = false;
        helper.showLoading(cmp);
        let flows = cmp.get("v.flows");
        if (flows && flows.length > 0) {
            let promises = [];
            flows.forEach(function (row) {
                if (row.Active == false) {
                    promises.push(helper.updateFlowPromise(cmp, row));
                    flowsToActivate = true;
                }
            });
            Promise.all(promises).then(function (results) {
                console.log(results);
                helper.getFlows(cmp);
                helper.hideLoading(cmp);
            });
        }
        if (flowsToActivate) {
            helper.handleShowToast("ALL newly activated Flows are using the LATEST Flow version");
        } else {
            helper.handleShowToast("Warning: All Flows are already active");
        }
    },
    handleDisableAllFlows : function(cmp, event, helper){
        var flowsToDisable = false;
        helper.showLoading(cmp);
        let flows = cmp.get("v.flows");
        if (flows && flows.length > 0){
            let promises = [];
            flows.forEach(function(row) {
                if (row.Active) {
                    promises.push(helper.updateFlowPromise(cmp, row));
                    flowsToDisable = true;
                }
            });
            Promise.all(promises).then(function(results){
                console.log(results);
                helper.getFlows(cmp);
                helper.hideLoading(cmp);
            });
        }
        if (flowsToDisable) {
            helper.handleShowToast("ALL Flows have been disabled");
        } else {
            helper.handleShowToast("Warning: All Flows are already disabled");
        }
    },
    handleSaveFlowState : function (cmp, event, helper){
        helper.showLoading(cmp);
        helper.saveFlowStatus(cmp);
        helper.hideLoading(cmp);
    },
    handleRetrieveFlowState : function (cmp, event, helper){
        helper.showLoading(cmp);
        helper.retrieveFlowStatus(cmp);
        helper.hideLoading(cmp);
    },
    handleApplyFlowState: function (cmp, event, helper){
        helper.showLoading(cmp);
        let flows = cmp.get("v.flows");
        if (flows && flows.length > 0){
            let promises = [];
            flows.forEach(function(row){
                // use the fact that the toggle function reverses the current state so reverse the
                // recorded state and pass it to the toggle function
                // Also set the latestFLowVersion parameter to the retrieved active value as this is the version that gets reactivated
                row.Active = !row.Active;
                row.LatestVersionNumber = row.ActiveVersionNumber;
                promises.push(helper.updateFlowPromise(cmp, row));
            });
            Promise.all(promises).then(function(results){
                console.log(results);
                helper.getFlows(cmp);
                helper.hideLoading(cmp);
            });
            helper.handleShowToast("Successfully Applied displayed State. Activated Flows have activated the SAVED Flow version")
        }
    },

    handleRowSelection : function(cmp, event, helper){
        let flows = event.getParam('selectedRows');
        console.log(flows);
        cmp.set("v.selectedFlows", flows);
    },
    handleRowAction: function(cmp, event, helper) {
        var action = event.getParam('action');
        if (action.name =='change_status') {
            var row = event.getParam('row');
            console.log('Logging the row data');
            console.log(JSON.stringify(row));
            helper.updateFlow(cmp, row);
            helper.handleShowToast("Successfully toggled. Activated Flow has activated the LATEST Flow version")
        }
    }
})
