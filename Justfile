import 'just-flake.just'

[doc("List all available just commands")]
default:
    just --list

[doc("Apply current host configuration")]
apply:
    ./assets/scripts/apply.sh

[doc("Generate .envrc for direnv")]
env:
	./assets/scripts/env.sh