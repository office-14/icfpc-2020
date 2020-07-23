using System;
using Xunit;
using GalaxyPad.Evaluation;

namespace GalaxyPad.Tests
{
    public class LexerTests
    {
        [Fact]
        public void WhenTextIsEmpty_ThenReturnEOF()
        {
            var lexer = Lexer.Create("");

            var nextToken = lexer.NextToken();

            Assert.Equal(TokenType.EOF, nextToken.Type);
        }

        [Fact]
        public void WhenTextContainsOneAtom_ThenReturnAtom()
        {
            var lexer = Lexer.Create("cons");

            var nextToken = lexer.NextToken();

            Assert.Equal(TokenType.Atom, nextToken.Type);
            Assert.Equal("cons", nextToken.Value);
        }

        [Fact]
        public void WhenTextContainsOneAp_ThenReturnAp()
        {
            var lexer = Lexer.Create("ap");

            var nextToken = lexer.NextToken();

            Assert.Equal(TokenType.ApOperator, nextToken.Type);
            Assert.Equal("ap", nextToken.Value);
        }

        [Fact]
        public void WhenTextContainsOneAtomSurroundedWithSpaces_ThenReturnAtomAndEOF()
        {
            var lexer = Lexer.Create("   cons     ");

            Assert.Equal(TokenType.Atom, lexer.NextToken().Type);
            Assert.Equal(TokenType.EOF, lexer.NextToken().Type);
        }

        [Fact]
        public void WhenTextIsFromGalaxy_ThenReturnCorrectTokenSequence()
        {
            var lexer = Lexer.Create("  ap ap cons 2 ap ap cons 7 nil  ");

            Assert.Equal(TokenType.ApOperator, lexer.NextToken().Type);
            Assert.Equal(TokenType.ApOperator, lexer.NextToken().Type);
            Assert.Equal(TokenType.Atom, lexer.NextToken().Type);
            Assert.Equal(TokenType.Atom, lexer.NextToken().Type);
            Assert.Equal(TokenType.ApOperator, lexer.NextToken().Type);
            Assert.Equal(TokenType.ApOperator, lexer.NextToken().Type);
            Assert.Equal(TokenType.Atom, lexer.NextToken().Type);
            Assert.Equal(TokenType.Atom, lexer.NextToken().Type);
            Assert.Equal(TokenType.Atom, lexer.NextToken().Type);
            Assert.Equal(TokenType.EOF, lexer.NextToken().Type);
        }
    }
}
