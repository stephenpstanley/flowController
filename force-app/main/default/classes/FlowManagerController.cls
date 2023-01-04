public class FlowManagerController {

    private static final String RESOURCE_TOOLING_QUERY_FLOW = '/services/data/v56.0/tooling/query?q=Select+Id,ActiveVersion.VersionNumber,LatestVersion.VersionNumber,DeveloperName+From+FlowDefinition+ORDER+BY+DeveloperName';
    private static final String RESOURCE_TOOLING_SOBJECT_FLOW = '/services/data/v56.0/tooling/sobjects/FlowDefinition/';
    public static final String RESOURCE_TOOLING_NOTE_UID = 'Saved Flow Status details UUID:FDGHJHGF-OIUYUIO-%^&*(*&^-IUYTYUI';

    @AuraEnabled
    public static String getFlows() {

        System.debug('getFlows Request: ' + RESOURCE_TOOLING_QUERY_FLOW);
        HttpResponse response = executeCallout('GET', RESOURCE_TOOLING_QUERY_FLOW, null);

        System.debug('Response: ' + response);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        }

        throw new AuraHandledException(response.toString());
    }

    @AuraEnabled
    public static Boolean saveFlowStatus(){
        try {
            String JSONString = getFlows();
            List<ContentNote> cnList = [SELECT Id FROM ContentNote WHERE Title = :RESOURCE_TOOLING_NOTE_UID];
            if (cnList.size() > 0 ) {
                System.debug('Found ' + cnList.size() + ' matching note records' + cnList);
                delete cnList;
            }
            ContentNote cn = new ContentNote();
            cn.Title = RESOURCE_TOOLING_NOTE_UID;
            cn.Content = Blob.valueOf(JSONString.escapeHtml4());
            insert cn;
            System.debug('Inserted Note with title: ' + RESOURCE_TOOLING_NOTE_UID + ' and size: ' + JSONString.length() );
            return true;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String retrieveFlowStatus(){
        String JSONString;
        List<ContentNote> ContentNotes = [SELECT Content FROM ContentNote WHERE Title = :RESOURCE_TOOLING_NOTE_UID ];
        if (ContentNotes.size() == 1) {
            JSONString = ContentNotes[0].Content.toString().unescapeHtml4();
            System.debug('Retrieved Note: ' + JSONString.abbreviate(100));
            return JSONString;
        } else if (ContentNotes.size() == 0) {
            return null;
        } else {
            return 'Error: Found more than one saved set of Flow settings. Before retrying, exit & delete all private notes with title: ' + RESOURCE_TOOLING_NOTE_UID;
        }
    }

    @AuraEnabled
    public static Boolean updateFlow(String flowId, String metadata) {

        System.debug('updateFlows Request: ' + RESOURCE_TOOLING_QUERY_FLOW);
        System.debug('FlowID: ' + flowId + ' Metadata: ' + metadata);

        HttpResponse response = executeCallout('PATCH', RESOURCE_TOOLING_SOBJECT_FLOW + flowId + '/?_HttpMethod=PATCH', metadata);

        System.debug('Response: ' + response);

        if (response.getStatusCode() == 200 || response.getStatusCode() == 204) {
            return true;
        }

        return false;
    }

    public static HttpResponse executeCallout(String method, String resourceName, String requestBody) {

        HttpRequest request = new HttpRequest();

        if (method == 'PATCH') {
            request.setMethod('POST');
        } else {
            request.setMethod(method);
        }

        request.setEndpoint(getUrl() + resourceName);

        request.setHeader('Authorization', 'OAuth {!$Credential.OAuthToken}');

        request.setHeader('Accept', 'application/json');
        request.setHeader('X-PrettyPrint', '1');
        request.setHeader('Content-Type', 'application/json');

        if (String.isNotBlank(requestBody)) {
            request.setBody(requestBody);
        }

        System.debug('Callout Request: ' + request);

        HttpResponse response = new Http().send(request);

        System.debug(' Final status code: ' + response.getStatusCode());
        System.debug(' Final response body: ' + response.getBody());

        return response;
    }

    private static String getUrl(){
        return 'callout:ApexMDAPI'; // CHANGE THIS
    }

}
