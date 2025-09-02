#!/usr/bin/env bash
set -e
rm -rf build
mkdir -p build
python3 -m venv build/venv
# activate venv if needed: . build/venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt -t build/
cp app.py build/
cd build
zip -r ../personas_lambda.zip .
cd ..
echo "Created personas_lambda.zip"
