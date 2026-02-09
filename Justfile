build:
    fvm flutter build ipa --release --no-codesign
    mkdir -p build/ios/ipa/Payload/
    mv build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app build/ios/ipa/Payload/ || echo "Run \`just clean`"

clean:
    rm -rf build/ios/ipa
