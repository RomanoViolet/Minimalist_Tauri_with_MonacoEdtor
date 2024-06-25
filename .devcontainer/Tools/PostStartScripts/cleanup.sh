#!/usr/bin/env bash
# https://github.com/mozilla/grcov

npm cache clean --force
cd $1/"src-tauri"
find ./ -type f -name "*.profraw" -exec rm -rf {} \;
cargo clean
