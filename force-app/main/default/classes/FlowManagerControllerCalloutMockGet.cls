@IsTest
global class FlowManagerControllerCalloutMockGet implements HttpCalloutMock {
    // Implement this interface method for a get to retrieve all flows from the org
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{ "size" : 4, "totalSize" : 4, "done" : true, "queryLocator" : null, "entityTypeName" : "FlowDefinition", "records" : [ { "attributes" : { "type" : "FlowDefinition", "url" : "/services/data/v56.0/tooling/sobjects/FlowDefinition/3006F0000005tOyQAI" }, "Id" : "3006F0000005tOyQAI", "ActiveVersion" : { "attributes" : { "type" : "Flow", "url" : "/services/data/v56.0/tooling/sobjects/Flow/3016F000000qpg3QAA" }, "VersionNumber" : 1 }, "LatestVersion" : { "attributes" : { "type" : "Flow", "url" : "/services/data/v56.0/tooling/sobjects/Flow/3016F000000qpg3QAA" }, "VersionNumber" : 1 }, "DeveloperName" : "Add_client_to_transitory_persons_cohort_from_matter" }, { "attributes" : { "type" : "FlowDefinition", "url" : "/services/data/v56.0/tooling/sobjects/FlowDefinition/3006F0000005tOxQAI" }, "Id" : "3006F0000005tOxQAI", "ActiveVersion" : { "attributes" : { "type" : "Flow", "url" : "/services/data/v56.0/tooling/sobjects/Flow/3016F000000qpg2QAA" }, "VersionNumber" : 1 }, "LatestVersion" : { "attributes" : { "type" : "Flow", "url" : "/services/data/v56.0/tooling/sobjects/Flow/3016F000000qpg2QAA" }, "VersionNumber" : 1 }, "DeveloperName" : "Add_Client_to_Transitory_Person_Cohort" }, { "attributes" : { "type" : "FlowDefinition", "url" : "/services/data/v56.0/tooling/sobjects/FlowDefinition/3006F000000IJXBQA4" }, "Id" : "3006F000000IJXBQA4", "ActiveVersion" : { "attributes" : { "type" : "Flow", "url" : "/services/data/v56.0/tooling/sobjects/Flow/3016F0000011XWtQAM" }, "VersionNumber" : 1 }, "LatestVersion" : { "attributes" : { "type" : "Flow", "url" : "/services/data/v56.0/tooling/sobjects/Flow/3016F0000011XWtQAM" }, "VersionNumber" : 1 }, "DeveloperName" : "Add_Contact_Name_to_Conflict_Check_on_Creation" }, { "attributes" : { "type" : "FlowDefinition", "url" : "/services/data/v56.0/tooling/sobjects/FlowDefinition/3006F000000QDHUQA4" }, "Id" : "3006F000000QDHUQA4", "ActiveVersion" : null, "LatestVersion" : { "attributes" : { "type" : "Flow", "url" : "/services/data/v56.0/tooling/sobjects/Flow/3016F000000CRSxQAO" }, "VersionNumber" : 1 }, "DeveloperName" : "Allocate_to_lawyer" }]}');
        res.setStatusCode(200);
        return res;
    }
}