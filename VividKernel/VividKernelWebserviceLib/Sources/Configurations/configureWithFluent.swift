// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver
import VividKernelDataAccessService
import VividKernelDataAccessServiceFluent
import VividKernelService
import VividKernelServiceImpl

// configures your application
public func configureWithFluent(
    _ app: Application,
    _ vaportPort: Int?,
    _ pgsqlHost: String?,
    _ pgsqlPort: Int?) async throws {

        // Get the environemt variables.
        // Priorities : method arg value > environment value > default
        let vaportPortToUse: Int = vaportPort ?? Int(Environment.get("VAPOR_PORT") ?? "50000")!
        let pgsqlHostToUse: String = pgsqlHost ?? Environment.get("PGSQL_HOST") ?? "localhost"
        let pgsqlPortToUse: Int = pgsqlPort ?? Int(Environment.get("PGSQL_PORT") ?? "5432")!

        // Listening on any interface.
        app.http.server.configuration.hostname = "0.0.0.0"

        // Listening on this port.
        app.http.server.configuration.port = vaportPortToUse

        // Configure a database (postgresql).
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: pgsqlHostToUse,
                    port: pgsqlPortToUse,
                    username: "postgres",
                    password: "mysecretpassword",
                    database: "postgres",
                    tls: .disable
                )
            ),
            as: .psql
        )

        // Configure migrations.
        app.migrations.add(Migration001())

        // Run migrations.
        try await app.autoMigrate()

        // We instantiate the data service implementation and kernel service implementation.
        // We explicitly use the Fluent implementation of DataAccessService.
        // We explicitly use the default implementation of KernelService.
        let dataAccessService: IDataAccessService = DataAccessServiceFluent(app.db)
        let kernelService: any IKernelService = KernelServiceImpl(dataAccessService)

        // Store the kernel service globally in the app container.
        app.kernelService = kernelService

        // Create the controller with the kernel service, from app storage.
        let customerController = CustomerController(app.kernelService)

        // Register my controller.
        try app.register(collection: customerController)
}
