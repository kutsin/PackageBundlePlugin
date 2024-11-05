import PackagePlugin
import Foundation

//@main
//struct PackageBundlePlugin: BuildToolPlugin {
//    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
//        guard target.sourceModule != nil else { return [] }
//
//        let output = context.pluginWorkDirectoryURL.appending(queryItems: [URLQueryItem(name: "PackageBundle.g.swift", value: nil)])
//        
//        print("+=+=+=+=+=+ \(output)")
//
//        return [
//            .buildCommand(
//                displayName: "Generating package bundle extension for \(target.name)",
//                executable: try context.tool(named: "PackageBundleGenerator").url,
//                arguments: [],
//                environment: [:],
//                inputFiles: [],
//                outputFiles: [output]
//            )
//        ]
//    }
//}

@main
struct PackageBundlePlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard target.sourceModule != nil else { return [] }

        let output = context.pluginWorkDirectory.appending(subpath: "PackageBundle.g.swift")

        return [
            .buildCommand(
                displayName: "Generating package bundle extension for \(target.name)",
                executable: try context.tool(named: "PackageBundleGenerator").path,
                arguments: [
                    context.package.displayName,
                    target.name,
                    output,
                ],
                inputFiles: [],
                outputFiles: [output]
            )
        ]
    }
}
