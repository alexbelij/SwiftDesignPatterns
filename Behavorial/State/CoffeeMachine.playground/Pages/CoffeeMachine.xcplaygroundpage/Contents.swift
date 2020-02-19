import Foundation

// file private hides the states from being available outside the file
fileprivate protocol CoffeeMachineState {
    // The protocol should have the same methods as the coffe Machine
    func isReadyToBrew() -> Bool
    func brew()
}

// The concrete states then conform to this protocol
// However each state should only implement the interface that is relevant to that particular type
// The default state just prints a log statement
extension CoffeeMachineState {
    func isReadyToBrew() -> Bool {
        print("\(#function) is not implemented for \(self) state")
        return false
    }
    func brew() {
        print("\(#function) is not implemented for \(self) state")
    }
}

// we can have a stand by state
fileprivate struct StandbyState: CoffeeMachineState {
    // is an empty state and doesn't provide any functionality
}

// this is the state where a Water Tank is Filled
fileprivate struct FillWaterTankState: CoffeeMachineState {
    // this property allows to access the Coffee Machine to query its internal state
    var context: CoffeeMachine
    
    func isReadyToBrew() -> Bool {
        guard context.isWaterTankFilled else {
            print("Fill water tank!")
            context.state = StandbyState()
            return false
        }
        context.state = EmptyCapsuleBinState(context: context)
        return context.state.isReadyToBrew()
    }
}

// this is the state where the capsule is empty
fileprivate struct EmptyCapsuleBinState: CoffeeMachineState {
    // this property allows to access the Coffee Machine to query its internal state
    var context: CoffeeMachine
    
    func isReadyToBrew() -> Bool {
        // Check weather the capsule bin is now empty, if it is display a warning
        guard context.isCapsuleBinEmpty else {
            print("Capsule Bin is full!")
            context.state = StandbyState()
            return false
        }
        
        // if it is not empty
        context.state = InsertCapsuleState(context: context)
        return context.state.isReadyToBrew()
    }
}

// this is the state where a capsule has been inserted
fileprivate struct InsertCapsuleState: CoffeeMachineState {
    // this property allows to access the Coffee Machine to query its internal state
    var context: CoffeeMachine
    
    func isReadyToBrew() -> Bool {
        // Check weather a capule has been inserted, if it is not display a warning
        guard context.isCapsuleInserted else {
            print("Coffee capsule has not been inserted!")
            context.state = StandbyState()
            return false
        }
        
        // if it is inserted, we have checked all issues
        return true
    }
}

// this is the state where coffee is brewed
fileprivate struct BrewCoffeeState: CoffeeMachineState {
    // this property allows to access the Coffee Machine to query its internal state
    var context: CoffeeMachine
    
    func brew() {
        context.state = FillWaterTankState(context: context)
        // this call will trigger the varius states and transitions
        guard context.state.isReadyToBrew() else {
            print("Something is wrong!")
            context.state = StandbyState()
            return
        }
        
        // if all the preconditions are met, the machine brews our coffee
        print("Coffee Brewed")
        context.state = StandbyState()
    }
}

class CoffeeMachine {
    // makes it accessable in the file
    fileprivate var isWaterTankFilled: Bool
    fileprivate var isCapsuleBinEmpty: Bool
    fileprivate var isCapsuleInserted: Bool
    
    // The coffee machine class needs to know it's current state as it will delegate all client requests to the actual state
    fileprivate var state: CoffeeMachineState = StandbyState()

    required init(waterFilled: Bool, binEmpty: Bool, capsuleInserted: Bool) {
        isWaterTankFilled = waterFilled
        isCapsuleBinEmpty = binEmpty
        isCapsuleInserted = capsuleInserted
    }
    
    /*
    private func isReadyToBrew() -> Bool {
        var result = false
        
        if isWaterTankFilled {
            if isCapsuleBinEmpty {
                if isCapsuleInserted {
                    result = true
                    print("Coffee brewed")
                }
                else {
                    print("Insert capsule!")
                }
            }
            else {
                print("Capsule bin full!")
            }
        } else {
            print("Fill water tank!")
        }
        
        return result
    }*/
    
    func brew() {
        state = BrewCoffeeState(context: self)
        state.brew()
    }
    /*
    func brew() {
        // returns true only if a capsule has been inserted and the water tank is full
        guard isReadyToBrew() else {
            print("Can't make coffee")
            return
        }
        print("Coffee ready!")
    }*/
}

let coffeeMachine = CoffeeMachine(waterFilled: false, binEmpty: true, capsuleInserted: true)
// when pressed the machine does a self check and then brews
coffeeMachine.brew()
