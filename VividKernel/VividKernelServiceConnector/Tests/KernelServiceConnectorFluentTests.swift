// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Testing
import Vapor
import VividKernelService
import VividKernelServiceImpl
import VividKernelDataAccessService
import VividKernelDataAccessServiceFluent
import VividKernelWebserviceLib
@testable import VividKernelServiceConnector

/// Unit tests of ``KernelServiceConnector`` class.
@Suite("KernelServiceConnector Fluent test")
final class KernelServiceConnectorFluentTests {

    // Random port used by vapor for the current test method to run.
    let vaporRandomPort: Int

    // Random port used by docker for postgresql container for the current test method to run.
    let postgresqlRandomPort: Int

    // Random name used by docker for postgresql container for the current test method to run.
    let postgresqlRandomName: String

    // Vapor Application.
    var app: Application!

    // Kernel service.
    private var kernelService: IKernelService?

    init() async throws {

        vaporRandomPort = Int.random(in: 1024...65_535)
        postgresqlRandomPort = Int.random(in: 1024...65_535)
        postgresqlRandomName = "postgresql-test-\(postgresqlRandomPort)"

        try await startPostgresContainerThenWaitForItToBeReady()
        try await startVaporServer()
        try await populateService()
    }

    private func startPostgresContainerThenWaitForItToBeReady() async throws {

        // Start the container.
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/local/bin/docker")
        process.arguments = [
            "run", "--rm", "--detach",
            "--name", postgresqlRandomName,
            "--hostname", postgresqlRandomName,
            "--env", "POSTGRES_PASSWORD=mysecretpassword",
            "--publish", "\(postgresqlRandomPort):5432",
            "postgres:17.5-bookworm"
        ]
        try process.run()
        process.waitUntilExit()

        // Wait for it to be reader.
        let maxAttempts = 15
        let delay: UInt64 = 500_000_000 // 0.5 seconds
        for _ in 0..<maxAttempts {
            let checkProcess = Process()
            checkProcess.executableURL = URL(fileURLWithPath: "/usr/local/bin/docker")
            checkProcess.arguments = [
                "exec", postgresqlRandomName,
                "pg_isready",
                "-U", "postgres"
            ]
            let pipe = Pipe()
            checkProcess.standardOutput = pipe
            try checkProcess.run()
            checkProcess.waitUntilExit()
            let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: outputData, encoding: .utf8), output.contains("accepting connections") {
                break
            }
            try await Task.sleep(nanoseconds: delay)
        }
        try await Task.sleep(for: .seconds(2))
    }

    private func startVaporServer() async throws {

        let env = try Environment.detect()
        app = try await Application.make(env)
        app.http.server.configuration.hostname = "0.0.0.0"
        app.http.server.configuration.port = vaporRandomPort
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: "localhost",
                    port: postgresqlRandomPort,
                    username: "postgres",
                    password: "mysecretpassword",
                    database: "postgres",
                    tls: .disable
                )
            ),
            as: .psql
        )
        app.migrations.add(Migration001())
        try await app.autoMigrate()
        let kernelService = KernelServiceImpl(DataAccessServiceFluent(app.db)) as IKernelService
        try app.register(collection: CustomerController(kernelService))
        try await app.startup()
        self.kernelService = kernelService
    }

    private func populateService() async throws {

        guard let kernelService = self.kernelService else { return }
        try await kernelService.addCustomer(Customer("my-id", "my-secret"))
        try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
    }

    func vaporStop() async throws {
        try await app.asyncShutdown()
    }

    func dockerStop() async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/local/bin/docker")
        process.arguments = [
            "container", "stop", postgresqlRandomName
        ]
        try process.run()
        process.waitUntilExit()
    }

    @Test("Default constructor should not throw exception")
    func defaultConstructorShouldNotThrowException() async throws {

        // Arrange, act and assert.
        #expect(throws: Never.self) {
            KernelServiceConnector("http://localhost", vaporRandomPort)
        }

        // Stop vapor instance.
        try await vaporStop()

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("'addCustomer' then 'getCustomer' should return this customer")
    func addCustomerShouldThenGetCustomerShouldReturnThisCustomer() async throws {

        // Arrange.
        let service: KernelServiceConnector = KernelServiceConnector("http://localhost", vaporRandomPort)
        let expected: Customer = Customer("my-id-3", "my-secret-3")

        // Act.
        try await service.addCustomer(expected)
        let actual: Customer? = try await service.getCustomer(expected.id)

        // Assert.
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()

        // Stop docker instance.
        try await dockerStop()
    }

    @Test
    func addCustomerWithInvalidConnectorParametersShouldNotThrowException() async throws {

        // Arrange.
        let service: KernelServiceConnector = KernelServiceConnector("http://localhosttttttt", vaporRandomPort)
        let expected: Customer = Customer("my-id-3", "my-secret-3")

        // Act and Assert.
        async #expect(throws: Never.self) {
            await service.addCustomer(expected)
        }

        // Stop vapor instance.
        try await vaporStop()

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("Calling 'createNewCustomer' should return one more customer")
    func createNewCustomerShouldReturnOneMoreCustomer() async throws {

        // Arrange.
        let service: KernelServiceConnector = KernelServiceConnector("http://localhost", vaporRandomPort)
        let numberOfCustomersBefore: Int = try await service.getCustomers().count
        let expected: Int = numberOfCustomersBefore + 1

        // Act.
        _ = try await service.createNewCustomer()

        // Assert.
        let actual: Int = try await service.getCustomers().count
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("get customer by id with 'my-id' should return this customer")
    func getCustomerByIdWithIdOneShouldReturnThisCustomer() async throws {

        // Arrange.
        let service: KernelServiceConnector = KernelServiceConnector("http://localhost", vaporRandomPort)
        let expected: Customer = Customer("my-id", "my-secret")

        // Act.
        let actual: Customer? = try await service.getCustomer("my-id")

        // Assert
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("get customer by id with 'my-id-2' should return this customer")
    func getCustomerByIdWithIdTwoShouldReturnThisCustomer() async throws {

        // Arrange.
        let service: KernelServiceConnector = KernelServiceConnector("http://localhost", vaporRandomPort)
        let expected: Customer = Customer("my-id-2", "my-secret-2")

        // Act.
        let actual: Customer? = try await service.getCustomer("my-id-2")

        // Assert
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("get customer by id with 'my-id-3' should return nil")
    func getCustomerByIdWithIdThreeShouldReturnNil() async throws {

        // Arrange.
        let service: KernelServiceConnector = KernelServiceConnector("http://localhost", vaporRandomPort)
        let expected: Customer? = nil

        // Act.
        let actual: Customer? = try await service.getCustomer("my-id-3")

        // Assert
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("get all customers should return all customers")
    func getCustomersShouldReturnThisCustomers() async throws {

        // Arrange.
        let service: KernelServiceConnector = KernelServiceConnector("http://localhost", vaporRandomPort)
        let expected: [Customer] = [
            Customer("my-id", "my-secret"),
            Customer("my-id-2", "my-secret-2")
        ]

        // Act.
        let actual: [Customer] = try await service.getCustomers()

        // Assert
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()

        // Stop docker instance.
        try await dockerStop()
    }
}
