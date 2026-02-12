// The Swift Programming Language
// https://docs.swift.org/swift-book

// Minimum scores to pass
let MinimumPassingScores = 50
// Extra points for scores above 50
let ExtraPoints = 5
@main
struct SwiftPlayground {
    static func main() {
        let numbers = [45, 78, 89, 32, 50, 92, 67, 41, 99, 56]
        // Cured the scores then only accepeting scores over 50
        let total = numbers.map { $0 + ExtraPoints}.filter { $0 >= MinimumPassingScores}
        // Reduce the passing scores 
        let sum = total.reduce (0, + )
        // Printing the total score
        print(sum/total.count)
    }
}
