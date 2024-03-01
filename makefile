prep_release:
	dart pub publish --dry-run
	dart format .
	dart analyze
	dart doc .

