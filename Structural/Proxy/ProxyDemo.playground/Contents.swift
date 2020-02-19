import Foundation

//
class RandomIntWithID {
    // closure prints a value and returns a random integer as a value
    var value: Int = {
        print("value initialized")
        return Int.random(in: Int.min...Int.max)
    }()
    
    // will be initialized when it is accessed
    lazy var uid: String = {
        print("uid initialized")
        return UUID().uuidString
    }()
}

let n = RandomIntWithID()
//print(n.uid)
