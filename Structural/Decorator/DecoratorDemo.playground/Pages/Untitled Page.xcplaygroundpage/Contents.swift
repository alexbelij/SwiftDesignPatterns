import Foundation

// To decorate the user defaults to set date and get date
// this lets us replace the objected with the decorator
class UserDefaultsDecorator: UserDefaults {
    private var userDefaults = UserDefaults.standard
    
    convenience init(userDefaults: UserDefaults) {
        self.init()
        self.userDefaults = userDefaults
    }

    // set delegtates the saving the value to the user defaults wrapped class
    func set(date: Date?, forKey key: String) {
        userDefaults.set(date, forKey: key)
    }
    
    // similar to getting the date
    func date(forKey key: String) -> Date? {
        return userDefaults.value(forKey: key) as? Date
    }
}

// instatiates a UserDefaults class
let userDefaults = UserDefaultsDecorator()

userDefaults.set(42, forKey: "the answer")
print(userDefaults.string(forKey: "the answer") ?? "?")

userDefaults.set(date: Date(), forKey: "now")
