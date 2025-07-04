// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation

/// A representation of a customer.
public struct Customer: CustomStringConvertible, Equatable, Sendable {

    /// Unique identifier of the customer.
    public let id: String

    /// Secret of the customer.
    public let secret: String

    /// A string description of the customer.
    public let description: String

    /// Initialize the customer.
    ///
    /// - Parameters :
    ///   - id : Unique identifier of the customer.
    ///   - secret:Secret of the customer.
    public init( _ id: String, _ secret: String) {

        // Copy main members.
        self.id = id
        self.secret = secret

        // Set "description".
        self.description = "Customer(id='\(id)', secret='\(secret)')"
    }

    public static func == (lhs: Customer, rhs: Customer) -> Bool {
        let result: Bool = lhs.id == rhs.id && lhs.secret == rhs.secret
        return result
    }

    public static func != (lhs: Customer, rhs: Customer) -> Bool {
        let result: Bool = lhs.id != rhs.id && lhs.secret != rhs.secret
        return result
    }
}
