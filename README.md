# Installation Instructions

##	In the target org
**Create Connected App**
1.	Setup > App Manager [New Connected App]
  - Name: ApexMDAPI
  - API Name: ApexMDAPI
  - Contact Email: Your email
  - Select Enable OAuth Settings
  - Set callback URL = https://locahost/dummy
  -	Choose the “full” and “refresh_token, offline_access” OAuth Scopes.
  -	Save
  -	Continue
  
**Copy the Consumer Key and Consumer Secret as follows:**

2. Setup > App Manager (you may already be on the page where you can go to straight to the second bullet)
  - Click on action arrow for ApexMDAPI, select View
  - Click on [Manage Consumer Details]
  - Copy the verification code from your email into the dialog & Verify
  - Copy Key and Secret for later use
  
**Create Auth. Provider**

3. Setup > Security Controls > Auth. Provider > [New]
  - Type: Salesforce
  - Name: ApexMDAPI
  - URL Suffix: ApexMDAPI
  - Paste in Consumer Key and Secret
  - Enter Default Scopes: full refresh_token offline_access
  - Save
  - From the Salesforce Configuration section, copy the Callback URL value
  
**Set the connected App Callback URL value**

4.	Setup > App Manager
  -	Click on action arrow for ApexMDAPI, select Edit  
  - Paste the copied value into the Callback URL field
  - Save.  
  - **Wait a few minutes to allow the settings to take effect and propagate**
  
**Create the Named Credential**

5.	Setup > Security Controls > Named Credentials [New Legacy] (not New)
  - Label: ApexMDAPI
  - Name: ApexMDAPI
  - URL: The instance_Url for your target org (the URL up to but excluding the first single ‘/’ character). Ensure that the URL is in the form https://<instance_url>.my.salesforce.com
  - Identity Type = Named Principal
  - Authentication Protocol = OAuth 2.0
  - Authentication Provider = ApexMDAPI (as previously created)
  - Scope: full refresh_token offline_access
  - Ensure “Start Authentication Flow on Save” is ticked
  - Tick the Allow Merge Fields in HTTP Body” checkbox and select Save
  - This will open a browser window. Log into your target org and ALLOW all requested scopes
  - This should return you to the Named Credential page. It should now show an authentication status that shows the user it has been authenticated as. If you get an error such as invalid_client_id or callback_url_mismatch, wait a few minutes, find the Named Credential, Edit/Save and try again

**Ensure that Notes have been enabled in the target org as this is where the manager stores the details of which flows are active**

6.	Feature Settings > Sales > Notes Settings > Enable Notes

**Deploy the following items from the sandbox to the target org**

7.	Apex Classes:  
  - FlowManagerController
  - FlowManagerControllerTest
  - FlowManagerControllerCalloutMockGet
  - FlowManagerControllerCalloutMockPatch
8.	Aura Component Bundle: 
  - FlowManager
9.	**When deploying Run specified tests: FlowManagerControllerTest**

**Create a new Lightning Page in the target org**

10. Setup > Lightning App Builder [New]
  - App Page [Next]
  - Label: The Flow Controller [Next]
  - Select One Region [Finish]
  - Add the Custom Component FlowManager to the top region
  - Save, Activate 
  - Activate for system administrators only
  - Click LIGHTNING EXPERIENCE Tab
  - Choose one or more Lightning Apps to add the page to and [Save] 
  - [Save] again, click back in the builder to return to setup
  
**Run the component on the app page you just created**

11. Click the app picker (9 dots), search for "controller" and open the page 
