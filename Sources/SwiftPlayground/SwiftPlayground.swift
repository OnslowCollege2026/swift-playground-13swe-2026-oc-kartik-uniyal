// The Swift Programming Language
// https://docs.swift.org/swift-book

struct Student {
    let id: Int
    var name: String
    var age: Int
    let nsn: Int
    var email: String
    func summary() -> String {
        return """
                        ID: \(id)
                        Name = \(name)
                        Age = \(age)
                        NSN = \(nsn)
                        Email = \(email)
            """
    }
}

@main
struct SwiftPlayground {
    static func main() {
        let Students = [
            Student(
                id: 22346,
                name: "Kartik Uniyal",
                age: 17,
                nsn: 0_145_086_104,
                email: "kartik.uniyal@student.onslow.school.nz",
            ),
            Student(
                id: 22893,
                name: "Rapha Diwa",
                age: 16,
                nsn: 016_734_055,
                email: "rapha.diwa@student.onslow.school.nz",
            ),
            Student(
                id: 22361,
                name: "Sam Thomas",
                age: 17,
                nsn: 0_144_467_007,
                email: "samuel.thomas@student.onslow.school.nz",
            ),
            Student(
                id: 22791,
                name: "Archie Dom",
                age: 17,
                nsn: 147_095_160,
                email: "archiedom9@gmail.com",
            ),
            Student(
                id: 22410,
                name: "John Quimpo",
                age: 17,
                nsn: 12_345_678,
                email: "samuel.thomas@student.onslow.school.nz",
            ),
        ]

        print("ddyd")

    }
}

SwiftPlayground.main()
