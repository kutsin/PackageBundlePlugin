// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PackageBundlePlugin",
    products: [
        .plugin(
            name: "PackageBundlePlugin",
            targets: ["PackageBundlePlugin"]
        )
    ],
    targets: [
        .plugin(
            name: "PackageBundlePlugin",
            capability: .buildTool(),
            dependencies: ["PackageBundleGenerator"]
        ),
        .executableTarget(name: "PackageBundleGenerator")
    ]
)
