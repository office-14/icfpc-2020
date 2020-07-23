using Xunit;
using GalaxyPad.Evaluation;
using GalaxyPad.Evaluation.AST;

namespace GalaxyPad.Tests
{
    public class ParserTests
    {
        [Fact]
        public void WhenTextIsAtom_ThenReturnAtomExpression()
        {
            var ast = Parser.Parse("cons");

            Assert.IsType<Atom>(ast);
            Assert.Equal<string>("cons", (ast as Atom).Value);
        }

        [Fact]
        public void WhenTextIsApExpression_ThenReturnApExpression()
        {
            var ast = Parser.Parse("ap inc 1");

            Assert.IsType<Ap>(ast);

            Assert.IsType<Atom>((ast as Ap).Function);
            Assert.IsType<Atom>((ast as Ap).Argument);

            Assert.Equal("inc", ((ast as Ap).Function as Atom).Value);
            Assert.Equal("1", ((ast as Ap).Argument as Atom).Value);
        }

        [Fact]
        public void WhenTextIsFromGalaxy_ThenReturnCorrectAST()
        {
            var ast = Parser.Parse("ap ap cons 2 ap ap cons 7 nil");

            Assert.IsType<Ap>(ast);

            Assert.IsType<Ap>((ast as Ap).Function);
            Assert.IsType<Ap>((ast as Ap).Argument);
        }
    }
}
