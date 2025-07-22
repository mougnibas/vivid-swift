// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Testing
import Vapor
import Fluent
import FluentPostgresDriver
import VividKernelService
import VividKernelDataAccessService
@testable import VividKernelDataAccessServiceFluent

/// Integration tests of ``DataAccessServiceFluent`` class.
@Suite("DataAccessServiceFluent integration test")
struct DataAccessServiceFluentIntegrationTests {

    // Random port used by vapor for the current test method to run.
    let vaporRandomPort: Int

    // Random port used by docker for postgresql container for the current test method to run.
    let postgresqlRandomPort: Int

    // Random name used by docker for postgresql container for the current test method to run.
    let postgresqlRandomName: String

    // Service to test
    let service: DataAccessServiceFluent

    // Vapor Application.
    let app: Application

    init() async throws {

        // Random ports and name.
        vaporRandomPort = Int.random(in: 1024...65_535)
        postgresqlRandomPort = Int.random(in: 1024...65_535)
        postgresqlRandomName = "postgresql-test-\(postgresqlRandomPort)"

        // Start a docker container running a postgresql instance.
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
        if process.terminationStatus != 0 {
            throw NSError(domain: "DockerStartFailed", code: Int(process.terminationStatus))
        }

        // TODO Find a better way to do this (healthcheck maybe).
        // Wait for 1s for the container to be ready.
        try await Task.sleep(for: .seconds(2))

        // Run embeded Vapor server.
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
        try await app.startup()

        // Service to test.
        service = DataAccessServiceFluent(app.db)
        do {
            try await service.addCustomer(Customer("my-id", "my-secret"))
            try await service.addCustomer(Customer("my-id-2", "my-secret-2"))
        } catch {
            print(String(reflecting: error))
        }
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
        if process.terminationStatus != 0 {
            throw NSError(domain: "DockerStartFailed", code: Int(process.terminationStatus))
        }
    }

    @Test("'addCustomer' then 'getCustomer' should return this customer")
    func addCustomerShouldThenGetCustomerShouldReturnThisCustomer() async throws {

        // Arrange.
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

    @Test("get customer by id with 'my-id' should return this customer")
    func getCustomerByIdWithIdOneShouldReturnThisCustomer() async throws {

        // Arrange.
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
