// The adapter pattern
// Step 1. Create a protocol and specify properties and methods that all adapters should have
// Step 2. Create different classes for different adaptors
// Step 3. The adapters should conform to the protocol
// Step 4. Call the methods that were declared in the protocol

// The protocol declares a method and a read only property for the toal
protocol PaymentGateway {
    func receivePayment(amount: Double)
    var totalPayments: Double {get}
}

// Paypal conforms to the payment gateway protocol and has to impletement the method and prooperty
class PayPal: PaymentGateway {
    private var total = 0.0
    
    func receivePayment(amount: Double) {
        total += amount
    }
    
    var totalPayments: Double {
        print("Total payments received via PayPal: \(total)")
        return total
    }
}

// Stripe conforms to the payment gateway protocol and has to impletement the method and prooperty
class Stripe: PaymentGateway {
    private var total = 0.0
    
    func receivePayment(amount: Double) {
        total += amount
    }
    
    var totalPayments: Double {
        print("Total payments received via Stripe: \(total)")
        return total
    }
}

// Create an instance and call the recieve payment
let paypal = PayPal()
paypal.receivePayment(amount: 100)
paypal.receivePayment(amount: 200)
paypal.receivePayment(amount: 499)

let stripe = Stripe()
stripe.receivePayment(amount: 5.99)
stripe.receivePayment(amount: 25)
stripe.receivePayment(amount: 9.99)

// because the paypal and stripe objects conform to the same protocol we can
// create an array of those elements
var paymentGateways: [PaymentGateway] = [paypal, stripe]


// third-party class, that doesn't conform to PaymentGateway
class AmazonPayments {
    var payments = 0.0
    
    func paid(value: Double, currency: String) {
        payments += value
        print("Paid \(currency)\(value) via Amazon Payments")
    }
    
    func fulfilledTransactions() -> Double {
        return payments
    }
}

/*
// We can create an adaptor to allow
class AmazonPaymentsAdapter: PaymentGateway {
    func receivePayment(amount: Double) {
        amazonPayments.paid(value: amount, currency: "USD")
    }
    var totalPayments: Double {
        let total = amazonPayments.payments
        print("Total payments received")
        return total
    }
}

let amazonPaymentsAdapter = AmazonPaymentsAdapter()
amazonPaymentsAdapter.receivePayment(amount: 120)
amazonPaymentsAdapter.receivePayment(amount: 74.99)

paymentGateways.append(amazonPaymentsAdapter)
 */

// or we can create an extension of the existing library to conform to our needs
extension AmazonPayments: PaymentGateway {
    func receivePayment(amount: Double) {
        amazonPayments.paid(value: amount, currency: "USD")
    }
    var totalPayments: Double {
        let total = amazonPayments.payments
        print("Total payments received")
        return total
    }
}

let amazonPayments = AmazonPayments()
amazonPayments.receivePayment(amount: 120)
amazonPayments.receivePayment(amount: 74.99)

paymentGateways.append(amazonPayments)

// To calculate the total of all the payments, we loop through all the received payments
// works through polymorphism
var total = 0.0
for gateway in paymentGateways {
    total += gateway.totalPayments
}

print(total)
