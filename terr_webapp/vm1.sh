#!/bin/bash
echo "Hello, World 1" > index.html
python3 -m http.server 8080 &