// Programming Summataive assesment
// Created by Kartik Uniyal
// Created on 22/04/2026

import Foundation
import GRDB

/// A constant that's used when the database ID is invalid or missing
let placeHolderID = -1

// Constants used to controllthe formating the tables width and alignment 
let idLength = 4

let titleLength = 25

let authorLength = 20

let genreLength = 10

let statusLength = 10

let paddingStart = 0

let nameLength = 25

let emailLength = 30

let phoneLength = 15

let loanLength = 30
/// Represents a book in the library database
///
/// Each line represents to a row in the books table
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
        return ("\(id ?? placeHolderID) | \(title) | \(author) | \(genre)")
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

/// Represents a registered library member who can borrow books
///
/// Each borrower corresponds to a row in the borrowers table
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
        return ("\(id ?? placeHolderID): \(name) \(email) \(phone)")
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

/// Represents a loan that links a borrower to a borrowed book
///
/// Each loans tracks when a book is borrowed and returned
struct Loan: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "loansTable"

    // Auto generated primary key
    let id: Int?

    // A foreign key referencing to borrowers.ID
    var borrowerID: Int

    // A foreign ley referencing to book.ID
    var bookID: Int

    // The date of issue for the book (dd/mm/yyyy)
    var dateBorrowed: String

    // Date of when the book was returned with nil meaning its still on loan
    var dateReturned: String?

    /// Retruns formatted loan details
    /// - Returns: A string showing loan, borrower, and book ID, returning status
    func summary() -> String {
        let returned = dateReturned ?? "Not returned"
        return "loan \(id ?? placeHolderID) | "
            + "Book \(bookID) Borrower \(borrowerID) \(returned)"
    }

    // confirms to codeable
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
/// Parameters:
///     - bookID: The ID of the book being borrowed
///     - borrower: The ID of the borrower who requests the book.
///     - dbQueue: The database connection used to read and write data.
func loanBook(bookID: Int, borrowerID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

            // Makes sure the borrower exists before creating
            // A loan to prevent invalid realationships
            guard let borrower = try Borrower.fetchOne(db, key: borrowerID) else {
                print("Borrower not found")
                return
            }

            // Prevents creating loans before books exist
            guard let book = try Book.fetchOne(db, key: bookID) else {
                print("Book not found")
                return
            }

            // Loan being active if dateReturned as nil
            let activeLoan =
                try Loan
                .filter(
                    Loan.Columns.bookID == bookID
                        && Loan.Columns.dateReturned == nil
                )
                .fetchOne(db)

            // If a loan alrady exsist, stops new loan creation
            guard activeLoan == nil else {
                print("Book is already on loan")
                return
            }

            // Links borrower and book,ensures both IDs are valid
            guard let borrowerIDValue = borrower.id,
                let bookIDValue = book.id
            else {
                print("Data error: Missing ID")
                return
            }

            // Creates a new loan record and outs current date as borrow record
            let newLoan = Loan(
                id: nil,
                borrowerID: borrowerIDValue,
                bookID: bookIDValue,
                dateBorrowed: currentDate(),
                dateReturned: nil
            )

            /// Complete the process and insert into database
            try newLoan.insert(db)
            print("Loan successful, loan ID: \(db.lastInsertedRowID)")

        }
        // Catches database errors to prevent code from crashing
    } catch {
        print("Database error")
    }
}

/// Shows the main menu options for the library
func showMenu() {
    // library menu for user to choose from
    print(
        """
        ========================
            Library System
        ========================
        1.Borrow book
        2.Return a book
        3.Search a book
        4.Add book 
        5.Edit book
        6.Delete book
        7.Add borrowers
        8.View borrowers
        9.Delete borrower
        10.Exit

        Enter option:
        """)
}

/// Handles the process of borrowing a book and checking user input
///
/// - Parameter dbQueue: The database connection used to process the loan
func borrowBook(dbQueue: DatabaseQueue) {

    // Ask the user for the book ID they want to borrow
    print("Enter the ID of the book you would like to borrow:")

    // verifies the book ID input is not nil and can be converted to an Int ID
    guard let bookInput = readLine(),
        let bookID = Int(bookInput)
    else {
        print("Invalid book ID")
        return
    }

    // Ask the user for the borrower ID thats linked to the loan
    print("Enter borrower ID: ")

    // Makes sure the borrower ID is valid before c ontinuing
    guard let borrowerInput = readLine(),
        let borrowerID = Int(borrowerInput)
    else {
        print("Invalid borrower ID")
        return
    }

    // Creates a loan record by linking the borrower ID and book in the database
    loanBook(bookID: bookID, borrowerID: borrowerID, dbQueue: dbQueue)
}

