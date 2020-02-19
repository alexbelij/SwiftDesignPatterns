import UIKit
import PlaygroundSupport

// Observer Protocol
// Observers need to conform to this protocol to be notified when subject changes
protocol Observer {
    // lets us compare objects that implement the protocol when managing the observers
    var uid: Int { get }
    
    //
    func notify()
}

// Subject Protocol
protocol Subject {
    // This method allows observers to register to recieve notification from the subject
    mutating func register(_ observer: Observer)
    // This method allows unsubscribing to a registered observer
    mutating func unregister(_ observer: Observer)
}

// In this example the UIButtons are the subjects and UILabels are observers
// we can extend the UILabel to conform to our observer protocol
extension UILabel: Observer {
    // the uid uses the object identifier's has value to uniquely identify the label
    // this only works with class instances and meta types and can't be used with value types like struct and enum
    var uid: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    func notify() {
        self.text = "Subject state changed"
    }
}

// we can extend the UIButton to conform to our subject protocol
extension UIButton: Subject {
    // this helps us keep track of our observers
    // extensions must not contain stored properties, hence the static
    private static var observers = [Observer]()
    
    func register(_ observer: Observer) {
        UIButton.observers.append(observer)
    }
    
    func unregister(_ observer: Observer) {
        // filter array method returns the elements of the observer list that satisfy
        // a predicate (all except the input parameter)
        UIButton.observers = UIButton.observers.filter{ $0.uid != observer.uid }
    }
    
    // used to notify the observers
    func onStateChanged() {
        // for each observer, call the notify method
        UIButton.observers.forEach { (observer) in
            observer.notify()
        }
    }
    
    
}

class MyViewController : UIViewController {
    var labels = [UILabel]()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let notifyButton = UIButton(frame: CGRect(x: 0, y: 50, width: 380, height: 44))
        notifyButton.setTitle("Notify observers", for: .normal)
        notifyButton.setTitleColor(.black, for: .normal)
        notifyButton.backgroundColor = .lightGray
        view.addSubview(notifyButton)
            
        // Set the target and the action for the UIButton
        notifyButton.addTarget(self, action: #selector(onNotifyPressed(sender:)), for: UIControl.Event.touchUpInside)

        let unregisterButton = UIButton(frame: CGRect(x: 0, y: 100, width: 380, height: 44))
        unregisterButton.setTitle("Unregister observer", for: .normal)
        unregisterButton.setTitleColor(.white, for: .normal)
        unregisterButton.backgroundColor = .red
        view.addSubview(unregisterButton)
        
        // Set the target and the action for the UIButton
        unregisterButton.addTarget(self, action: #selector(onUnregisterPressed(sender:)), for: UIControl.Event.touchUpInside)
        
        let labelCount = 10
        
        for i in 0 ..< labelCount {
            let label = UILabel(frame: CGRect(x: 0, y: 200 + (i * 30), width: 380, height: 20))
            label.text = "Label # \(i + 1) listening..."
            label.textColor = .black
            label.textAlignment = .center
            view.addSubview(label)
            notifyButton.register(label)
            labels.append(label)
        }
        
        self.view = view
    }
    
    @objc func onNotifyPressed(sender: UIButton) {
        sender.onStateChanged()
    }
    
    @objc func onUnregisterPressed(sender: UIButton) {
        guard !labels.isEmpty else { return }
        // if it is not empty, remove the first label
        let label = labels.removeFirst()
        label.text = "Unregistered"
        sender.unregister(label)
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
