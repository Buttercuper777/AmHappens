#!/bin/bash

# Function to check the success of the command
check_success() {
    if [ $? -ne 0 ]; then
        echo "🔴 Error at step: $1"
        exit 1
    fi
}

# Step 1: Initialize submodules
echo "⚪️ Initializing submodules..."
git submodule update --init --recursive
check_success "initializing submodules"

# Step 2: Update all submodules to the latest version
echo "⚪️ Updating submodules..."
git submodule update --remote
check_success "updating submodules"

# Step 3: Create a virtual environment for the backend
echo "⚪️ Creating virtual environment for backend..."
cd ./backend
python3 -m venv venv  # Create virtual environment
check_success "creating virtual environment for backend"

# Step 4: Activate the virtual environment
echo "⚪️ Activating virtual environment..."
source venv/bin/activate
check_success "activating virtual environment"

# Step 5: Install dependencies for the backend
echo "⚪️ Installing dependencies for backend..."
pip install -r requirements.txt
check_success "installing dependencies for backend"

# Step 6: Install dependencies for the frontend
echo "⚪️ Installing dependencies for frontend..."
cd ../frontend
npm install
check_success "installing dependencies for frontend"
cd ..

# Step 7: Build the whisper.cpp library if necessary
echo "⚪️ Checking if whisper.cpp needs to be built..."
cd whisper/whisper.cpp

# Check if main or whisper-cli already exists
if [ ! -f "main" ] && [ ! -f "whisper-cli" ]; then
    echo "⚪️ Building whisper.cpp library..."
    make
    check_success "building whisper.cpp"

    # Copy the built files to the whisper folder
    echo "⚪️ Copying built files to the whisper folder..."
    cp build/bin/main ..
    cp build/bin/whisper-cli ..

else
    echo "🟢 whisper.cpp already built. Skipping build step."
fi
cd ../..

# Step 8: All done!
echo "🟢 Project initialization completed successfully!"

# Deactivate the virtual environment
deactivate