///Deletes a borrower from the database if they don't have an active loan
///
/// - Parameters:
///     - borrowerID: The ID of the borrower that will be deleted
///     - dbQueue: The database connection used to read and write data
func deleteBorrower(borrowerID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

            // Checks if the borrower exisits in the database
            guard let borrower = try Borrower.fetchOne(db, key: borrowerID) else {
                print("Borrower not find")
                return
            }

            // Checks if this borrower has any active loans to prevent
            // A borrower with an active loan from being deleted
            let activeLoan = try Loan.filter(
                Loan.Columns.borrowerID == borrowerID && Loan.Columns.dateReturned == nil
            )
            .fetchOne(db)
            // Stops from deleting borrower if they still have an active loan
            guard activeLoan == nil else {
                print("Borrower has active loans at the moment")
                return
            }

            // Deletes borrower from database if they have no loan
            try borrower.delete(db)
            print("Borrower deleted")

        }
    } catch {
        print("Database error")
    }
}

/// Marks a loan as returned by setting the return date to the current date
///
///  - Parameters:
///     - loanID: The ID of the loan that is being returned
///     - dbQueue: The database connection used to read and modify the data
func returnBook(loanID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

            // Checks if the loan exsist in the databse
            guard var loan = try Loan.fetchOne(db, key: loanID) else {
                print("Loan not found")
                return
            }

            // Stops duplicate returns by chekcing if the books
            // Have already been returned
            guard loan.dateReturned == nil else {
                print("Book already returned")
                return
            }

            // Makes todays date as the current data to show books have been returned
            loan.dateReturned = currentDate()

            // Saves the changes back into the database with the new information
            try loan.update(db)
            print("Book successfully returned")
        }
    } catch {
        print("Database error")
    }
}

/// Searchs for books by the title, author, or genre and prints them
///
/// - Parameters:
///     - bookSearch: The input from the user to to search for books
///     - dbQueue: The database connection used to read book data
func searchBook(bookSearch: String, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.read { db in

            // Gets all books from the database
            let books = try Book.fetchAll(db)
            var found = false

            print("---------------------------------------------------------------------")
            print("ID   TITLE                     AUTHOR               GENRE      STATUS")
            print("---------------------------------------------------------------------")

            // loops through each book and matches ths search
            for book in books {

                // Makes sure the input matches the book information and prints all of them
                // if press entered
                if bookSearch.isEmpty
                    || book.title.lowercased().contains(bookSearch.lowercased())
                    || book.author.lowercased().contains(bookSearch.lowercased())
                    || book.genre.lowercased().contains(bookSearch.lowercased())
                {

                    // Checks if book is currently on a loan
                    // If dateReturned is nil then book is on active loan
                    let currentLoan =
                        try Loan
                        .filter(
                            Loan.Columns.bookID == book.id
                                && Loan.Columns.dateReturned == nil
                        )
                        .fetchOne(db)

                    // Availability status of loans
                    let status: String
                    if currentLoan == nil {
                        status = "Available"
                    } else {
                        status = "On loan"
                    }

                    // Formats the values nicely to align the output and make it readable
                    let id = String(book.id ?? placeHolderID).padding(
                        toLength: idLength, withPad: " ", startingAt: paddingStart)
                    let title = book.title.padding(
                        toLength: titleLength, withPad: " ", startingAt: paddingStart)
                    let author = book.author.padding(
                        toLength: authorLength, withPad: " ", startingAt: paddingStart)
                    let genre = book.genre.padding(
                        toLength: genreLength, withPad: " ", startingAt: paddingStart)
                    let stat = status.padding(
                        toLength: statusLength, withPad: " ", startingAt: paddingStart)

                    // Prints the book records with it's availability status
                    print("\(id) \(title) \(author) \(genre) \(stat)")
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
///     - dbQueue: The database connection that's used to insert the borrower data
func addBorrower(name: String, email: String, phone: String, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

            // Removes all white and empty spaces, to ensure to blank borrowers are created
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            {
                print("Please fill in the details correctly")
                return
            }

            // Checks if the email contains these requirements to prevent invalid input
            if !email.contains("@") || !email.contains(".") {
                print("Please input a valid email")
                return
            }

            // Cretaes a new borrower record using data input
            // ID is set to nil so database auto generates it
            let borrower = Borrower(id: nil, name: name, phone: phone, email: email)

            // Insert the borrower into the database
            try borrower.insert(db)
            print("Borrower added")
        }
    } catch {
        print("Database error")
    }
}

/// Adds a new book into the database
///
/// - Parameters:
///     - title: The title of the book
///     - genre: The genre of the book
///     - author: The author of the book
///     - dbQueue: The database connection used to insert the data
func addBook(title: String, genre: String, author: String, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

            // Ensures all feilds have valid input and not whitespaces or are empty
            if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || genre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            {
                print("Please fill in the information")
                return
            }

            // Creates a new book from the user input
            // ID is set to nil so database auto genererats it
            let book = Book(
                id: nil,
                title: title,
                genre: genre,
                author: author
            )

            // Inserts the new book into the database
            try book.insert(db)
            print("Book succsefully")
        }
    } catch {
        print("Database error")
    }
}

