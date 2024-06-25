#!/usr/bin/env bash
# https://github.com/mozilla/grcov
cd $1
export RUSTFLAGS="-Cinstrument-coverage"
find ./ -type f -name "*.profraw" -exec rm -rf {} \;
cargo clean
export LLVM_PROFILE_FILE="backend-%p-%m.profraw"
cargo test
grcov . -s . --binary-path ./target/debug/ -t html --branch --ignore-not-existing -o ./target/debug/coverage/ && \
live-server --mount=/:./target/debug/coverage/
