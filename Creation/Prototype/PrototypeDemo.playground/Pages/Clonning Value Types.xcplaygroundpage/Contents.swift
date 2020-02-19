
struct NameStruct {
    var firstName: String
    var lastName: String
}

// creates an instance of NameStruct
var joe = NameStruct(firstName: "Joe", lastName: "Satriani")
// because NameStruct is a value type, patrick will be different than joe
var patrick = joe

print("\(joe), \(patrick)")

patrick.firstName = "Patrick"
patrick.lastName = "McKenna"

print("\(joe), \(patrick)")