/// Displays all the borrowers that are in the database with their active loans
///
/// - Parameter dbQueue: The database connection that's used to read borrower and loan data
func viewBorrowers(dbQueue: DatabaseQueue) {
    do {
        try dbQueue.read { db in

            // Fetches all the borrower records inside the data base to display
            let borrowers = try Borrower.fetchAll(db)

            print(
                "--------------------------------------------------------------------------------")
            print("ID   NAME                      EMAIL                         PHONE")
            print(
                "--------------------------------------------------------------------------------")

            // Prints all the borrower data in a formatted way for easier reading
            for borrow in borrowers {

                let id = String(borrow.id ?? placeHolderID).padding(
                    toLength: idLength, withPad: " ", startingAt: paddingStart)
                let name = borrow.name.padding(
                    toLength: nameLength, withPad: " ", startingAt: paddingStart)
                let email = borrow.email.padding(
                    toLength: emailLength, withPad: " ", startingAt: paddingStart)
                let phone = borrow.phone.padding(
                    toLength: phoneLength, withPad: " ", startingAt: paddingStart)

                print("\(id) \(name) \(email) \(phone)")
            }
            print("---------------------------------------------------------------------")
            print("ACTIVE LOANS")
            print("---------------------------------------------------------------------")

            var hasLoans = false

            // Checks each borrower for active loans
            for borrow in borrowers {
                let activeLoans = try Loan.filter(
                    Loan.Columns.borrowerID == borrow.id
                        && Loan.Columns.dateReturned == nil
                ).fetchAll(db)

                // Loops through each active loan and shows the book and borrower detials
                for loan in activeLoans {
                    let book = try Book.fetchOne(db, key: loan.bookID)

                    print(
                        "Loan \(loan.id ?? placeHolderID): \(book?.title ?? "Unknown") (Borrower: \(borrow.name))"
                    )
                    hasLoans = true
                }
            }

            // Prints a message if no borrowers have loans
            if hasLoans == false {
                print("No current active loans")
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
            print(
                "Enter new title of book or click enter to keep current "
                    + "\(book.title)) ")
            if let input = readLine(), input != "" {
                book.title = input
            }

            // Ask for new author or keep it the same
            print(
                "Enter new author of book or click enter to keep current "
                    + "\(book.author)) ")
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

/// Allows user to delete book when there not on loan
///
/// - Parameters:
///     - bookID: The id of the book to delete
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
                .filter(
                    Loan.Columns.bookID == bookID
                        && Loan.Columns.dateReturned == nil
                )
                .fetchAll(db)
                .first

            // Stops books that are on loan from deleting
            guard activeLoan == nil else {
                print("Currently on loan")
                return
            }

            // deletes the book record from the databse
            try book.delete(db)
            print("Book delete")
        }
    } catch {
        print("Database error")
    }
}

/// Clears the terminal screen and waits for user before continuing
func clearScreen() {
    print("Press enter to continue", terminator: "")
    _ = readLine()
    print("\u{001B}[2J", terminator: "")

}

@main
struct SwiftPlayground {
    static func main() {
        /// Sets up the database file
        let dbPath = "Sources/SwiftPlayground/bookLibaryDatabase.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbPath)

            /// Displays the total number of books
            try dbQueue.read { db in
                let count = try Book.fetchCount(db)
                print("Book count: \(count)")
            }

            /// Main program that runs the system untill the user exits
            var isRunning = true
            while isRunning {

                /// Clears the menu and displays the menu
                clearScreen()
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
                    print("Enter book title, author or genre (Press enter to see all books):")
                    let search = readLine() ?? ""
                    searchBook(bookSearch: search, dbQueue: dbQueue)

                case "4":
                    print("Enter title:")
                    let title = readLine() ?? ""

                    let checkLetters = title.rangeOfCharacter(from: .letters) != nil
                    if !checkLetters {
                        print("Invaild title, please input atleast on letter")
                    } else {
                        print("Enter genre")
                        let genre = readLine() ?? ""

                        print("Enter author")
                        let author = readLine() ?? ""

                        addBook(title: title, genre: genre, author: author, dbQueue: dbQueue)
                    }

                case "5":
                    print("Enter book ID to edit:")
                    if let input = readLine(), let bookID = Int(input) {
                        editBook(bookID: bookID, dbQueue: dbQueue)
                    } else {
                        print("Invalid book ID")
                    }

                case "6":
                    print("Enter the book ID you would want to delete:")
                    if let input = readLine(), let bookID = Int(input) {
                        deletBook(bookID: bookID, dbQueue: dbQueue)
                    } else {
                        print("Invalid Book ID, please enter a valid number")
                    }

                case "7":
                    print("Enter name:")
                    let name = readLine() ?? ""

                    print("Enter email:")
                    let email = readLine() ?? ""

                    print("Enter phone:")
                    let phone = readLine() ?? ""

                    addBorrower(name: name, email: email, phone: phone, dbQueue: dbQueue)

                case "8":
                    viewBorrowers(dbQueue: dbQueue)

                case "9":
                    print("Enter the borrower ID to delete")

                    if let input = readLine(),
                        let borrowerID = Int(input)
                    {
                        deleteBorrower(borrowerID: borrowerID, dbQueue: dbQueue)
                    } else {
                        print("Invalid borrower ID entered")
                    }

                case "10":
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
