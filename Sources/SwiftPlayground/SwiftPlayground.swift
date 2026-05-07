// Programming Summataive assesment
// Created by Kartik Uniyal
// Created on 22/04/2026

import Foundation
import GRDB

/// Reepersents a book in the libary database
/// Each line repersents to a row in the books table
/// Maps the books table from the GRDB
struct Book: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "bookTable"

    // Auto assigned primary key
    let id: Int?
    // Title of the book
    var title: String
    //Genre of the book
    var genre: String
    // Author of the book
    var author: String

    // Returns a formtted string of the book details
    func summary() -> String {
        return ("\(id ?? 0) | \(title) | \(author) | \(genre)")
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
/// Repersents a registered libary memeber who can borrow books
/// Stored in borrower table
struct Borrower: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "borrowerTable"

    // Auto generated primary key
    let id: Int?
    // Name of the borrower 
    var name: String
    // Phone number of the borrower
    var phone: String
    // Email of the borrower
    var email: String

    // Returns a formatted borrower details
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

/// Repersents a loan linking a borrower to a borrowed book
/// Tracks when a book is borrowed and returned
struct Loan: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "loansTable"

    // Auto generated primary key
    let id: Int?
    // A foregin key referencing to borrowers.ID
    var borrowerID: Int
    // A foregin ley referencing to book.ID
    var bookID: Int
    // The date of issue for the book (dd/mm/yyyy)
    var dateBorrowed: String
    // Date of when the book was returned with nil meaning its still on loan
    var dateReturned: String?

    // Retruns formatted loan details
    func summary() -> String {
        let returned = dateReturned ?? "Not returned"
        return "loan \(id ?? 0): Book \(bookID) Borrower \(borrowerID) \(returned)"
    }
    // Confoirms to codeable
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

/// Returns the current date in dd/MM/yyyy format 
/// 
/// This function uses a dateformatter into real human time
/// 
/// - Returns: A string that shows todays date
func currentDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: Date())
}

/// Creates a new loan record and links borrower to book
/// 
/// This function checks
/// Parameters:
///     - bookID: The id of the book being borrowed
///     - borrowererID: The id of the borrower who requests the book.
///     - dbQueue: The database connection used to read and write data.
func loanBook(bookID: Int, borrowerID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

            // Prevents creating loans for invalid useres
            guard let borrower = try Borrower.fetchOne(db, key: borrowerID) else {
                print("Borrower not found")
                return
            }
            // Prevents creating loans for missing books
            guard let book = try Book.fetchOne(db, key: bookID) else {
                print("Book not found")
                return
            }

            // Loan being active if dateReturned is nil
            let activeLoan =
                try Loan
                .filter(Loan.Columns.bookID == bookID && Loan.Columns.dateReturned == nil)
                .fetchOne(db)

            // If a loan alrady exsist, stops new loan creation
            guard activeLoan == nil else {
                print("Book is already on loan")
                return
            }

            // Links borrower and book, also sets current date as  the borrow date
            guard let borrowerIDValue = borrower.id,
                let bookIDValue = book.id
            else {
                print("Data error: Missing ID")
                return
            }

            let newLoan = Loan(
                id: nil,
                borrowerID: borrowerIDValue,
                bookID: bookIDValue,
                dateBorrowed: currentDate(),
                dateReturned: nil
            )

            /// Complete the process and insert into database
            try newLoan.insert(db)
            print("Loan sueccful")
        }
    } catch {
        print("Database error")
    }
}

/// Shows the main menu options for the libary
func showMenu() {
    print(
        """
        ========================
            Library System
        ========================
        1.Borrow book
        2.Return a book
        3.Search a book
        4.View all books
        5.Add borrower
        6.View borrowers
        7.Edit book
        8.Delet book
        9.Exit

        Enter option:
        """)
}

