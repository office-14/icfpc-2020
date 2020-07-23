using System;
using System.Diagnostics.CodeAnalysis;

namespace GalaxyPad.Evaluation.AST
{
    public sealed class Atom : Expression
    {
        public Atom(string value) => Value = value;

        public string Value { get; }

        public override bool Equals([AllowNull] Expression other)
        {
            if (other is Atom atom)
            {
                return Value.Equals(atom.Value);
            }
            return false;
        }
    }
}