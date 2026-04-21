// Formative Assessment
// Made by Kartik
// Made on the 16-06-2025

import Foundation
// making a range for the user to choese from 
// Got this idea from Doc's code
let validOptionRange = 1...4

// Making a array for the learning leaders 
let learningAreaLeader: [String] = ["Bernadette", "Brian", "Janice", "Michelle", "Karl", "Katie", "Sammy", "Tonia"]

//Making a Array for the Title, who it belongs to and the length of the video
var videoList: [[String]] = [
["'P' is for Psycho", "The President's Neck is Missing", "Give My Remains to Broadway", "Kōkā"],
["Belongs to Tonia", "Belongs to Janice", "Belongs to Brian", "Belongs to Karl"],
["9 minutes", "23 minutes", "1 minute", "7 minutes"]
]
// Welcoming the user to the code
print("Welcome to onsflix")

//Making a function to show the user the different options they can chooese
func showOption() {
    print(
        """
    Chose an option:
    1. Add new video
    2. Remove video
    3. List all videos
    4. Quit
    """)
}

/// Gets input from the user
/// 
/// Parameter:
///  - prompt: The quetions for the user
/// 
/// - returns: Returns the user Integer entered by the user or nil if they don't type anything
func input(forInt prompt: String) -> Int? {
    print(prompt, terminator: "")
    if let userChoice = readLine() {
        return Int(userChoice)
    } else {
        return nil
    }
        
}

/// askes user to enter a choice
/// 
/// returns user choice or prints a error message and returns nil
func userChoice () -> Int? {
    let userChoice = input(forInt: "Please enter a choice: ")
    // unwrapps the userChoice
    if let number = userChoice,
    // Checks if the number is within the validOptionRange
    validOptionRange.contains(number) {
        return number
    } else {
        print("Invalid input please choese an option between 1 - 4")
        return nil
    }

    
}

/// Gets string input from the user and returns it 
func input(forString prompt: String) -> String? {
    print(prompt, terminator: "")
    return readLine()
}

/// Gets string from user to add title, LA leader, and length of video
@MainActor
func addNewVideo (){
    guard let videoTitle = input(forString: "Please enter the title of Video: "),
    let videoOwner = input(forString: "Please enter the LA leader: "),
    let videoLength = input(forString: "Please enter the length of the video")
    else{
        return
    }

    videoList[0].append(videoTitle)
    videoList[1].append("Belongs to \(videoOwner)")
    videoList[2].append(videoLength)
}

/// Gets input from user and removes video based of use input
@MainActor
func removeVideo() {
    // 
    for i in 0..<videoList[0].count{
        //displays all the list of videos with numbers
        print ("\(i + 1). \(videoList[0][i]) - \(videoList[1][i]), \(videoList[2][i])")
    }
if let input = input(forInt: "Enter the video number you want to remove: "),
    // checks if the nunber they input is between 1 and how many videos there are
    (1...videoList[0].count).contains(input){
        // takes input and removes 1 because it starts from 0
        let index = input - 1
        // remvoes the data from all the list by using index
        videoList[0].remove(at: index)
        videoList[1].remove(at: index)
        videoList[2].remove(at: index)

        print("Your video has been removed")
        } else {
            print("Invalid input")
        }


}
///list all videos, titls, and lengths
@MainActor
func listAllVideos () {
    print("---Video list---")
    for i in 0..<videoList[0].count{
    print ("\(i + 1). \(videoList[0][i]) - \(videoList[1][i]), \(videoList[2][i])")
}
}
var run = true

//While loop that will keep on going untill user inputs 4
while run{
    showOption()
    if let userInput = userChoice(){
        switch userInput{
            case 1: addNewVideo()
            case 2: removeVideo()
            case 3: listAllVideos()
            case 4: print("Thanks for using Onsflix")
                run = false
            // print this for anything else
            default: print("Invalid")
        }
    }
}
