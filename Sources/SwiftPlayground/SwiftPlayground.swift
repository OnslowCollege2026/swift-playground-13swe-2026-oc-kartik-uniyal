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
    return "Owners accoutns are \(accountOne) and "
}
}



let accountOne = BankAccount(owner: "Kartik", balance: 1000000)
let accountTwo = BankAccount(owner: "John", balance: 54.653)