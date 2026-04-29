// Programming Summataive assesment
// Created by Kartik Uniyal
// Created on 22/04/2026

import Foundation
import GRDB

struct bookTable: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var title: String
    var genre: String
    var author: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "title"
        case genre = "genre"
        case author = "author"
    }

    enum Columns {
        static let id = Column("bookID")
        static let title = Column("title")
        static let genre = Column("genre")
        static let author = Column("author")
    }
}

struct borrowerTable: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var name: String
    var phone: String
    var email: String

    enum CodingKeys: String, CodingKey {
        case id = "borrowerID"
        case name = "name"
        case phone = "phone"
        case email = "email"
    }

    enum Columns {
        static let id = Column("borrowerID")
        static let name = Column("name")
        static let phone = Column("phone")
        static let email = Column("email")
    }
}

struct loansTable: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var borrowerID: Int
    var bookID: Int
    var dateBorrowed: String
    var dateReturned: String

    enum CodingKeys: String, CodingKey {
        case id = "loanID"
        case borrowerID = "borrowerID"
        case bookID = "bookID"
        case dateBorrowed = "dateBorrowed"
        case dateReturned = "dateReturned"

    }

    enum Columns {
        static let id = Column("loanID")
        static let borrowerID = Column("borrowerID")
        static let bookID = Column("bookID")
        static let dateBorrowed = Column("dateBorrowed")
        static let dateReturned = Column("dateReturned")
    }
}

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "./library.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbPath)
            try dbQueue.write { db in
                try db.create(table: "books", ifNotExists: true) { t in
                    t.autoIncrementedPrimaryKey("id")
                    t.column("title", .text).notNull()
                }
            }
            print("Do you want to add a book? y/n")
            let response = readLine()
            if response == "y" {    
                print("Please Enter the title of the book:")
                let title = readLine() ?? ""

                try dbQueue.write { db in
                    try db.execute(
                        sql: "INSERT INTO books (title) VALUES (?)",
                        arguments: [title]
                    )
                }
                print("Book succsesfully added")
            }
        } catch {
            print("Database error: \(error)")
        }
    }
}
