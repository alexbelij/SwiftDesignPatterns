// Flyweight pattern
// Step 1. Identify the intrinsic state (replicated data) and extrinsic states (unique data)
// Step 2. Create a class with all the intrinsic state
// Step 3. Initialize that class
// Step 4. Replace the properties and initializers of the intrinsic states with that new class
// Step 5. Create an instance of the shared state
//
import UIKit

class SharedSpaceShipData {
    // intrinsic states
    private let mesh: [Float]
    private let texture: UIImage?
    
    init(mesh: [Float], imageNamed name: String) {
        self.mesh = mesh
        self.texture = UIImage(named: name)
    }
}

class SpaceShip {
    // intrinsic states
    private var intrinsicState: SharedSpaceShipData
    
    // extrinsic states
    private var position: (Float, Float, Float)

    // initialize the intrinsic and extrinsic states
    init(sharedData: SharedSpaceShipData, position: (Float, Float, Float) = (0, 0, 0)) {
        self.intrinsicState = sharedData
        self.position = position
    }
}


let fleetSize = 1000
var ships = [SpaceShip]()
var vertices = [Float](repeating: 0, count: 1000) // just a dummy array of floats

let sharedState = SharedSpaceShipData(mesh: vertices, imageNamed: "SpaceShip")

// instead of laoding the images 1000 times, it is loaded once and applied to the fleet
for _ in 0..<fleetSize {
    let ship = SpaceShip(sharedData: sharedState,
                         position: (Float.random(in: 1...100),
                                    Float.random(in: 1...100),
                                    Float.random(in: 1...100)))
    ships.append(ship)
}

