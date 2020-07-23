namespace GalaxyPad.Evaluation
{
    public readonly struct Token
    {
        public Token(TokenType type, string value) =>
            (Type, Value) = (type, value);

        public TokenType Type { get; }

        public string Value { get; }
    }
}