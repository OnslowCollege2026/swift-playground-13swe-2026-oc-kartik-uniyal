// Programming Summataive assesment
// Created by Kartik Uniyal
// Created on 22/04/2026

import Foundation
import GRDB

/// shows a book record in rw3the data base
/// Each line repersents to a row in the books table
struct Book: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "bookTable"
    var id: Int
    var title: String
    var genre: String
    var author: String

    func summary () -> String{
    return ("\(id): \(title)")
}


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

struct Borrower: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "borrowerTable"
    let id: Int?
    var name: String
    var phone: String
    var email: String

func summary () -> String{
    return ("\(id ?? 0): \(name) \(email) \(phone)")
}
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

struct loan: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "loansTable"
    var id: Int
    var borrowerID: Int
    var bookID: Int
    var dateBorrowed: String
    var dateReturned: String

    func summary() -> String{
        let returned = dateReturned ?? "Not returned"
        return "loan \(id ?? 0): Book \(bookID) Borrower \(borrowerID \(returned))"
    }

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

    if let bookID = Int(input) {
        try? dbQueue.write { db in
            try db.execute(
                sql: "INSERT INTO loansTable (bookID) VALUES (?)",
                arguments: [bookID]
            )
        }
        print("Book borrowed")
    } else {
        print("Invalid ID")
    }
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
    do {
        try dbQueue.write { db in
            for book in books {
                try db.execute(
                    sql: "INSERT INTO bookTable (title, genre, author) VALUES (?, ?, ?)",
                    arguments: [book, "Unknown", "Unknown"]
                )
            }
        }
    } catch {
        print("INSERT ERROR", error)
    }
}

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "Sources/SwiftPlayground/bookLibaryDatabase.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbPath)
            try dbQueue.read { db in
                let count = try Int.fetchOne(db, sql: "SELECT COUNT (*) FROM bookTable") ?? 0
                print("Book count: \(count)")
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
                        let rows = try Row.fetchAll(db, sql: "SELECT * FROM bookTable")
                        print("\nBooks in libary:")
                        for row in rows {
                            let book = bookTable(
                            id: row["bookID"],
                            title: row["title"],
                            genre: row["genre"],
                            author: row["author"]
                            )
                            print(book.summary())
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

///func bookOptions(dbQueue: DatabaseQueue) {
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

 ///   try? dbQueue.write { db in
 //       for book in books {
   //         try db.execute(
     //           sql: "INSERT INTO bookTable (title) VALUES (?)",
           //     arguments: [book]
         //   )
       // }
//    }
//}
