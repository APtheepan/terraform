#!/bin/bash
echo "Hello, World 2" > index.html
python3 -m http.server 8080 &