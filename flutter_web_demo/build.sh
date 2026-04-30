#!/bin/bash

# Build script for Flutter Web Demo

set -e

echo "Building Flutter Web Demo..."
echo ""

cd "$(dirname "$0")"

echo "Step 1: Getting dependencies..."
flutter pub get

echo ""
echo "Step 2: Building for web..."
flutter build web --release --base-href /RichTextEditorDemo/

echo ""
echo "✅ Build completed successfully!"
echo "Output directory: build/web/"
echo ""
echo "To test locally, run:"
echo "  cd build/web && python3 -m http.server 8000"
echo "Then open http://localhost:8000 in your browser"
