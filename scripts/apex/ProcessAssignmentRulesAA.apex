ProcessAssignmentRulesAA.Requests request = new ProcessAssignmentRulesAA.Requests();
request.apiNameObject = 'Account';
request.recordsInput = new List<SObject> {
    (SObject) new Account(Name='Teste')
};


ProcessAssignmentRulesAA.processAssignmentRules(new List<ProcessAssignmentRulesAA.Requests>{
    request
});