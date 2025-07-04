// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Vapor
import VividKernelContract
import VividKernelImpl

/// Kernel service as a Vapor Controller.
struct ServiceController: RouteCollection {

    /// Service to use.
    // TODO Bad practice, use inversion of control pattern instead.
    let service: any IKernelService = KernelServiceImpl()

    func boot(routes: any RoutesBuilder) throws {
        routes.get("customer", use: get)
    }

    func get(req: Request) async throws -> String {
        return service.createNewCustomer().id
    }
}
