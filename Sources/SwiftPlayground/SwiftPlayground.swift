// The Swift Programming Language
// https://docs.swift.org/swift-book


@main
struct SwiftPlayground {
    static func main() {
        //Two car options
        let carOne = car(brand:"Porche", model:"718 Boxster GTS 4.0", year: 2018)
        let carTwo = car(brand:"Toyota", model:"Corolla Cross GX Hybrid", year: 2022)
// Printing both cars
print("Car one is a beautiful \(carOne.brand) \(carOne.model) and made in \(carOne.year)")
print("Car two is a beautiful \(carTwo.brand) \(carTwo.model) and made in \(carTwo.year)")

//Bank accounts
let accountOne = BankAccount(owner: "Kartik", balance: 1000000)
let accountTwo = BankAccount(owner: "John", balance: 54.653)

// Printing the accounts
print(accountOne.description())
print(accountTwo.description())
}

}


//Car struct that has brand, model, and year
struct car {
    let brand: String
    let model: String
    let year: Int
}

struct BankAccount{
    var owner: String
    var balance: Double

    func description() -> String {
    return "Owners accoutns are \(self.owner) and the balance is \(self.balance) "
}
}

//rectangle struct that has width and hight
struct rectangle{ 
    var width: Double
    var hight: Double
}

let rectangleOne = rectangle(width: 15.67, hight: 172)
let rectangleTwo = rectangle(width: 30, hight: 55)