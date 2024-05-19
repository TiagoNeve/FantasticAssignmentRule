@isTest
public class BooleanExpression_Test {
    @isTest static void eval_test() {
        System.assert(BooleanExpression.eval('TRUE'));
        System.assert(BooleanExpression.eval('TRUE OR FALSE'));
        System.assert(BooleanExpression.eval('TRUE OR TRUE'));
        System.assert(BooleanExpression.eval('TRUE OR (TRUE AND FALSE)'));
        System.assert(BooleanExpression.eval('TRUE OR (TRUE AND FALSE AND TRUE OR TRUE)'));
        System.assert(BooleanExpression.eval('TRUE OR (TRUE AND FALSE AND (TRUE OR FALSE))'));
        System.assert(BooleanExpression.eval('TRUE OR (TRUE OR (FALSE AND (TRUE OR FALSE)))'));
        System.assert(BooleanExpression.eval('(FALSE OR ((TRUE OR FALSE) AND (TRUE OR FALSE)))'));
        
        System.assert(!BooleanExpression.eval('FALSE'));
        System.assert(!BooleanExpression.eval('TRUE AND FALSE'));
        System.assert(!BooleanExpression.eval('FALSE AND FALSE'));
        System.assert(!BooleanExpression.eval('TRUE AND (TRUE AND FALSE)'));
        System.assert(!BooleanExpression.eval('FALSE AND (TRUE AND FALSE AND TRUE OR TRUE)'));
        System.assert(!BooleanExpression.eval('TRUE AND (TRUE AND FALSE AND (TRUE OR FALSE))'));
        System.assert(!BooleanExpression.eval('TRUE AND (TRUE AND (FALSE AND (TRUE OR FALSE)))'));
        System.assert(!BooleanExpression.eval('(FALSE AND ((TRUE OR FALSE) AND (TRUE OR FALSE)))'));
    }
}