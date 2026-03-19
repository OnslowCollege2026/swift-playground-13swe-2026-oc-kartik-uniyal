// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB

/// A reservation at the cafe
struct Purchaser: Codable, FetchableRecord, PersistableRecord {
    /// The purchaser ID
    let id: Int

    /// The name of the customer
    var name: String

    /// The number of people at the party/table (minimum 1)
    var count: Int

    /// The name of the reserved table
    var reservedTable: String

    enum CodingKeys: String, CodingKey {
        case id = "purchaser ID"
        case name = "name"
        case count = "count"
        case reservedTable = "reservedTable"
    }
}

struct Order: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// The order ID
    let id: Int

    /// The purchaser ID from the purchaser struct
    var purchaserID: Int

    /// The amount of something
    var amount: Int

    enum CodingKeys: String, CodingKey {
        case id = "order ID"
        case purchaserID = "purchaser ID"
        case amount = "amount"
    }
}

struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// The item id
    let id: Int

    /// Item name
    let name: String

    /// Iem price
    let price: Double

    enum CodingKeys: String, CodingKey {
        case id = "item ID"
        case name = "name"
        case price = "price"

    }
}

struct OrderLine: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// OrderID
    let id: Int

    /// Item ID
    let ItemID: Int

    /// Amount of stuff
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case id = "orderID"
        case ItemID = "ItemID"
        case quantity = "quantity"
    }
}

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "Sources/SwiftPlayground/cafe.db"
        do {
            guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
                fatalError("Could not open")
            }
            // Prints when data base connects
            print("Database connection successful")

            // Dump the Schema to make sure we are connected to the database file
            try dbQueue.read { database in
                try database.dumpSchema()

                // Making the purchaser ID 1
                let purchaserID: Int = 1

                // Looking through the databasew to find the purchaserID
                if let purchaser = try Purchaser.fetchOne(database, key: purchaserID){
                    print("Found purchaser \(purchaser.name)")
                } else {
                    print("No purchaser with Id \(purchaserID) found")
                }

                // Making a fake ID
                let fakeID: Int = 100

                // Trying to find the fake ID that dosen't exist in my database
                if let fakepurchaser = try Purchaser.fetchOne(database, key: fakeID){
                    print("Found purchaser \(fakepurchaser.name)")
                } else {
                    print("No purchaser with Id \(fakeID) found")
                }
            }

        if let item = try Item.fetchOne(db, id:1) {
            print(item)
        }
        } catch {
            print(error)
        }
    }
    // Find a customer at the window seat
    //let windowSitter = Purchaser.filter(key: [
    //    "reservedTable" : "Window Seat"
    //   //])
    //print(windowSitter)
    //} catch{
    //    print(error)
    //}
}
