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

    // Printing the numbers
    print(numbers)

    // Task B

    let sightings = [
        (name: "moth", score:3),
        (name: "wolf", score:9),
        (name: "raven", score:4),
        (name: "mist", score:7),
        (name: "wisp", score:2)
    ]

    // Using filter to only get the m and w sightings
    let filterSightings = sightings.filter { 
        $0.name.hasPrefix("m") || $0.name.hasPrefix("w")
    }

    // Using filter to only keep the numbers
    let extractedScores = filterSightings.map { $0.score }

    // Using reduce to add all the numbers
    let total = extractedScores.reduce(0,+)

    // Printing the total
    print(total)

    // Task C

    } 
}

func accepts ( input: String, )