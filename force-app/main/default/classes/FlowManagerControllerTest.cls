@IsTest
private class FlowManagerControllerTest {
    @IsTest
    static void testGetFlows() {
        // Set mock callout class for the get Callout
        Test.setMock(HttpCalloutMock.class, new FlowManagerControllerCalloutMockGet());
        Test.startTest();
        String response = FlowManagerController.getFlows();
        Test.stopTest();

        System.assert(response.containsIgnoreCase('"done" : true, "queryLocator" : null, "entityTypeName" : "FlowDefinition", "records"'),
                'Unexpected response from FlowManagerController.getFlows()');
    }

    @IsTest
    static void testsaveFlowStatus() {
        // Set mock callout class for the get Callout
        Test.setMock(HttpCalloutMock.class, new FlowManagerControllerCalloutMockGet());

        Test.startTest();
        Boolean response = FlowManagerController.saveFlowStatus();
        Test.stopTest();

        List<ContentNote> cnList = [SELECT Id FROM ContentNote WHERE Title = :FlowManagerController.RESOURCE_TOOLING_NOTE_UID];
        System.assert(response,'The test should have returned a TRUE result');
        System.assertEquals(1, cnList.size(), 'At end of test, there should be one note record');
    }

    @IsTest
    static void testRetrieveFlowStatusNoEntries() {
        List<ContentNote> cnList = [SELECT Id FROM ContentNote WHERE Title = :FlowManagerController.RESOURCE_TOOLING_NOTE_UID];
        // For some reason Note records are visible even when seeAllData is false so we must delete them for the test duration
        if (cnList.size() != 0) delete cnList;

        Test.startTest();
        String response = FlowManagerController.retrieveFlowStatus();
        Test.stopTest();

        System.assertEquals(null, response, 'Response from retrieveFlowStatus when none exists should be null');
    }

    @IsTest
    static void testRetrieveFlowStatusOneEntry() {
        final String noteText = 'Some random text to put into the content of the note';
        List<ContentNote> cnList = [SELECT Id FROM ContentNote WHERE Title = :FlowManagerController.RESOURCE_TOOLING_NOTE_UID];
        // For some reason Note records are visible even when seeAllData is false so we must delete them for the test duration
        if (cnList.size() != 0) delete cnList;

        ContentNote cn = new ContentNote();
        cn.Title = FlowManagerController.RESOURCE_TOOLING_NOTE_UID;
        cn.Content = Blob.valueOf(noteText);
        insert cn;

        Test.startTest();
        String response = FlowManagerController.retrieveFlowStatus();
        Test.stopTest();

        System.assertEquals(noteText, response, 'Response from retrieveFlowStatus was not the expected text');
    }

    @IsTest
    static void testRetrieveFlowStatusMultipleEntries() {
        final String noteText = 'Some random text to put into the content of the note';
        List<ContentNote> cnList = [SELECT Id FROM ContentNote WHERE Title = :FlowManagerController.RESOURCE_TOOLING_NOTE_UID];
        // For some reason Note records are visible even when seeAllData is false so we must delete them for the test duration
        if (cnList.size() != 0) delete cnList;

        ContentNote cn = new ContentNote();
        cn.Title = FlowManagerController.RESOURCE_TOOLING_NOTE_UID;
        cn.Content = Blob.valueOf(noteText);
        insert cn;
        insert cn;

        Test.startTest();
        String response = FlowManagerController.retrieveFlowStatus();
        Test.stopTest();

        System.assert(response.startsWithIgnoreCase('Error:'), 'Response from retrieveFlowStatus should have been an error');
    }

    @IsTest
    static void testUpdateFlow() {
        // Set mock callout class for the get Callout
        Test.setMock(HttpCalloutMock.class, new FlowManagerControllerCalloutMockPatch());
        String metaData = '{"Metadata":{"activeVersionNumber":1}}';
        Boolean response = FlowManagerController.updateFlow('3016F000000qpg3QAA', metaData);
        System.assert(response, 'Expected response from ToggleFLow Off is True');
    }


}
