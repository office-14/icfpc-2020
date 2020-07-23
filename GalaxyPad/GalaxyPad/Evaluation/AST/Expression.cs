using System;
using System.Diagnostics.CodeAnalysis;

namespace GalaxyPad.Evaluation.AST
{
    public abstract class Expression : IEquatable<Expression>
    {
        public abstract bool Equals([AllowNull] Expression other);
    }
}