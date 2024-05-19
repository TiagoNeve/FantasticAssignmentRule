public without sharing class CreateRuleButtonCTR {

    @AuraEnabled(cacheable=true)
    public static String getAllObjects() {

        List<CreateRuleButtonCTR.OptionsObjectComparable> objectApiNameByLabel = new List<CreateRuleButtonCTR.OptionsObjectComparable>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

        for(String tokenDescribe : globalDescribe.keySet())
        {
            Schema.DescribeSObjectResult sobjectDescribe = globalDescribe.get(tokenDescribe).getDescribe();

            if ( checkConfigurations(sobjectDescribe) ) continue;

            String label = sobjectDescribe.getLabel();

            objectApiNameByLabel.add(
                new CreateRuleButtonCTR.OptionsObjectComparable(
                    label,
                    sobjectDescribe.getName()
                )
            );
        }

        objectApiNameByLabel.sort();

        return JSON.serialize( objectApiNameByLabel );
    }

    private static Boolean checkConfigurations( Schema.DescribeSObjectResult sobjectDescribe ) {
        Boolean isNotAccessible = !sobjectDescribe.isAccessible(); // Se o usuário do contexto tem acesso.
        Boolean isNotCreateable = !sobjectDescribe.isCreateable(); // Se o usuário do contexto consegue criar.
        Boolean isCustomSetting = sobjectDescribe.isCustomSetting(); // Se o objeto é configuração customizada

        Boolean isReproved = isCustomSetting || isNotAccessible || isNotCreateable;

        return isReproved;
    }

    public class OptionsObjectComparable implements Comparable {

        public String label;
        public String value;

        // Constructor
        public OptionsObjectComparable(String label, String value) {
            this.label = label;
            this.value = value;
        }

        public Integer compareTo(Object compareTo) {
            OptionsObjectComparable compareToOp = (OptionsObjectComparable) compareTo;
            if (this.label == compareToOp.label) return 0; // Se forem iguais mantem
            if (this.label > compareToOp.label) return 1; // Se a instância for maior que o próximo, então ele coloca para antes.
            return -1;  
        }
    }
}