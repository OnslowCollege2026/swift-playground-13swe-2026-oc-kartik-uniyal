// Programming Summataive assesment
// Created by Kartik Uniyal
// Created on 22/04/2026

import Foundation
import GRDB

/// shows a book record in rw3the data base
/// Each line repersents to a row in the books table
struct Book: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "bookTable"
    let id: Int?
    var title: String
    var genre: String
    var author: String

    func summary() -> String {
        return ("\(title): \(author): \(genre)")
    }

    enum CodingKeys: String, CodingKey {
        case id = "bookID"
        case title 
        case genre 
        case author 
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

    func summary() -> String {
        return ("\(id ?? 0): \(name) \(email) \(phone)")
    }
    enum CodingKeys: String, CodingKey {
        case id = "borrowerID"
        case name
        case phone 
        case email 
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
    let id: Int?
    var borrowerID: Int
    var bookID: Int
    var dateBorrowed: String
    var dateReturned: String?

    func summary() -> String {
        let returned = dateReturned ?? "Not returned"
        return "loan \(id ?? 0): Book \(bookID) Borrower \(borrowerID) \(returned)"
    }

    enum CodingKeys: String, CodingKey {
        case id = "loanID"
        case borrowerID
        case bookID
        case dateBorrowed 
        case dateReturned 

    }

    enum Columns {
        static let id = Column("loanID")
        static let borrowerID = Column("borrowerID")
        static let bookID = Column("bookID")
        static let dateBorrowed = Column("dateBorrowed")
        static let dateReturned = Column("dateReturned")
    }
}

func loanBook(bookID: Int, borrowerID: Int, dbQueue:DatabaseQueue) {
    do{
        try dbQueue.write {db in
        guard let borrower = try Borrower.fetchOne(db, key: borrowerID) else{
            print("Borrower not found")
            return

        guard let book = try Book.fetchOne(db, key: bookID) else {
            print("Book not found")
            return

        let activeLoan = try Loan
        .filter(LoanColumns.bookID == bookID && Loan.columns.dateReturned == nil)
        .fetchOne(db)

        guard activeLoan == nil else{
            print("Book is already on loan")
            return
        }

        let newLoan = Loan(
        id: nil,
        borrowerID: borrower.id,
        bookID: book.id, 
        dateBorrowed: currentDate(),
        dateReturned:nil
        )
        }
        }}
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
        ("Harry potter", "Fantasy", "J.K. Rowling"),
        ("The Hunger Games", "Dystopian", "Suzanne Collins"),
        ("Haiyku", "Poetry", "Unknown"),
        ("The Lord Of The Rings", "Fantasy", "J.R.R. Tolkien"),
        ("Attack On Titan", "Manga", "Hajime Isayama"),
        ("The Little Prince", "Fable", "Antoine de Saint-Exupéry"),
        ("Deathnote", "Manga", "Tsugumi Ohba"),
        ("My Hero Academia", "Manga", "Kohei Horikoshi"),
        ("Dragon Ball Z", "Manga", "Akira Toriyama"),
        ("Bleach", "Manga", "Tite Kubo"),
    ]
    try? dbQueue.write { db in
        for book in books {
            let exists =
                try Int.fetchOne(
                    db,
                    sql: "SELECT COUNT(*) FROM bookTable WHERE title = ?",
                    arguments: [book.0]
                ) ?? 0
            if exists == 0 {
                try db.execute(
                    sql: "INSERT INTO bookTable (title, genre, author) VALUES (?, ?, ?)",
                    arguments: [book.0, book.1, book.2]
                )
            }
        }
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
                            let book = Book(
                                id: row["bookID"] ?? 0,
                                title: row["title"],
                                genre: row["genre"],
                                author: row["author"]
                            )
                            print("\(book.id ?? 0): \(book.title)")
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
