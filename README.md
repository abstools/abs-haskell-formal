# Formal translation of ABS-subset to Haskell

[![Build Status](https://travis-ci.org/abstools/abs-haskell-formal.svg)](https://travis-ci.org/abstools/abs-haskell-formal) [online API docs](http://abstools.github.io/abs-haskell-formal)

A library to write (embed) ABS-subset programs in Haskell, and execute them
at runtime by an included Haskell interpreter.

## Prerequisites

You need a fairly-recent [GHC compiler](http://haskell.org/ghc) or [Haskell Platform](http://haskell.org/platform)

## Installing this library

Run inside the repository directory:

```bash
cabal install
```

## Running the examples

The ABS-subset examples are under `examples/` directory, embedded as Haskell.
After installing this library, you can compile them with:

```
ghc --make examples/ExampleName.hs
```

Execute an example with:

```
./examples/ExampleName
```

which will output the number of steps executed, the final heap, and the heap counter, e.g.:

```
Real steps:	6
Total steps:	6
Object Heap with array-size:10{
(0,([(0,-123),(1,8),(2,1),(3,9),(4,1)],fromList []))
}
Future Heap with array-size:10{
(1,Right (-123))
}
Counter: 2
```

## Running the benchmarks

Assuming you have installed this library, you can run the benchmarks and obtaining the execution measurements by installing also the following tools:

a) the [Python](https://www.python.org/downloads/) interpreter (2.5 <= version < 3)
b) the [SACO](http://costa.ls.fi.upm.es/costabs/home.php) tool (stands for, Static Analyzer for Concurrent Objects)

Then, navigate under the benchmarks folder to a particular benchmark and run it by calling:

```bash
cd benchmarks/linear_high/
./bench.py
```

The execution time&steps measurements will be recorded in the same benchmark folder in `.dat` files.

## Building the API docs

Run inside the repository directory:

```bash
cabal configure
cabal haddock
```

The documentation will appear under `dist/doc/html`
