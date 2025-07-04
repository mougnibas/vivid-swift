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
public class KernelServiceImpl: IKernelService {

    public init () {}

    public func createNewCustomer() -> Customer {
        // TODO Write a valid implementation.
        return Customer("my-id", "my-name")
    }
}
