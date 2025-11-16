import 'just-flake.just'

[doc("List all available just commands")]
default:
    just --list

[doc("Apply current host configuration")]
apply:
    ./assets/scripts/apply.sh
