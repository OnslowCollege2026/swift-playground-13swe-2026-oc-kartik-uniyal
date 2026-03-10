// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
    // Task A
    // List of stuff were given
    let mixed = ["Cat", "7", "Owl", "15", "Dog", "3"]

    // Using compact map to only keep the integers
    let numbers = mixed.compactMap {Int($0)}

    //Printing the numbers
    print(numbers)

    
    }
}
