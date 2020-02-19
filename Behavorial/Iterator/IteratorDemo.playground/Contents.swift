// Iterator design pattern
// Can use sequence or iterator protocol

// Custom queue implementation

private final class Node<T> {
    var key: T?
    var next: Node?
    
    init(_ value: T? = nil) {
        key = value
    }
}

final class Queue<T> {
    fileprivate var head: Node<T>?
    private var tail: Node<T>?
    
    func enqueue(_ value: T) {
        let newNode = Node<T>(value)
        // First element's value has not been set?
        guard head != nil else {
            head = newNode
            tail = head
            return
        }

        // append new element
        tail?.next = newNode
        tail = newNode
    }
    
    func dequeue() -> T? {
        guard let headItem = head?.key else {
            return nil
        }
        
        if let nextNode = head?.next {
            head = nextNode
        } else {
            head = nil
            tail = nil
        }
        return headItem
    }
    
    func isEmpty() -> Bool {
        return head == nil
    }
    
    func peek() -> T? {
        return head?.key
    }
}

struct QueueIterator<T>: IteratorProtocol {
    private let queue: Queue<T>
    private var currentNode: Node<T>?
    
    // initialize the queue iterator with the queue
    init(_ queue: Queue<T>) {
        self.queue = queue
        
        // set the current node to the head of the queue
        currentNode = queue.head
    }
    
    mutating func next() -> T? {
        // if node is nil then we have reached the end of the queue
        guard let node = currentNode else {
            return nil
        }
        
        // set the key p
        let nextKey = currentNode?.key
        
        // set the current node to the next one
        currentNode = node.next
        
        // return the key
        return nextKey
    }
}

// Sequence
extension Queue: Sequence {
    func makeIterator() -> QueueIterator<T> {
        return QueueIterator(self)
    }
}

var queue = Queue<Int>()
queue.enqueue(1)
queue.enqueue(2)

// lets up
for item in queue {
    print(item)
}

// optionally we can use a while loop
var queueIterator = queue.makeIterator()
while let item = queueIterator.next() {
    print(item)
}
