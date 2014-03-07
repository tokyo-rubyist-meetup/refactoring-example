This is an exercise to refactor legacy code.

Refactoring is the process of making code nicer, while leaving the functionality the same.

You can run the example program with `ruby refactoring_runner.rb`. Try it a couple times.

You'll see that the output is pretty arbitrary - that's because it is.

The first step before you refactor code is to make sure there is good test coverage to make sure while improving the code, you don't break any existing functionality

For this exercise, we've already provided a test suite that runs the program many times and records the output. That way you can then replay the program again later to make sure nothing has changed.

Record the output with `ruby refactoring_runner.rb -r` and then use `ruby refactoring_runner.rb -t` to test it.

For purposes of this exercise, only refactor code found in [correct_answer_behavior.rb](correct_answer_behavior.rb).

# Source

This code is based on https://gist.github.com/mehowte/3139247 which was based on
Trivia Game example used in Legacy Code Retreats.

That example is found at https://github.com/jbrains/trivia.
