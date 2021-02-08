# Create records for Salesforce Career Path

Run the following script in an anonymus window:


```
List<String> certificationNames = new List<String>{'ISTQB Foundation Level'};

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
then execute the following code:

```
List<ta_Certification__c> certifications = [SELECT Id, Name FROM ta_Certification__c];
Map<String, ta_Certification__c> certNameMap = new Map<String, ta_Certification__c>();
for (ta_Certification__c cert : certifications) {
    certNameMap.put(cert.Name, cert);
}

List<Salesforce_Career_Path__c> careerPaths = new List<Salesforce_Career_Path__c>();

//QA Junior
Salesforce_Career_Path__c scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Junior';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'QA Analyst';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Junior';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'QA Analyst';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Analyst
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Analyst';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'QA Senior';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Analyst';
scp.Required__c = false;
scp.Possible_Next_Role__c = 'QA Senior';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Senior
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Senior';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Lead; QA Automation Specialist; QA Mobile Specialist; QA Security Specialist; QA Usability Specialist; QA Technology Specialist; QA Coach';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Senior';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Lead; QA Automation Specialist; QA Mobile Specialist; QA Security Specialist; QA Usability Specialist; QA Technology Specialist; QA Coach';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Automation Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Automation Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Automation Specialist Lead';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Automation Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Automation Specialist Lead';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Mobile Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Mobile Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Mobile Specialist Lead';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Mobile Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Mobile Specialist Lead';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Security Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Security Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Security Specialist Lead';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Security Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Security Specialist Lead';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Usability Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Usability Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Usability Specialist Lead';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Usability Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Usability Specialist Lead';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Technology Specialist
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Technology Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Technology Specialist';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Coach
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Coach';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Coach';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Lead
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Automation Specialist Lead
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Automation Specialist Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Automation Specialist Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Mobile Specialist Lead
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Mobile Specialist Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Mobile Specialist Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Security Specialist Lead
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Security Specialist Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Security Specialist Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Usability Specialist Lead
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Usability Specialist Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Usability Specialist Lead';
scp.Required__c = true;
scp.Possible_Next_Role__c = 'QA Manager';
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

//QA Manager
scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Manager';
scp.Required__c = true;
scp.Certification__c = certNameMap.get('ISTQB Foundation Level').Id;
careerPaths.add(scp);

scp = new Salesforce_Career_Path__c();
scp.Role__c = 'QA Manager';
scp.Required__c = true;
scp.Certification__c = certNameMap.get('Administrator').Id;
careerPaths.add(scp);

insert careerPaths;