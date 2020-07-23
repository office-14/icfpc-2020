namespace GalaxyPad.Evaluation
{
    /// <summary>
    /// Transform character sequence into token sequence.
    /// </summary>
    public sealed class Lexer
    {
        public static readonly Token EOF = new Token(TokenType.EOF, string.Empty);

        public static readonly Token ApOperator = new Token(TokenType.ApOperator, "ap");

        private readonly string text;
        private int nextIdx;

        private Lexer(string text)
        {
            this.text = text;
            nextIdx = 0;
        }

        public Token NextToken()
        {
            while (nextIdx < text.Length)
            {
                if (char.IsWhiteSpace(text[nextIdx]))
                {
                    nextIdx++;
                    continue;
                }
                else
                {
                    var currIdx = nextIdx;
                    while (currIdx < text.Length && !char.IsWhiteSpace(text[currIdx]))
                    {
                        currIdx++;
                    }

                    var value = text.Substring(nextIdx, currIdx - nextIdx);
                    nextIdx = currIdx;

                    if (value == "ap") return ApOperator;
                    return new Token(TokenType.Atom, value);
                }
            }

            return EOF;
        }

        public static Lexer Create(string text) =>
            new Lexer(text);
    }
}