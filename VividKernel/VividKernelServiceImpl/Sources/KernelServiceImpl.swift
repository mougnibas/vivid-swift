// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividKernelService
import VividKernelDataAccessService

/// Kernel service implementation..
public actor KernelServiceImpl: IKernelService {

    // Data service.
    var data: IDataAccessService

    public init ( _ dataService: IDataAccessService) {
        data = dataService
    }

    public func addCustomer(_ customer: Customer) async throws {
        try await data.addCustomer(customer)
    }

    public func createNewCustomer() async throws -> Customer {

        // Create a new customer.
        let customerId: String = UUID().uuidString
        let customerSecret: String = UUID().uuidString
        let customer: Customer = Customer(customerId, customerSecret)

        // Add it to the data.
        try await data.addCustomer(customer)

        // Return the result.
        return customer
    }

    public func getCustomer( _ id: String) async throws -> Customer? {
        return try await data.getCustomer(id)
    }

    public func getCustomers() async throws -> [Customer] {

        // Get the customers.
        let customersArray: [Customer] = try await data.getCustomers()

        // Return the result.
        return customersArray
    }
}
