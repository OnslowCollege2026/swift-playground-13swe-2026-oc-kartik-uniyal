// Programming Summataive assesment
// Created by Kartik Uniyal
// Created on 22/04/2026

import Foundation
import GRDB

/// shows a book record in rw3the data base
/// Each line repersents to a row in the books table
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

/// Shows the main menu options for the libary
func showMenu() {
    print(
        """
        \nLibrary System
        1.Borrow book
        2.View books
        3.Exit
        """)
}

func borrowBook(dbQueue: DatabaseQueue) {
    print("Enter the ID of the book you would like to borrow:")
    let input = readLine() ?? ""
    let bookID = Int(input)

    try? dbQueue.write { db in
        try db.execute(
            sql: "INSERT INTO loans (bookID) VALUES (?)",
            arguments: [bookID]
        )
    }
    print("Book borrowed")
}

func bookOptions(dbQueue: DatabaseQueue) {
    let books = [
        "Harry potter",
        "The Hunger Games",
        "Haiyku",
        "The Lord Of The Rings",
        "Attack On Titan",
        "The Little Prince",
        "Deathnote",
        "My Hero Academia",
        "Dragon Ball Z",
        "Bleach",
    ]

    try? dbQueue.write { db in
        for book in books {
            try db.execute(
                sql: "INSERT INTO books (title) VALUES (?)",
                arguments: [book]
            )
        }
    }
}

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "./library.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbPath)
            try dbQueue.write { db in

                /// Creates the bookd table to store the books in
                try db.create(table: "books", ifNotExists: true) { t in
                    t.autoIncrementedPrimaryKey("id")
                    t.column("title", .text).notNull()
                }

                /// Creates the loans table to store the borrowed books
                try db.create(table: "loans", ifNotExists: true) { t in
                    t.autoIncrementedPrimaryKey("id")
                    t.column("bookID", .integer)
                }
            }

            bookOptions(dbQueue: dbQueue)
            var isRunning = true
            while isRunning {
                showMenu()
                let choice = readLine()

                switch choice {
                case "1":
                    borrowBook(dbQueue: dbQueue)

                case "2":
                    try dbQueue.read { db in
                        let rows = try Row.fetchAll(db, sql: "SELECT * FROM books")
                        print("\nBooks in libary:")
                        for row in rows {
                            let id: Int = row["id"]
                            let title: String = row["title"]
                            print("\(id): \(title)")
                        }
                    }
                case "3":
                    isRunning = false
                    print("Goodbye")

                default:
                    print("Invalid option")
                }
            }
        } catch {
            print("Database error: \(error)")
        }
    }

}
