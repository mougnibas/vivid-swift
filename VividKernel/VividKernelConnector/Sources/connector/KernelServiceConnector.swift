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
public actor KernelServiceConnector: IKernelService {

    public func addCustomer(_ customer: Customer) {
        // TODO Write this method.
    }

    public func createNewCustomer() -> Customer {
        // TODO Write this method.
        return Customer("id", "secret")
    }

    public func getCustomer( _ id: String) -> Customer? {
        // TODO Write this method.
        return Customer("id", "secret")
    }

    public func getCustomers() -> [Customer] {
        // TODO Write this method.
        return [Customer("id", "secret")]
    }
}
