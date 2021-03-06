#!/usr/bin/env bash

# Install frontend dependencies
frontend() {
    chmod +x ./frontend.sh
    ./frontend.sh development
}

# Install backend dependencies
backend() {
    pip install -r requirements/travis.txt
}

docs() {
    pip install -r requirements/docs.txt
}

echo "installing $RUNTEST dependencies"
if [ "$RUNTEST" == "frontend" ]; then
    frontend
    backend
elif [ "$RUNTEST" == "backend" ]; then
    backend
elif [ "$RUNTEST" == "backend3" ]; then
    backend
elif [ "$RUNTEST" == "docs" ]; then
    docs
fi
