// The factory method
// Step 1. Define the base class or protocol. Here the protocol Serializable
// Step 2. Define the classes that inherit or conform to the base class and implement the methods.
// Step 3. Create an enumerator of the different types of classes
// Step 4. Create a Factory Method class and define a static method that returns a class type
// Step 5. Create an instance of one of the classes by giving the enumeration type

// Defines a protocol serializable with a serialize method
protocol Serializable {
    func serialize()
}

class JSONSerializer: Serializable {
    func serialize() {
        print("JSONSerializer \(#function)")
    }
}

class PropertyListSerializer: Serializable {
    func serialize() {
        print("PropertyListSerializer \(#function)")
    }
}
class XMLSerializer: Serializable {
    func serialize() {
        print("XMLSerializer \(#function)")
    }
}

enum Serializers {
    case json
    case plist
    case xml
}

struct SerializerFactory {
    // The factory method encapsulates the creation of an object
    static func makeSerializer(_ type: Serializers) -> Serializable? {
        let result: Serializable?
        switch type {
        case .json:
            result = JSONSerializer()
        case .plist:
            result = PropertyListSerializer()
        case .xml:
            result = XMLSerializer()
        }
        return result
    }
}

let jsonSerializer = SerializerFactory.makeSerializer(.json)
jsonSerializer?.serialize()

let xmlSerializer = SerializerFactory.makeSerializer(.xml)
xmlSerializer?.serialize()

let plistSerializer = SerializerFactory.makeSerializer(.plist)
plistSerializer?.serialize()

