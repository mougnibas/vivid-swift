// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividKernelService
@testable import VividKernelDataAccessService

/// Dummy implementation.
public struct DataAccessServiceDummy: IDataAccessService {

    /// Add a customer.
    ///
    /// - Parameter customer : The customer to add.
    public func addCustomer(_ customer: Customer) async throws {}

    /// Get a customer by id.
    ///
    /// - Parameter id :The id of the customer.
    ///
    /// - Returns : The customer, of nil if not found.
    public func getCustomer( _ id: String) async throws -> Customer? {
        return nil
    }

    /// Get all customers.
    ///
    /// - Returns : All customers (or empty array it there is no cutomers).
    public func getCustomers() async throws -> [Customer] {
        return []
    }
}
