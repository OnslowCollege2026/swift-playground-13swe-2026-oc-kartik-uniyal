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

struct Loan: Identifiable, Codable, FetchableRecord, PersistableRecord {
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
func currentDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: Date())
}

func loanBook(bookID: Int, borrowerID: Int, dbQueue:DatabaseQueue) {
    do{
        try dbQueue.write {db in
        guard let borrower = try Borrower.fetchOne(db, key: borrowerID) else{
            print("Borrower not found")
            return
        }
        guard let book = try Book.fetchOne(db, key: bookID) else {
            print("Book not found")
            return
        }

        let activeLoan = try Loan
        .filter(Loan.Columns.bookID == bookID && Loan.Columns.dateReturned == nil)
        .fetchOne(db)

        guard activeLoan == nil else{
            print("Book is already on loan")
            return
        }
        guard let borrowerIDValue = borrower.id,
        let bookIDValue = book.id else{
            print("Data error: Missing ID")
            return
        }

        let newLoan = Loan(
        id: nil,
        borrowerID: borrowerIDValue,
        bookID: bookIDValue, 
        dateBorrowed: currentDate(),
        dateReturned:nil
        )
        try newLoan.insert(db)
        print("Loan sueccful")
        }
        } catch{
            print("Database error")
        }
    }


/// Shows the main menu options for the libary
func showMenu() {
    print("""
    ========================
        Library System
    ========================
    1.Borrow book
    2.Return a book
    3.Search a book
    4.View all books
    5.Exit
    
    Enter option:
    """)
}

func borrowBook(dbQueue: DatabaseQueue) {
    print("Enter the ID of the book you would like to borrow:")
    guard let bookInput = readLine(),
    let bookID = Int(bookInput) else {
        print("Invalid book ID")
        return
    }

    print("Enter borrower ID: ")
    guard let borrowerInput = readLine(),
    let borrowerID = Int(borrowerInput) else{
        print("Invalid borrower ID")
        return
    }

    loanBook(bookID: bookID, borrowerID: borrowerID, dbQueue: dbQueue)
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

func returnBook (loanID: Int, dbQueue: DatabaseQueue) {
    do{
        try dbQueue.write {db in 
        guard var loan = try Loan.fetchOne(db, key: loanID) else {
            print("Loan not found")
            return
        }
        guard loan.dateReturned == nil else {
            print("Book already returned")
            return
        }
        loan.dateReturned = currentDate()
        try loan.update(db)
        print("Book successfully returned")
        }
    } catch{
        print("Database error")
    }
}

func searchBook(bookSearch: String, dbQueue: DatabaseQueue){
    do{
        try dbQueue.read { db in 
        let books = try Book.fetchAll(db)
        var found = false
        
        for book in books{

            if bookSearch.isEmpty ||
            book.title.lowercased().contains(bookSearch.lowercased()),
            book.author.lowercased().contains(bookSearch.lowercased()) {

            let currentLoan = try Loan
            .filter(Loan.Columns.bookID == book.id && Loan.Columns.dateReturned == nil)
            .fetchOne(db)

            let status: String
            if (currentLoan == nil){
            status = "Available"
            } else {
                status = "On loan"
            }
            

            print("\(book.summary()), \(status)")
            found = true
            }
        }
        if found == false{
            print("No books were found")
        }
        }
    }catch{
        print("Database error")
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
                print("Enter loan ID")
                guard let input = readLine(),
                let loanID = Int(input) else{
                    print("Invalid loan ID")
                    return
                }
                returnBook(loanID: loanID, dbQueue: dbQueue)
                case "3":
                    print("Enter book titleor author")
                    let search = readLine() ?? ""
                    searchBook(bookSearch: search, dbQueue: dbQueue)
                case "4":
                try dbQueue.read { db in 
                let books = try Book.fetchAll(db)
                for book in books{
                    print(book.summary())
                    }
                }
                case "5":
                isRunning = false
                print("Goodbye, thank you")
                default:
                    print("Invalid option")
                }
            }
        } catch {
            print("Database error: \(error)")
        }
    }

}
