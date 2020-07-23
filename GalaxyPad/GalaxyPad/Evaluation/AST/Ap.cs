using System.Diagnostics.CodeAnalysis;

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

        public override bool Equals([AllowNull] Expression other)
        {
            if (other is Ap otherAp)
            {
                return Function.Equals(otherAp.Function) && Argument.Equals(otherAp.Argument);
            }
            return false;
        }
    }
}