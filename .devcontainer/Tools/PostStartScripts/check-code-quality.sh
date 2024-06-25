#!/usr/bin/env bash
cd $1
echo ""
echo ""
echo "----------- Running Code Bloat Checks ------------"
cargo bloat --release -n 20
echo ""
echo ""
echo ""
echo "----------- Running Code Quality Checks ------------"
cargo checkmate
echo ""
echo ""
echo "-------------------- Done --------------------------"

