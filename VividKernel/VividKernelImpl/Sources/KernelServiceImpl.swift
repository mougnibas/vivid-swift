// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividKernelContract

/// Kernel service implementation..
public actor KernelServiceImpl: IKernelService {

    // Data service.
    var data: IDataAccessService

    init ( _ dataService: IDataAccessService) {
        data = dataService
    }

    public func addCustomer(_ customer: Customer) {
        data.addCustomer(customer)
    }

    public func createNewCustomer() -> Customer {

        // Create a new customer.
        let customerId: String = UUID().uuidString
        let customerSecret: String = UUID().uuidString
        let customer: Customer = Customer(customerId, customerSecret)

        // Add it to the data.
        data.addCustomer(customer)

        // Return the result.
        return customer
    }

    public func getCustomer( _ id: String) -> Customer? {
        return data.getCustomer(id)
    }

    public func getCustomers() -> [Customer] {

        // Get the customers.
        var customersArray: [Customer] = data.getCustomers()

        // Sort the customers, to retrieve them always in the same order.
        customersArray.sort { $0.id < $1.id }

        // Return the result.
        return customersArray
    }
}
