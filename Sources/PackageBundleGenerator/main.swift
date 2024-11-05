import Foundation

// Some insight into the problem and the implemented solution.
// https://developer.apple.com/forums/thread/664295

let arguments = ProcessInfo().arguments
let (packageName, targetName, output) = (arguments[1], arguments[2], arguments[3])

let generatedCode = """
import class Foundation.Bundle
import class Foundation.ProcessInfo
import struct Foundation.URL

private class BundleFinder {}

extension Bundle {
    public static let package: Bundle = {
        let bundleName = "\(packageName)_\(targetName)"

        let overrides: [URL]
        #if DEBUG
        // The 'PACKAGE_RESOURCE_BUNDLE_PATH' name is preferred since the expected value is a path. The
        // check for 'PACKAGE_RESOURCE_BUNDLE_URL' will be removed when all clients have switched over.
        // This removal is tracked by rdar://107766372.
        if let override = ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_PATH"]
            ?? ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_URL"] {
            overrides = [URL(fileURLWithPath: override)]
        } else {
            overrides = []
        }
        #else
        overrides = []
        #endif

        var candidates = overrides + [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL
        ]

        // FIX FOR PREVIEWS
        // if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            candidates.append(contentsOf: [
                // Bundle should be present here when running previews from a different package
                Bundle(for: BundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
                Bundle(for: BundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            ])
        // }
        
        print("+=+=+=+=+=+")
        print(candidates)

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        fatalError("unable to find bundle named \(packageName)_\(targetName)")
    }()
}
"""
try generatedCode.write(to: URL(fileURLWithPath: output), atomically: true, encoding: .utf8)
