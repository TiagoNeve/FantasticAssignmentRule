global without sharing class ProcessAssignmentRulesAA {

    @InvocableMethod(label='Process - Fantastic Assignment Rules' description='Use to connect the flow with the custom process Fantastic Assignment Rules')
    public static List<Results> processAssignmentRules(List<Requests> requests) {
        List<Results> resultsList = new List<Results>();
        
        Map<String, List<SObject>> recordsInputByApiName = new Map<String, List<SObject>>();

        for (Requests req : requests) {
            List<SObject> recordsInput = req.recordsInput;

            String apiNameObject = req.apiNameObject;
            System.debug('apiNameObject');

            System.debug(apiNameObject);

            if ( !recordsInputByApiName.containsKey(apiNameObject) ) {
                recordsInputByApiName.put(apiNameObject, new List<SObject>());
            }

            recordsInputByApiName.get(apiNameObject).addAll(recordsInput);
        }

        // TODO: Agora a gente tem a lista de objetos por nome de api
        // Podemos buscar as regras por nome de api agora em kkkk
        if (!recordsInputByApiName.isEmpty()) {
            List<Rule__c> rules = [SELECT Id, Object__c, (SELECT Id, Order__c, Criteria__c, AssignTo__c, Email__c FROM Rule_Entries__r ORDER BY Order__c ASC) FROM Rule__c WHERE Object__c IN : recordsInputByApiName.keySet()];

            Map<String, List<Rule__c>> rulesByObjectApiName = new Map<String, List<Rule__c>>();

            for ( Rule__c rule : rules ) {

                String objectApiName = rule.Object__c;
                if (!rulesByObjectApiName.containsKey(objectApiName)) {
                    rulesByObjectApiName.put(objectApiName, new List<Rule__c>());
                }

                rulesByObjectApiName.get(objectApiName).add(rule);
            }

            // Email templates RelatedEntityType
            Map<String, Map<String, EmailTemplate>> emailTemplateByEntityType = new Map<String, Map<String, EmailTemplate>>();

            for (EmailTemplate emailTemplateR : [SELECT Id, RelatedEntityType FROM EmailTemplate] ) {

                String entityType = emailTemplateR.RelatedEntityType;
                if (!emailTemplateByEntityType.containsKey(entityType)) {
                    emailTemplateByEntityType.put(entityType, new Map<String, EmailTemplate>());
                }

                emailTemplateByEntityType.get(entityType).put( emailTemplateR.Id, emailTemplateR );
            }

            // A melhor forma para verificar é percorrendo os registros e para cada registro percorrer as regras e quando encontrar
            // Dar continue.

            List<Messaging.SingleEmailMessage> emailsParaEnviar = new List<Messaging.SingleEmailMessage>();
            List<SObject> recordsToUpdate = new List<SObject>();

            for ( String objectApiName : recordsInputByApiName.keySet() ) {
                List<SObject> recordsInput = recordsInputByApiName.get(objectApiName);

                List<Rule__c> rulesFromMap = rulesByObjectApiName.get(objectApiName);

                // Fluxo em
                for (SObject recordR : recordsInput) {

                    for (Rule__c rule : rulesFromMap) {
                        System.debug(rule.Rule_Entries__r);
                    
                        for (RuleEntry__c ruleEntry : rule.Rule_Entries__r) {
                            System.debug('ruleEntry');
                            System.debug(ruleEntry);

                            Decimal order = ruleEntry.Order__c;

                            List<Map<String, String>> criterioDeserializado = (List<Map<String, String>>) JSON.deserialize(ruleEntry.Criteria__c, List<Map<String, String>>.class);

                            String assignTo = ruleEntry.AssignTo__c;
                            String email = ruleEntry.Email__c;

                            System.debug('order');
                            System.debug(order);

                            System.debug('criterioDeserializado');
                            System.debug(criterioDeserializado);

                            System.debug('assignTo');
                            System.debug(assignTo);

                            System.debug('email');
                            System.debug(email);

                            Boolean passouNoCriterio;

                            for (Map<String, String> criterio : criterioDeserializado) {
                                String field = criterio.get('field');
                                String operation = criterio.get('operation');
                                String value = criterio.get('value');

                                Object recordFieldValue = recordR.get(field);

                                switch on operation {
                                    when '!=' {
                                        System.debug('Entrou no critério !=');
                                        System.debug(recordFieldValue);
                                        System.debug('!=');
                                        System.debug(value);
                                        System.debug(recordFieldValue != value);
                                        passouNoCriterio = recordFieldValue != value;
                                    }
                                    when '==' {
                                        passouNoCriterio = recordFieldValue == value;
                                    }
                                }
                            }

                            if (passouNoCriterio) {
                                System.debug('FLUXO PARA MUDAR O PROPRIETÁRIO E ENVIAR EMAIL');

                                // Fluxo mudança proprietário
                                recordR.put('OwnerId', assignTo);
                                System.debug(recordR);

                                recordsToUpdate.add(recordR);

                                // Fluxo email 
                                if (email != null) {
                                    Messaging.SingleEmailMessage emailMessage = Messaging.renderStoredEmailTemplate( email, null, recordR.Id);
                                
                                    if (assignTo.startsWith('005')) { // User fluxo
                                        emailMessage.setToAddresses(new List<String>{assignTo});
                                    }

                                    if (assignTo.startsWith('00G')) { // Queue fluxo
                                        // Get queue members to send
                                    }

                                    emailsParaEnviar.add(emailMessage);
                                }
                            }
                        }
                    }

                }
            }

            if (!recordsToUpdate.isEmpty()) UPDATE recordsToUpdate;

            if (!emailsParaEnviar.isEmpty()) {
                Messaging.SendEmailResult[] emailResults = Messaging.sendEmail(emailsParaEnviar, false);
    
                Integer aux = 0;
                for (Messaging.SendEmailResult emailResult : emailResults) {
                    if (emailResult.isSuccess()) {
                        System.debug('Email enviado com sucesso');
                        System.debug(emailResults[0]);
                    } else {
                        System.debug('Deu erro');
                        for ( Messaging.SendEmailError emailError : emailResult.getErrors()) {
                            System.debug('getFields() : ' + emailError.getFields());
                            System.debug('getMessage() : ' + emailError.getMessage());
                            System.debug('getStatusCode() : ' + emailError.getStatusCode());
                            System.debug('getTargetObjectId() : ' + emailError.getTargetObjectId());
                        }
                    }
                    ++aux;
                }
            }
        }

        ProcessAssignmentRulesAA.Results resultsInstance = new ProcessAssignmentRulesAA.Results();
        resultsInstance.outputRecords = requests[0].recordsInput; 
        resultsList.add( resultsInstance );
        return resultsList;
    }
    
    global class Requests {
        @InvocableVariable(label='Records for input' required=true description='Put in this variable the records of flow context')
        global List<SObject> recordsInput;  
        
        @InvocableVariable(label='Api Name for Object' required=true description='Please informe the Api Name of object flow context')
        global String apiNameObject;
    }
    
    global class Results {
        @InvocableVariable(label='Records for Output' description='Records after the process of assignment rule')
        global List<SObject> outputRecords;
    }
}