using System;

namespace GalaxyPad.Evaluation.AST
{
    public sealed class Atom : Expression
    {
        public Atom(string value) => Value = value;

        public string Value { get; }
    }
}