({
    showLoading : function(cmp){
        cmp.set("v.loading", true);
    },
    hideLoading : function(cmp){
        cmp.set("v.loading", false);
    },
    getFlows : function(cmp) {
        this.callAction(cmp, 'c.getFlows', null, function(results) {
            if (results == null) return;
            let data = JSON.parse(results);
            let records = data.records;
            if (records && records.length > 0) {
                records.forEach(function(r){
                    if (r.ActiveVersion){
                        r.ActiveVersionNumber = r.ActiveVersion.VersionNumber;
                        r.Active = true;
                    } else {
                        r.ActiveVersionNumber = null;
                        r.Active = false;
                    }
                    r.LatestVersionNumber = r.LatestVersion.VersionNumber;
                });
            }
            cmp.set("v.flows", records);
        });
    },
    retrieveFlowStatus : function(cmp) {
        let self = this;
        this.callAction(cmp, 'c.retrieveFlowStatus', null, function(results) {
            if (results == null) {
                var msg = "There is no saved Flow State.  You must save state before attempting retrieval"
                console.log(msg)
                self.handleShowToast(msg);
                return;
            }
            if (results.startsWith("Error")) {
                console.log(results)
                self.handleShowToast(results);
                return;
            }
            let data = JSON.parse(results);
            let records = data.records;
            if (records && records.length > 0) {
                records.forEach(function(r){
                    if (r.ActiveVersion){
                        r.ActiveVersionNumber = r.ActiveVersion.VersionNumber;
                        r.Active = true;
                    } else {
                        r.ActiveVersionNumber = null;
                        r.Active = false;
                    }
                    r.LatestVersionNumber = r.LatestVersion.VersionNumber;
                });
            }
            cmp.set("v.flows", records);
            self.handleShowToast("Successfully retrieved. Remember to Apply Displayed State")
        });
    },
    saveFlowStatus : function(cmp){
        let self = this;
        this.callAction(cmp, 'c.saveFlowStatus', null, function(result){
            console.log(result);
            if (result == true) {
                self.getFlows(cmp);
                self.handleShowToast("Flow state successfully saved")
            }
        })
    },
    updateFlow : function(cmp, row){
        let self = this;
        let params = this.getParams(row);
        this.callAction(cmp, 'c.updateFlow', params, function(result){
            console.log(result);
            if (result == true) self.getFlows(cmp);
        })
    },
    updateFlowPromise : function(cmp, row){
        let params = this.getParams(row);
        console.log('Row: ' , JSON.stringify(row));
        return this.promiseAction(cmp, 'c.updateFlow', params);
    },
    getParams : function(row){
        let flowId = row.Id;
        let versionNumber = row.LatestVersionNumber;
        if (row.Active) versionNumber = null;
        let metadata = {
            'Metadata': {
                'activeVersionNumber': versionNumber
            }
        }
        let params = {};
        params.flowId = flowId;
        params.metadata = JSON.stringify(metadata);
        return params;
    },
    promiseAction : function(cmp, methodName, params){
        console.log(methodName);
        console.log(params);
        var self = this;
        return new Promise(function(resolve, reject) {
            var action = cmp.get(methodName);
            if (params != null) action.setParams(params);
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(methodName + ' ' + state);
                if(cmp.isValid() && state === "SUCCESS"){
                    var result = response.getReturnValue();
                    //console.log(result);
                    resolve(result);
                } else if (state === "ERROR"){
                    var errors = response.getError();
                    self.handleErrors(errors);
                    reject(errors);
                }
            });
            $A.getCallback(function() {
                $A.enqueueAction(action);
            })();
        });
    },
    callAction : function(cmp, methodName, params, callback){
        var self = this;
        var action = cmp.get(methodName);
        if (params != null) action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(methodName + ' ' + state);
            if(cmp.isValid() && state === "SUCCESS"){
                var result = response.getReturnValue();
                //console.log(result);
                if (callback) callback(result);
            } else if (state === "ERROR"){
                self.handleErrors(response.getError());
            }
        });

        $A.getCallback(function() {
            $A.enqueueAction(action);
        })();
    },
    handleErrors : function(errors) {
        // Configure error toast
        let toastParams = {
            title: "Error",
            message: "Unknown error", // Default error message
            type: "error"
        };
        // use the error message if any
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.log(errors[0].message);
                toastParams.message = errors[0].message;
            }
        }
        // Fire error toast
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },

    handleShowToast : function(toastString) {
        // Configure error toast
        let toastParams = {
            title: "Success",
            message: "Request successfully completed", // Default success message
            type: "success"
        };
        // use the success message if provided and check if it is a warning
        if (toastString) {
            console.log(toastString);
            toastParams.message = toastString;
            if (toastString.startsWith('Warning:')) {
                toastParams.message = toastString.replace("Warning:","");
                toastParams.type = "warning";
                toastParams.title = "Warning";
            }
        }
        // Fire success toast
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },
})
