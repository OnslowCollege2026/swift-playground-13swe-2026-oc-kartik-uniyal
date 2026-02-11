// The Swift Programming Language
// https://docs.swift.org/swift-book

// Average scores to pass
let ScoresAbove50 = 8
// Extra points for scores above 50
let ExtraPoints = 5
// Minimum oassing scores
let PassingScore = 50
@main
struct SwiftPlayground {
    static func main() {
        let numbers = [45, 78, 89, 32, 50, 92, 67, 41, 99, 56]
        // Curving each score by 5
        let total = numbers.map { number in
            return number + ExtraPoints
        // Filtering the number to only accept 50 or more
        }.filter { number in
            return number >= PassingScore
        // Calculating the average scores
        }.reduce(0) { result, number in
            return result + number
        }
        // Printing the total score
        print(total/ScoresAbove50)
    }
}