/// Hnadles the process of borrowing by taking user input
/// 
/// - Parameter dbQueue: The database connection used to process the loan
func borrowBook(dbQueue: DatabaseQueue) {

    // Ask the user for the book ID
    print("Enter the ID of the book you would like to borrow:")

    // Validates the book ID input 
    guard let bookInput = readLine(),
        let bookID = Int(bookInput)
    else {
        print("Invalid book ID")
        return
    }

    // Ask the user for the borrower ID
    print("Enter borrower ID: ")

    // Validate the borrower ID
    guard let borrowerInput = readLine(),
        let borrowerID = Int(borrowerInput)
    else {
        print("Invalid borrower ID")
        return
    }

    // Create loan recordsusing inputs
    loanBook(bookID: bookID, borrowerID: borrowerID, dbQueue: dbQueue)
}

/// marks the loan as returned by setting the return date to today
/// 
///  - Parameters:
///     - loanID: The ID of the loan that is being returned
///     - dbQueue: The database connection used t read and update the stuff
func returnBook(loanID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in
            // Checks if the loan exsist in the databse
            guard var loan = try Loan.fetchOne(db, key: loanID) else {
                print("Loan not found")
                return
            }

            // Stops a already returned book from returning
            guard loan.dateReturned == nil else {
                print("Book already returned")
                return
            }

            // Makes todays date as the current datae
            loan.dateReturned = currentDate()
            
            // Saves the changes to the database
            try loan.update(db)
            print("Book successfully returned")
        }
    } catch {
        print("Database error")
    }
}

/// Searchs for books by the title, author, and genre 
/// 
/// - Parameters:
///     - bookSearch: The input from the user to to search for books
///     - dbQueue: The database connection to used to loan data and read the book
func searchBook(bookSearch: String, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.read { db in
            // Get all books from the database
            let books = try Book.fetchAll(db)
            var found = false
            
            // loops through each book and matches ths search 
            for book in books {
                
                // Makes sure the searach matches book
                if bookSearch.isEmpty || book.title.lowercased().contains(bookSearch.lowercased())
                    || book.author.lowercased().contains(bookSearch.lowercased())
                    || book.genre.lowercased().contains(bookSearch.lowercased())
                {
                    // Checks if book is currently on a loan
                    let currentLoan =
                        try Loan
                        .filter(Loan.Columns.bookID == book.id && Loan.Columns.dateReturned == nil)
                        .fetchOne(db)
                    // Availability of loan
                    let status: String
                    if currentLoan == nil {
                        status = "Available"
                    } else {
                        status = "On loan"
                    }
                    // Book summary and availability
                    print("\(book.summary()), \(status)")
                    found = true
                }
            }

            // Error message if nothing matches the search
            if found == false {
                print("No books were found")
            }
        }
    } catch {
        print("Database error")
    }
}

/// Adds a new borrrower to the database if all information is correcrt
/// 
/// - Parameter:
///     - name: The name of the borrower
///     - email: The email of the borrower
///     - Phone: The phone number of the borrower
///     - dbQueue: The database connection that's used to insert the borrower
func addBorrower(name: String, email: String, phone: String, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

        // Removes spaces and checks that no feild is blank
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            {
                print("Please fill the prompt correclty")
                return
            }

            // Cretae the borrower record
            let borrower = Borrower(id: nil, name: name, phone: phone, email: email)

            // Insert it into the database
            try borrower.insert(db)
            print("Borrower added")
        }
    } catch {
        print("Database error")
    }
}

/// Displays all the borrowers that are in the database
/// 
/// - Parameter dbQueue: The database connection that's used to read the borrower data
func viewBorrowers(dbQueue: DatabaseQueue) {
    do {
        try dbQueue.read { db in

            // Fetch all the borrower records insdie the data base
            let borrowers = try Borrower.fetchAll(db)

            // Loops through borrower and prints their details
            for borrow in borrowers {
                print(borrow.summary())
            }
        }
    } catch {
        print("Database error")
    }
}

