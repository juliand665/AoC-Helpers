// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AoC-Helpers",
	platforms: [
		.macOS("11"),
		.iOS("14"),
	],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AoC-Helpers",
            targets: ["AoC-Helpers"]
		),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/juliand665/HandyOperators", from: "2.0.0"),
		.package(url: "https://github.com/juliand665/SimpleParser", branch: "main"),
		.package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AoC-Helpers",
			dependencies: [
				"HandyOperators",
				"SimpleParser",
				.product(name: "Algorithms", package: "swift-algorithms")
			]
		),
    ]
)
