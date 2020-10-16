Step 1 - Go to Setup, in the quick find box write Communities Setting and open it.
       - In the Enable communities secction click the 'Enable communities' check box.
       - In the Select a domain name secction write one domain name, check the avaiability and if it is ok save it.
Step 2 - Into the proyect folder, go to: force-app/main/default/sites
       - Open the Altimetrik_Community.site-meta.xml file
       - On the bottom change this variables:
                - <siteAdmin>yourOrgUser@yourMail.com</siteAdmin>
                - <siteGuestRecordDefaultOwner>yourOrgUser@yourMail.com</siteGuestRecordDefaultOwner>
                - <subdomain>yourSubDomainCreatedInCommunitiesSettings</subdomain>
        Example:    
                - <siteAdmin>strellesdev2@communityorg.com</siteAdmin>
                - <siteGuestRecordDefaultOwner>strellesdev2@communityorg.com</siteGuestRecordDefaultOwner>
                - <subdomain>altimetrik-community02-developer-edition</subdomain>

