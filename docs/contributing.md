---
title: Contributing to the Haskell Phrasebook
---

# Contributing

We're delighted by contributions of all sizes:

  - A request for a topic you'd like to see covered;
  - A complete code example showing off a language feature, library, or technique you use;
  - Anything in betweeen.

**You do not need to be a Haskell expert to contribute.** Give us your thoughts, your hopes, your confusions, your code, and its imperfections; we'll help polish it up.

## Content guidelines

Each Phrasebook example should define a `main` action which prints something that demonstrates the program's behavior. Aim for small examples that are just long enough to illustrate one idea.

The Phrasebook is modeled after [Go by Example](https://gobyexample.com/) and [Rust by Example](https://doc.rust-lang.org/rust-by-example/index.html); if you'd like to contribute and need inspiration, you can look at those sources for topic ideas.

We believe that Haskell is not so different from any other language that learning it would require unlearning everything else that one may already know about programming. Our goal in this project is not to focus on what makes Haskell unique, but to build bridges to familiar concepts.

Each page of the Phrasebook demonstrates a particular thing that someone who doesn't know Haskell might be wondering how to do. For example:

  - "Introduction to optics" would not be appropriate as a Phrasebook topic (because a potential reader is unlikely to know what they would *want* to learn about optics);
  - "Working with JSON data" would be a good topic (and the example program might incidentally showcase optics).

The [Phrasebook](https://typeclasses.com/phrasebook) itself includes explanations next to the code examples. We'll appreciate some explanation of code you contribute, but don't worry too much about this part; we'll write the Phrasebook's text to maintain a consistent style.

## Social values

The Phrasebook is run by [Type Classes](https://typeclasses.com/company), which consists of [Julie Moronuki](https://github.com/argumatronic/) and [Chris Martin](https://github.com/chris-martin/). This project serves as our primary introduction for Haskell newcomers, and we want contributors to care about helping all people who may read the Phrasebook.

The aim of the Phrasebook naturally invites comparisons between Haskell and other languages; we will not tolerate needless disparagement of any programming ecosystems. We love learning about the differences between languages, and we obviously have our own preferences among them, but undue emphasis on value judgements tends to incidentally insult entire degrees and careers.

## License

All of the code in this repository is offered under the Creative Commons [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) license, which allows free non-commercial use with attribution. We will only accept contributions that are licensed under these same terms.

## Detailed content guidelines for perfectionists

Try to minimize the prerequisite knowledge for each example program.

Introduce new library dependencies as necessary, but try to stick to [the libraries we have chosen](https://typeclasses.com/phrasebook#libraries).

Use language extensions as necessary, but not to excess.

  - [`LambdaCase`](https://typeclasses.com/phrasebook/invert) is always acceptable.
  - When [a deriving extension](https://typeclasses.com/phrasebook/hash) is required, also enable `DerivingStrategies` and use an explicit strategy on each `deriving` clause.
  - Use `NumericUnderscores` when writing large numeric literals such as a [number of microseconds](https://typeclasses.com/phrasebook/timeouts).

Don't include quite as many type signatures as you might in typical code.

Use the `($)` operator for multi-line arguments (see the [For loops](https://typeclasses.com/phrasebook/for-loops) page for numerous examples of this). Do not use the `BlockOperators` extension. For single-line expressions, use parentheses.

The maximum line length is 68 characters. (This constraint is imposed by the format of the website.)
