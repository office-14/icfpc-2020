namespace GalaxyPad.Evaluation.AST
{
    public sealed class Ap : Expression
    {
        public Ap(
            Expression function,
            Expression argument
        ) => (Function, Argument) = (function, argument);

        public Expression Function { get; }

        public Expression Argument { get; }
    }
}