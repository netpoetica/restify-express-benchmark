restify-express-benchmark
=========================

You can run this like so:

```
make requests=100000 concurrency=1000
```

NOTE: you must have `ab` & `gnuplot` installed and `GNU make` as well. Use homebrew to get these commands
if needed. Must be GNU version of `make` in order to use the "shell" command in Makefile.

All of these things can be installed via homebrew, but make should already be installed.
```
brew install gnuplot
brew install homebrew/apache/ab
```