#!/bin/zsh

dart run build_runner build -d
cd example && dart run build_runner build -d
