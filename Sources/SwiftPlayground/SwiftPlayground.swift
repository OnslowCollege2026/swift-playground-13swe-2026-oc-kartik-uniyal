// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        let numbers = [45, 78, 89, 32, 50, 92, 67, 41, 99, 56]
        // Curving each score by 5
        let total = numbers.map { number in
            return number + 5
        // Filtering the number to only accept 50 or more
        }.filter { number in
            return number >= 50
        // Calculating the average scores
        }.reduce(0) { result, number in
            return result + number
        }
        // Printing the total score
        print(total/8)
    }
}
