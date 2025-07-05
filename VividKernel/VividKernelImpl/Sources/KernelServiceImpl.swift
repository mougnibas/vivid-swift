// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividCommon
import VividKernelContract

/// Connector based implementation of kernel service.
public final class KernelServiceImpl: IKernelService {

    let customer1: Customer = Customer("my-id", "my-secret")
    let customer2: Customer = Customer("my-id-2", "my-secret-2")

    public init () {}

    public func createNewCustomer() -> Customer {
        // TODO Write a valid implementation.
        return Customer("my-new-id", "my-new-secret")
    }

    public func getCustomer( _ id: String) -> Customer? {
        // TODO Write a valid implementation.
        if id == "my-id" {
            return customer1
        } else if id == "my-id-2" {
            return customer2
        } else {
            return nil
        }
    }

    public func getCustomers() -> [Customer] {
        // TODO Write a valid implementation.
        return [ customer1, customer2 ]
    }
}
