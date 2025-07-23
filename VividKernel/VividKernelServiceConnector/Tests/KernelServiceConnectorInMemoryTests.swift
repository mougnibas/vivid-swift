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
import VividKernelDataAccessServiceInMemory
import VividKernelWebserviceLib
@testable import VividKernelServiceConnector

/// Unit tests of ``KernelServiceConnector`` class.
@Suite("KernelServiceConnector InMemory test")
final class KernelServiceConnectorInMemoryTests {

    // Random port used by vapor for the current test method to run.
    let vaporRandomPort: Int

    // Vapor Application.
    var app: Application!

    // Kernel service.
    private var kernelService: IKernelService?

    init() async throws {

        // Random port.
        vaporRandomPort = Int.random(in: 1024...65_535)

        // Start service and populate it.
        try await startVaporServer()
        try await populateService()
    }

    private func startVaporServer() async throws {

        // Get the environment.
        let env = try Environment.detect()

        // Create Vapor Application.
        app = try await Application.make(env)

        // Configure the application using the provided configure method.
        try await configureWithInMemory(app, vaporRandomPort)

        // We need to get a reference to the kernel service for testing purpose.
        self.kernelService = app.kernelService

        // Let start the application.
        try await app.startup()
    }

    private func populateService() async throws {

        guard let kernelService = self.kernelService else { return }
        try await kernelService.addCustomer(Customer("my-id", "my-secret"))
        try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
    }

    func vaporStop() async throws {
        try await app.asyncShutdown()
    }

    @Test("Default constructor should not throw exception")
    func defaultConstructorShouldNotThrowException() async throws {

        // Arrange, act and assert.
        #expect(throws: Never.self) {
            KernelServiceConnector("http://localhost", vaporRandomPort)
        }

        // Stop vapor instance.
        try await vaporStop()
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
    }
}
