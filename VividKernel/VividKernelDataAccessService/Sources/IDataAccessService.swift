// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividKernelContract

/// Service for accessing datas.
public protocol IDataAccessService {

    /// Add a customer.
    ///
    /// - Parameter customer : The customer to add.
    func addCustomer(_ customer: Customer)

    /// Get a customer by id.
    ///
    /// - Parameter id :The id of the customer.
    ///
    /// - Returns : The customer, of nil if not found.
    func getCustomer( _ id: String) -> Customer?

    /// Get all customers.
    ///
    /// - Returns : All customers (or empty array it there is no cutomers).
    func getCustomers() -> [Customer]
}
