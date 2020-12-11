Step 1 - Go to Administration in the Community
       - In Preference (Left Menu)
              - Activate "Let guest users view asset files and CMS content available to the community".
              - Save the changes.
       - In Login & Registration (Left Menu)
              - Login Page Setup section, pick in Login Page Type: Expirience Builder Page, then search a page /login and select it.
              -Save the changes.

Step 2 - Got to Setup -> Communities -> All Communities
       - Click on Builder link for Altimetrik Community
       - Got to the Gear icon on the left and click it
       - In general section, go to the end and click on the `Altimetrik Community Profile`
       - Click in the `Enabled Apex Classes` link
       - Enable the following classes: 
              - ChangePasswordController
              - CommunitiesLandingController
              - CommunitiesLoginController
              - CommunitiesSelfRegConfirmController
              - CommunitiesSelfRegController
              - ForgotPasswordController
              - LightningForgotPasswordController
              - LightningLoginFormController
              - LightningSelfRegisterController