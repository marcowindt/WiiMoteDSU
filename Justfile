build:
    fvm flutter build ipa --release --no-codesign
    mkdir -p build/ios/ipa/Payload/
    mv build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app build/ios/ipa/Payload/ || echo "Run \`just clean\`"
    open build/ios/ipa/

build_debug:
    fvm flutter build ipa --debug --no-codesign
    mkdir -p build/ios/ipa/Payload/
    mv build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app build/ios/ipa/Payload/ || echo "Run \`just clean\`"
    open build/ios/ipa/

clean:
    rm -rf build/ios/ipa
