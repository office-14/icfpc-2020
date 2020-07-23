using System;
using GalaxyPad.Evaluation.AST;

namespace GalaxyPad.Evaluation
{
    /// <summary>
    /// Transform token sequence into tree (parse or AST).
    /// </summary>
    public sealed class Parser
    {
        private readonly Lexer lexer;

        private Token currentToken;

        private Parser(Lexer lexer)
        {
            this.lexer = lexer;
            Advance();
        }

        private void Advance()
        {
            currentToken = this.lexer.NextToken();
        }

        private void Match(TokenType tokenType)
        {
            if (currentToken.Type != tokenType)
            {
                throw new InvalidOperationException($"Expect token {tokenType} but got ({currentToken.Type}, {currentToken.Value})");
            }

            Advance();
        }

        private Expression ParseText()
        {
            var expression = ParseExpression();

            Match(TokenType.EOF);

            return expression;
        }

        private Expression ParseExpression()
        {
            if (currentToken.Type == TokenType.ApOperator)
            {
                return ParseAp();
            }

            return ParseAtom();
        }

        private Expression ParseAp()
        {
            Match(TokenType.ApOperator);

            return new Ap(ParseExpression(), ParseExpression());
        }

        private Expression ParseAtom()
        {
            var atom = new Atom(currentToken.Value);
            Advance();
            return atom;
        }

        public static Expression Parse(string text)
        {
            var lexer = Lexer.Create(text);
            var parser = new Parser(lexer);

            return parser.ParseText();
        }
    }
}