/// Edits an exisiting book in the database
/// 
/// - Parameters:
///     - bookID: The ID of the book that would be edited 
///     - dbQueue: The database connection used to update and read the books
func editBook(bookID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

            // Fetch the bookfrom the database using the book ID
            guard var book = try Book.fetchOne(db, key: bookID) else {
                print("Book not found")
                return
            }

            // Asking what new title they would change it to, or if want to keep it the same
            print("Enter new title of book or click enter to keep current \(book.title)) ")
            if let input = readLine(), input != "" {
                book.title = input
            }

            // Ask for new author or keep it the same
            print("Enter new author of book or click enter to keep current \(book.author)) ")
            if let input = readLine(), input != "" {
                book.author = input
            }

            // Ask for new genre or keep it the same
            print("Enter new genre of book or click enter to keep current \(book.genre)) ")
            if let input = readLine(), input != "" {
                book.genre = input
            }

            // Input the updated books back into the database
            try book.update(db)
            print("Book updated")
        }
    } catch {
        print("Database error")
    }
}

/// Allows user to delet book when there not on loan
/// 
/// - Parameters:
///     - bookID: The id of the book to delet
///     - dbQueue: The database connection that is used to read and remove records
func deletBook(bookID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

            // Checks if book exist in the database
            guard let book = try Book.fetchOne(db, key: bookID) else {
                print("Book not found")
                return
            }

            // Checks if the book is activavly on loan
            let activeLoan =
                try Loan
                .filter(Loan.Columns.bookID == bookID && Loan.Columns.dateReturned == nil)
                .fetchOne(db)

            // Stops books that are on loan from deleting
            guard activeLoan == nil else {
                print("Currently on loan")
                return
            }

            // Delets the book record from the databse
            try book.delete(db)
            print("Book delected")
        }
    } catch {
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

            var isRunning = true
            while isRunning {
                showMenu()
                let choice = readLine()

                switch choice {
                case "1":
                    borrowBook(dbQueue: dbQueue)

                case "2":
                    print("Enter loan ID")
                    if let input = readLine(),
                        let loanID = Int(input)
                    {
                        returnBook(loanID: loanID, dbQueue: dbQueue)
                    } else {
                        print("Invalid loan ID")
                    }

                case "3":
                    print("Enter book title, author or genre:")
                    let search = readLine() ?? ""
                    searchBook(bookSearch: search, dbQueue: dbQueue)
                case "4":
                    try dbQueue.read { db in
                        let books = try Book.fetchAll(db)
                        for book in books {
                            print(book.summary())
                        }
                    }
                case "5":
                    print("Enter name:")
                    let name = readLine() ?? ""

                    print("Enter email:")
                    let email = readLine() ?? ""

                    print("Enter phone:")
                    let phone = readLine() ?? ""

                    addBorrower(name: name, email: email, phone: phone, dbQueue: dbQueue)

                case "6":
                    viewBorrowers(dbQueue: dbQueue)

                case "7":
                    print("Enter book ID to edit:")
                    if let input = readLine(), let bookID = Int(input) {
                        editBook(bookID: bookID, dbQueue: dbQueue)
                    } else {
                        print("Invalid book ID")
                    }

                case "8":
                    print("Enter the book ID you woulw want to delete:")
                    if let input = readLine(), let bookID = Int(input) {
                        deletBook(bookID: bookID, dbQueue: dbQueue)
                    } else {

                    }

                case "9":
                    isRunning = false
                    print("Goodbye, thank you!")
                default:
                    print("Invalid option")
                }
            }
        } catch {
            print("Database error: \(error)")
        }
    }
}


/*
func bookOptions(dbQueue: DatabaseQueue) {
    let books = [
        ("Harry potter", "Fantasy", "J.K. Rowling"),
        ("The Hunger Games", "Dystopian", "Suzanne Collins"),
        ("Haiyku", "Poetry", "Haruichi Furudate"),
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
*/