Step 1 - You need to verify if the process builder "User Info Object Manage" is active. 
       - If "User Info Object Manage" is not active, you should active it.
Step 2 - You need to verify if the flow "Update User Info Record" is active. 
       - If "Update User Info Record" is not active, you should active it.

# Create records for Salesforce Career Path

Run the following script in an anonymus window:


```
List<String> certificationNames = new List<String>{'Administrator','JavaScript Developer I','Platform App Builder','Platform Developer I','Platform Developer II','Sharing and Visibility', 'Data Architecture and Management', 'Development Lifecycle and Deployment', 'Identity and Access Management', 'Integration Architecture', 'Heroku Architecture Designer', 'Scrum Master', 'System Architect', 'Technical Architect', 'Application Architect'};

List<ta_Certification__c> certifications = new List<ta_Certification__c>();
Map<String, ta_Certification__c> certNameMap = new Map<String, ta_Certification__c>();
for (String certifName : certificationNames) {
       ta_Certification__c cert = new ta_Certification__c();
       cert.Name = certifName;
       certifications.add(cert);
       certNameMap.put(certifName, cert);
}

insert certifications;

```

and then execute the following code:

```
List<ta_Certification__c> certifications = [SELECT Id, Name FROM ta_Certification__c];
Map<String, ta_Certification__c> certNameMap = new Map<String, ta_Certification__c>();
for (ta_Certification__c cert : certifications) {
    certNameMap.put(cert.Name, cert);
}

List<Salesforce_Career_Path__c> careerPaths = new List<Salesforce_Career_Path__c>();

//Trainee
Salesforce_Career_Path__c scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Trainee';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Developer';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

//Developer
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Developer';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Apex Specialist;Salesforce Lightning Specialist;Salesforce Platform Specialist';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Developer';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Apex Specialist;Salesforce Lightning Specialist;Salesforce Platform Specialist';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

//Lightning Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Lightning Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Senior Lightning Specialist';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Lightning Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Senior Lightning Specialist';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Lightning Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Senior Lightning Specialist';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

//Apex Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Apex Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Senior Apex Specialist';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Apex Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Senior Apex Specialist';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Apex Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Senior Apex Specialist';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

//Platform Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Platform Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Senior Platform Specialist';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Platform Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Senior Platform Specialist';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Platform Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Senior Platform Specialist';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Platform Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Senior Platform Specialist';
scp.Certification__c = certNameMap.get('Platform Developer II').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Platform Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Senior Platform Specialist';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

insert careerPaths;
```

and then execute the following code:

```
List<ta_Certification__c> certifications = [SELECT Id, Name FROM ta_Certification__c];
Map<String, ta_Certification__c> certNameMap = new Map<String, ta_Certification__c>();
for (ta_Certification__c cert : certifications) {
    certNameMap.put(cert.Name, cert);
}

List<Salesforce_Career_Path__c> careerPaths = new List<Salesforce_Career_Path__c>();


//Senior Lightning Specialist
Salesforce_Career_Path__c scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Lightning Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Lightning Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Lightning Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Lightning Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Platform Developer II').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Lightning Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//Senior Apex Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Apex Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Apex Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Apex Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Apex Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Platform Developer II').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Apex Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//Senior Platform Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Platform Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Platform Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Platform Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Platform Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Platform Developer II').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Platform Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Platform Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Sharing and Visibility').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Platform Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Data Architecture and Management').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Platform Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Development Lifecycle and Deployment').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Senior Platform Specialist';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Team Lead;Salesforce Techincal Architect';
scp.Certification__c = certNameMap.get('Identity and Access Management').Id;
careerPaths.add(scp);

insert careerPaths;

```

and then execute the following code:

```
List<ta_Certification__c> certifications = [SELECT Id, Name FROM ta_Certification__c];
Map<String, ta_Certification__c> certNameMap = new Map<String, ta_Certification__c>();
for (ta_Certification__c cert : certifications) {
    certNameMap.put(cert.Name, cert);
}

List<Salesforce_Career_Path__c> careerPaths = new List<Salesforce_Career_Path__c>();

//Salesforce Team Lead
Salesforce_Career_Path__c scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('Platform Developer II').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('Sharing and Visibility').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('Data Architecture and Management').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('Development Lifecycle and Deployment').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('Identity and Access Management').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Team Lead';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Manager';
scp.Certification__c = certNameMap.get('Integration Architecture').Id;
careerPaths.add(scp);

//Salesforce Technical Architect
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Platform Developer II').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Sharing and Visibility').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Data Architecture and Management').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Development Lifecycle and Deployment').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Identity and Access Management').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Integration Architecture').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Heroku Architecture Designer').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('System Architect').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Application Architect').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Technical Architect').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Technical Architect';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Scrum Master').Id;
careerPaths.add(scp);

insert careerPaths;

```

and then execute the following code:

```
List<ta_Certification__c> certifications = [SELECT Id, Name FROM ta_Certification__c];
Map<String, ta_Certification__c> certNameMap = new Map<String, ta_Certification__c>();
for (ta_Certification__c cert : certifications) {
    certNameMap.put(cert.Name, cert);
}

List<Salesforce_Career_Path__c> careerPaths = new List<Salesforce_Career_Path__c>();

//Salesforce Manager
Salesforce_Career_Path__c scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Manager';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Delivery Manager';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Manager';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Delivery Manager';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Manager';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Delivery Manager';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Manager';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Delivery Manager';
scp.Certification__c = certNameMap.get('Platform Developer II').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Manager';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Delivery Manager';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Manager';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Delivery Manager';
scp.Certification__c = certNameMap.get('Scrum Master').Id;
careerPaths.add(scp);

//Salesforce Certified Architect
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Platform App Builder').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Platform Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('JavaScript Developer I').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Platform Developer II').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Advanced Administrator').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Sharing and Visibility').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Data Architecture and Management').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Development Lifecycle and Deployment').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Identity and Access Management').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Integration Architecture').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Heroku Architecture Designer').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('System Architect').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Application Architect').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'Salesforce Certified Architect';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'Salesforce Certified Architect';
scp.Certification__c = certNameMap.get('Technical Architect').Id;
careerPaths.add(scp);

insert careerPaths;

```

