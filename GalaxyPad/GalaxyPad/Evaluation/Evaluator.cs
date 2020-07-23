using System;
using System.Collections.Generic;
using GalaxyPad.Evaluation.AST;

namespace GalaxyPad.Evaluation
{
    public sealed class Evaluator
    {
        private readonly Dictionary<string, Expression> symbolTable;

        public Evaluator() : this(new Dictionary<string, Expression>())
        {
        }

        public Evaluator(Dictionary<string, Expression> symbolTable)
        {
            this.symbolTable = symbolTable;
        }

        public Expression Evaluate(string text)
        {
            var ast = Parser.Parse(text);

            return Eval(ast);
        }

        private Expression Eval(Expression ast)
        {
            var originalAst = ast;
            while (true)
            {
                var updatedAst = TryEval(originalAst);
                if (updatedAst.Equals(originalAst))
                {
                    return updatedAst;
                }
                originalAst = updatedAst;
            }
        }

        private Expression TryEval(Expression ast)
        {
            if (ast is Atom astAtom)
            {
                if (symbolTable.TryGetValue(astAtom.Value, out var result)) return result;
            }

            if (ast is Ap appExpr)
            {
                var funcX = Eval(appExpr.Function);
                var x = appExpr.Argument;

                if (funcX is Atom fx)
                {
                    if (fx.Value == "inc")
                    {
                        return new Atom((ToNumber(Eval(x)) + 1).ToString());
                    }

                    if (fx.Value == "dec")
                    {
                        return new Atom((ToNumber(Eval(x)) - 1).ToString());
                    }

                    if (fx.Value == "neg")
                    {
                        return new Atom((-ToNumber(Eval(x))).ToString());
                    }
                }

                if (funcX is Ap apXFunc)
                {
                    var funcY = Eval(apXFunc.Function);
                    var y = apXFunc.Argument;

                    if (funcY is Atom fy)
                    {
                        if (fy.Value == "add")
                        {
                            return new Atom((ToNumber(Eval(x)) + ToNumber(Eval(y))).ToString());
                        }

                        if (fy.Value == "mul")
                        {
                            return new Atom((ToNumber(Eval(x)) * ToNumber(Eval(y))).ToString());
                        }

                        if (fy.Value == "div")
                        {
                            return new Atom((ToNumber(Eval(y)) / ToNumber(Eval(x))).ToString());
                        }

                        if (fy.Value == "f")
                        {
                            return Eval(x);
                        }
                    }

                    if (funcY is Ap apYFunc)
                    {
                        var funcZ = Eval(apYFunc.Function);
                        var z = apYFunc.Argument;

                        if (funcZ is Atom fz)
                        {
                            if (fz.Value == "s")
                            {
                                return new Ap(
                                    new Ap(
                                        z,
                                        x
                                    ),
                                    new Ap(
                                        y,
                                        x
                                    )
                                );
                            }
                        }
                    }
                }
            }

            return ast;
        }

        private int ToNumber(Expression expression)
        {
            if (expression is Atom e) return int.Parse(e.Value);

            throw new ArgumentException($"Not a number");
        }
    }
}