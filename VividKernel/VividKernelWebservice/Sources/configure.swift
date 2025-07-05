// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Vapor

// configures your application
public func configure(_ app: Application) async throws {

    // Register my controller.
    try app.register(collection: KernelServiceCustomerController())

    // register routes.
    try routes(app)
}
