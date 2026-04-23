// Programming Summataive assesment
// Created by Kartik Uniyal
// Created on 22/04/2026

import GRDB
import Foundation

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "./library.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Could not open database.")
        }
    }
}
