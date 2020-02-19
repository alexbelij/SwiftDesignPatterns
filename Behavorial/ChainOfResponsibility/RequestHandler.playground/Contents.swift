import Foundation

// declares an initializer that takes a Requequst handler
// this will be used in the linked list to point to the next request handler
protocol RequestHandling {
    init(next: RequestHandling?)
    
    // preocesses a specific request
    // if it doesn't handle it, it forwards the requrest to the next handler
    func handle(request: Any)
}

// final so that there can't be any child classes
final class Handler<T>: RequestHandling, CustomStringConvertible {
    // this is required as it conforms to the RequestHandling protocol
    private var nextHandler: RequestHandling?
    
    // the initializer just sets the next handler property
    init(next: RequestHandling?) {
        self.nextHandler = next
    }
    
    // if it doesn't handle it, it forwards the requrest to the next handler
    func handle(request: Any) {
        // checks if it can be handled by the generic T
        if request is T {
            print("Request processed by \(self)")
        } else {
            // check whether the next handler exist
            guard let handler = nextHandler else {
                print("Reached the end of the responder chain")
                return
            }
            // if it exists call the handle method of the next handler
            handler.handle(request: request)
            print("\(self) can't handle \(T.self) requests - forwarding to \(handler)")
        }
    }
    
    public var description: String {
        return "\(T.self) Handler"
    }
}

// creates a list of handlers
let dataHandler = Handler<Data>(next: nil)
let stringHandler = Handler<String>(next: dataHandler)
let dateHandler = Handler<Date>(next: stringHandler)

let data = Data(repeating: 0, count: 10)
dateHandler.handle(request: data)

// because there are no responders for int, we reach the end of a responder chain
dateHandler.handle(request: 42)
