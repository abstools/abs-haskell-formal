# Formal translation of ABS-subset to Haskell

[![Build Status](https://travis-ci.org/abstools/abs-haskell-formal.svg)](https://travis-ci.org/abstools/abs-haskell-formal) [![License (3-Clause BSD)](https://img.shields.io/badge/license-BSD--3-blue.svg?style=flat)](http://opensource.org/licenses/BSD-3-Clause) [online API docs](http://abstools.github.io/abs-haskell-formal)

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

## Building the API docs

Run inside the repository directory:

```bash
cabal configure
cabal haddock
```

The documentation will appear under `dist/doc/html`
