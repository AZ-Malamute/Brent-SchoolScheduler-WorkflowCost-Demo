// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BrentSchedulerApp",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "BrentSchedulerApp", targets: ["BrentSchedulerApp"])
    ],
    targets: [
        .executableTarget(name: "BrentSchedulerApp")
    ]
)
