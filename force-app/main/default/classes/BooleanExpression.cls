/***************************************************************************************************
* Class Name   : BooleanExpression
* Created Date : July 4, 2018
* Author       : Vijaya Sankar N
* Description  : Class to evaluate a boolean expression 
* Example      : (TRUE AND (FALSE OR TRUE)) is TRUE
****************************************************************************************************/
public class BooleanExpression {
    static Map<String, String> logicTypes = new Map<String, String>();
    static Map<String, Map<String, String>> expressionLogic = new Map<String, Map<String, String>>();
    
    /**
    * Evaluate a boolean expreassion 
    * 
    */
    public static Boolean eval(String expression) {        
        // If expression contains all TRUE or FALSE
        if(expression.containsNone('FALSE')) { return TRUE; }        
        if(expression.containsNone('TRUE')) { return FALSE; }

        fillLogic();

        return Boolean.valueOf(evaluateExpression(expression.toUpperCase()));
    }
    
    /**
    * Evaluate the expression
    * 
    */
    public static String evaluateExpression(String expression) {        
        for(String logicType : logicTypes.keySet()) {
            if(expression.contains(logicType)) {
                expression = simplifyExpression(expression, logicTypes.get(logicType));
            }
        }
        
        if(expression.contains('AND') || expression.contains('OR') || expression.contains('(')) {
            expression = evaluateExpression(expression);
        }
        
        return expression;
    }
    
    /**
     * Simplify the expression
     * 
     */
    public static string simplifyExpression(String expression, String LogicType){
        Map<String, String> Logic = new Map<String, String>(expressionLogic.get(LogicType));
        
        for(String key : Logic.keySet()) {
            expression = expression.replace(key, Logic.get(key));
        }
        
        return expression;
    } 
    
    /**
    * Fill AND and OR Logic
    * 
    */
    public static void fillLogic() {
        Map<String, String> ANDLogic = new Map<String, String>();
        Map<String, String> ORLogic = new Map<String, String>();
        Map<String, String> BRACELogic = new Map<String, String>();
        
        logicTypes.put('AND', 'AND');
        logicTypes.put('OR', 'OR');
        logicTypes.put('(', 'BRACES');
        
        // AND Logic
        ANDLogic.put('TRUE AND TRUE', 'TRUE');
        ANDLogic.put('TRUE AND FALSE', 'FALSE');
        ANDLogic.put('FALSE AND TRUE', 'FALSE');
        ANDLogic.put('FALSE AND FALSE', 'FALSE');
        expressionLogic.put('AND', ANDLogic);
        
        // OR Logic
        ORLogic.put('TRUE OR TRUE', 'TRUE');
        ORLogic.put('TRUE OR FALSE', 'TRUE');
        ORLogic.put('FALSE OR TRUE', 'TRUE');
        ORLogic.put('FALSE OR FALSE', 'FALSE');
        expressionLogic.put('OR', ORLogic);
        
        // Braces Logic
        BRACELogic.put('(TRUE)', 'TRUE');
        BRACELogic.put('(FALSE)', 'FALSE');
        expressionLogic.put('BRACES', BRACELogic);
    }
}