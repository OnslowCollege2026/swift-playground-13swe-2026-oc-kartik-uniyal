// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPlayground",
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "SwiftPlayground"
        ),
    ]
)



let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]


struct SwiftPlayground {
    static fun main() {
        let lunches: (double) = [6.50, 8.00, 5.75, 9.20, 7.10]
    }
}

func CostEachDay(){
    for i in days 0..<days.count{
    print(days)    
    }
}