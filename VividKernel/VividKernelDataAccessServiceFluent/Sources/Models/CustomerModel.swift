// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Fluent
import VividKernelService

/// Extension of ``Customer`` to be able to use it with Vapor without exposing more things than necessary.
final class CustomerModel: Model, @unchecked Sendable {

    // Name of table this model represent.
    static let schema = "customers"

    // Unique ID of the customer (also works for Model).
    @ID(custom: "id", generatedBy: .user)
    var id: String?

    /// Secret of the customer.
    @Field(key: "secret")
    var secret: String

    /// Empty analyzer for fluent.
    public init() {
        secret = ""
    }

    /// Initialize the customer.
    ///
    /// - Parameters :
    ///   - id : Unique identifier of the customer.
    ///   - secret:Secret of the customer.
    public init( _ id: String? = nil, _ secret: String) {

        // Copy main members.
        self.secret = secret
        self.id = id
    }
}
