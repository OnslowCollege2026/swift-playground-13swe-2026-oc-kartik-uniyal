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

    // Sightings list
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
    print("------------")
    // Printing the total
    print(total)

    // Task C
    func accepts (_ input: String, isValid: (String) -> Bool) -> Bool {
    return isValid(input)
}
    // Sample one that checks if the word is lowercased
    let sample = accepts("moonlight") {
        word in return word == word.lowercased()
    }

    // Sample two that checks if it more than 8 letters
    let sample2 = accepts("moonlight") {
        word in return word.count > 8
    }

    print("-----------")

    // Printing both samples
    print(sample)
    print(sample2)

    // Task D

    // Archive list
    let archive = [
    [
        [["candle", "dust"], ["mirror", "ash"]],
        [["whisper", "shadow"], ["clock", "veil"]]
    ],
    [
        [["stone", "key"], ["relic", "name"]],
        [["cipher", "bone"], ["ember", "seal"]]
    ],
    [
        [["feather", "ink"], ["glow", "eclipse"]],
        [["riddle", "echo"], ["ember", "glyph"]]
    ]
]

    //

    } 
}