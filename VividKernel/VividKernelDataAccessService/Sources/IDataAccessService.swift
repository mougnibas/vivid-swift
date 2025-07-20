// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividKernelService

/// Service for accessing datas.
public protocol IDataAccessService: Sendable {

    /// Add a customer.
    ///
    /// - Parameter customer : The customer to add.
    func addCustomer(_ customer: Customer) async throws

    /// Get a customer by id.
    ///
    /// - Parameter id :The id of the customer.
    ///
    /// - Returns : The customer, of nil if not found.
    func getCustomer( _ id: String) async throws -> Customer?

    /// Get all customers.
    ///
    /// - Returns : All customers (or empty array it there is no cutomers).
    func getCustomers() async throws -> [Customer]
}
