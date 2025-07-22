// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Vapor
import VividKernelDataAccessService
import VividKernelDataAccessServiceInMemory
import VividKernelService
import VividKernelServiceImpl

// configures your application
public func configureWithInMemory(_ app: Application) async throws {

    // Listening on any interface.
    app.http.server.configuration.hostname = "0.0.0.0"

    // Listening on this port.
    app.http.server.configuration.port = 50_000

    // We instantiate the data service implementation and kernel service implementation.
    // We explicitly use the InMemory implementation of DataAccessService.
    // We explicitly use the default implementation of KernelService.
    let dataAccessService: IDataAccessService = DataAccessServiceInMemory()
    let kernelService: any IKernelService = KernelServiceImpl(dataAccessService)

    // Store the kernel service globally in the app container.
    app.kernelService = kernelService

    // Create the controller with the kernel service, from app storage.
    let customerController = CustomerController(service: app.kernelService)

    // Register my controller.
    try app.register(collection: customerController)
}
