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

print("-------------------")

//Bank accounts
let accountOne = BankAccount(owner: "Kartik", balance: 1000000)
let accountTwo = BankAccount(owner: "John", balance: 54.653)

// Printing the accounts
print(accountOne.description())
print(accountTwo.description())

print("-------------------")

//Creating rectangles
let rectangleOne = rectangle(width: 15.67, hight: 172)
let rectangleTwo = rectangle(width: 30, hight: 55)

//Printing the rectangles
print("Rectangle one's area is \(rectangleOne.area())")
print("Rectangle two's area is \(rectangleTwo.area())")

//Checking which rectangle is bigger in area
if rectangleOne.area() > rectangleTwo.area() {
    print("Rectangle one is bigger")
}else {
    print("Rectanlge two is bigger")
}

print("-------------------")
//Creating the quest
let easyQuest = Quest(title: "Collect 10 wood", difficulty: "easy", reward: 10, rank: 1)
let mediumQuest = Quest(title: "Kill 10 eneimes", difficulty: "Medium", reward: 20, rank: 2)
let hardQuest = Quest(title: "Kill the final boss", difficulty: "Hard", reward: 30, rank: 3)

// Printing the quest information
print(easyQuest.printBadge())
print(mediumQuest.printBadge())
print(hardQuest.printBadge())

// Checking which quest is the hardest
if easyQuest.rank > mediumQuest.rank && easyQuest.rank > hardQuest.rank {
    print("Easy quest is the highest")
} else if mediumQuest.rank > easyQuest.rank && mediumQuest.rank > hardQuest.rank {
    print("Medium quest is the hardest")
} else {
    print("Hard quest is the hardest")
}

}
}

//Car struct that has brand, model, and year
struct car {
    let brand: String
    let model: String
    let year: Int
}

//Bank account struct that has owner and balance
struct BankAccount{
    var owner: String
    var balance: Double

//func to show the bank account information
    func description() -> String {
    return "Owners accoutns are \(self.owner) and the balance is \(self.balance) "

    
}
}

//rectangle struct that has width and hight
struct rectangle{ 
    var width: Double
    var hight: Double

//func that returns the area
    func area() -> Double {
       return (width * hight)
    }
}

// Quest struct that has title, difficulty, reward, and rank 
struct Quest {
    var title: String
    var difficulty : String
    var reward: Int
    var rank: Int
    // func that shows the quest information 
    func printBadge() -> String{
        return ("\(title) - \(difficulty) - \(reward)")

    }
}