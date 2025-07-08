// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation

/// Definition of Kernel service.
public protocol IKernelService: Sendable {

    /// Add a customer.
    ///
    /// - Parameters :
    ///   - customer: The customer to add.
    func addCustomer(_ customer: Customer) async throws

    /// Create, then return a new customer.
    ///
    /// - Returns: A newly created customer.
    func createNewCustomer() async throws -> Customer

    /// Get a customer, by id, (if any).
    ///
    /// - Parameters:
    ///  - id: Identifier of a customer
    ///
    /// - Returns The customer if identifier exist, nil otherwise.
    func getCustomer(_ id: String) async throws -> Customer?

    /// Get all customers.
    ///
    /// - Returns : All customers.
    func getCustomers() async throws -> [Customer]
}
