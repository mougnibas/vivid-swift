// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividCommon

/// Connector based implementation of kernel service.
public class KernelServiceConnector: IKernelService {

    let customer1: Customer = Customer("my-id", "my-name")
    let customer2: Customer = Customer("my-id-2", "my-name-2")

    public func createNewCustomer() -> Customer {
        // TODO Write a valid implementation.
        return Customer("my-new-id", "my-new-name")
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
