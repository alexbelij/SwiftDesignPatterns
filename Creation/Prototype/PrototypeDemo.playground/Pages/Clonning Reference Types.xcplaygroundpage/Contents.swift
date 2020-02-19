// The prototype pattern
// Step 1. Make the class conform to NSCopying
// Step 2. define the copy(withZone) method
// Step 3. create a clone method to give a shorter syntax
// Step 4. When making duplicate use the clone() method
import Foundation

class NameClass : NSCopying {
    var firstName: String
    var lastName: String

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    // This method simply returns a copy of properties to the new one
    func copy(with zone: NSZone? = nil) -> Any {
        return NameClass(firstName: self.firstName, lastName: self.lastName)
    }
    
    // Gives a shorter syntax for copying the properties
    func clone() -> NameClass {
        return self.copy() as! NameClass
    }
}

// makes you provide a human friendly description for the class
//extension NameClass: CustomStringConvertible {
//    public var description: String {
//        return "NameClass(firstName: \(firstName), lastName:\(lastName))"
//    }
//}

var steve = NameClass(firstName: "Steve", lastName: "Johnson")
var john = steve.clone()

print("\(steve.firstName) \(steve.lastName), \(john.firstName) \(john.lastName)")

john.firstName = "John"
john.lastName = "Wallace"

print("\(steve.firstName) \(steve.lastName), \(john.firstName) \(john.lastName)")
