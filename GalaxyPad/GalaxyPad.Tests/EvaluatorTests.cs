using System;
using System.Collections.Generic;
using Xunit;
using GalaxyPad.Evaluation;
using GalaxyPad.Evaluation.AST;

namespace GalaxyPad.Tests
{
    public class EvaluatorTests
    {
        [Fact]
        public void WhenTextIsNumber_ThenReturnAtom()
        {
            var evaluator = new Evaluator();

            var result = evaluator.Evaluate("42");

            Assert.IsType<Atom>(result);
            Assert.Equal("42", (result as Atom).Value);
        }

        [Fact]
        public void WhenIncrementOne_ThenReturnAtomTwo()
        {
            var evaluator = new Evaluator();

            var result = evaluator.Evaluate("ap inc 1");

            Assert.IsType<Atom>(result);
            Assert.Equal("2", (result as Atom).Value);
        }

        [Fact]
        public void WhenDecrementOne_ThenReturnAtomZero()
        {
            var evaluator = new Evaluator();

            var result = evaluator.Evaluate("ap dec 1");

            Assert.IsType<Atom>(result);
            Assert.Equal("0", (result as Atom).Value);
        }

        [Fact]
        public void WhenNeg42_ThenReturnAtomNegative42()
        {
            var evaluator = new Evaluator();

            var result = evaluator.Evaluate("ap neg 42");

            Assert.IsType<Atom>(result);
            Assert.Equal("-42", (result as Atom).Value);
        }

        [Fact]
        public void WhenAddTwoNums_ThenReturnAtomOfTheirSum()
        {
            var evaluator = new Evaluator();

            var result = evaluator.Evaluate("ap ap add 1 2");

            Assert.IsType<Atom>(result);
            Assert.Equal("3", (result as Atom).Value);
        }

        [Fact]
        public void WhenMultiplyTwoNums_ThenReturnAtomOfTheirProduct()
        {
            var evaluator = new Evaluator();

            var result = evaluator.Evaluate("ap ap mul 4 8");

            Assert.IsType<Atom>(result);
            Assert.Equal("32", (result as Atom).Value);
        }

        [Fact]
        public void WhenDivideTwoNums_ThenReturnAtomOfTheirDivision()
        {
            var evaluator = new Evaluator();

            var result = evaluator.Evaluate("ap ap div -5 -3");

            Assert.IsType<Atom>(result);
            Assert.Equal("1", (result as Atom).Value);
        }

        [Fact]
        public void LastTestFromVideo1()
        {
            var evaluator = new Evaluator();

            var result = evaluator.Evaluate("ap dec ap ap add 1 2");

            Assert.IsType<Atom>(result);
            Assert.Equal("2", (result as Atom).Value);
        }

        [Fact]
        public void TestFromVideo3()
        {
            var evaluator = new Evaluator();

            var result = evaluator.Evaluate("ap ap ap s mul ap add 1 6");

            Assert.IsType<Atom>(result);
            Assert.Equal("42", (result as Atom).Value);
        }
    }
}
