// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Vapor
import Logging
import VividKernelService
import VividKernelServiceImpl
import VividKernelDataAccessService
import VividKernelDataAccessServiceInMemory
import VividKernelWebserviceLib

@main
enum Entrypoint {
    static func main() async throws {

        // Get the environment.
        var env: Environment = try Environment.detect()

        // Create logging.
        try LoggingSystem.bootstrap(from: &env)

        // Create Vapor Application.
        let app = try await Application.make(env)

        do {

            // We instantiate the data service implementation and kernel service implementation.
            // We explicitly use the InMemory implementation of DataAccessService.
            // We explicitly use the default implementation of KernelService.
            let dataAccessService: IDataAccessService = DataAccessServiceInMemory()
            let kernelService: any IKernelService = KernelServiceImpl(dataAccessService)

            // Configure the application using the provided configure method.
            try await configure(kernelService, app)

            // Let start the application.
            try await app.execute()

        } catch {

            // Handle error and vapor shutdown.
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }

        // Application lifecycle ended.
        // Gracefully stop it.
        try await app.asyncShutdown()
    }
}
