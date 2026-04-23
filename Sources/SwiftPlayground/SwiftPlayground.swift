// Programming Summataive assesment
// Created by Kartik Uniyal
// Created on 22/04/2026

import GRDB
import Foundation

struct bookTable: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var title: String
    var genre: String
    var author: String

    enum CodingKeys: String, CodingKey {
        case id = "bookID"
        case title = "title"
        case genre = "genre"
        case author = "author"
    }
}

struct borrowerTable: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var name: String
    var phone: String
    var email: String

    enum CodingKeys: String, CodingKey{
        case id = "borrowerID"
        case name = "name"
        case phone = "phone"
        case email = "email"
    }
}

struct loansTable: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var borrowerID: Int
    var bookID: Int
    var dateBorrowed: String
    var dateReturned: String

    enum CodingKeys: String, CodingKey{
        case id = "loanID" 
        case borrowerID = "borrowerID" 
        case bookID = "bookID"
        case dateBorrowed = "dateBorrowed"
        case dateReturned = "dateReturned"

    }
}

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "./library.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Could not open database.")
    do {
        let dbQueue = try DatabaseQueue(path: "./libary.db")
        try dbQueue.write { db in 
            try db.create(table: "books") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text),notNull()
    }}
} catch{
    print("Database error: \(error)")
}
}
    }
        }