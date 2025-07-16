// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividKernelContract
import VividKernelDataAccessService

/// In-memory data access service implementation..
public class DataAccessServiceInMemory: IDataAccessService {

    // Map of customers.
    var customers: [String: Customer] = [:]

    public init () {}

    public func addCustomer(_ customer: Customer) {
        customers[customer.id] = customer
    }

    public func getCustomer( _ id: String) -> Customer? {

        // Try to find the customer.
        let customer: Customer? = customers[id]

        // If the customer is not found, return nil.
        guard customer != nil else {
            return nil
        }

        // Customer if found. Return it.
        return customer
    }

    public func getCustomers() -> [Customer] {

        // Get the customers.
        var customersArray: [Customer] = Array(customers.values)

        // Sort the customers, to retrieve them always in the same order.
        customersArray.sort { $0.id < $1.id }

        // Return the result.
        return customersArray
    }
}
