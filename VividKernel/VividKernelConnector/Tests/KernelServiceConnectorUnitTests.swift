// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Testing
import Vapor
import VividKernelContract
import VividKernelImpl
import VividKernelWebserviceLib
@testable import VividKernelConnector

/// Unit tests of ``KernelServiceConnector`` class.
@Suite("KernelServiceConnector unit test", .serialized)
struct KernelServiceConnectorUnitTests {

    // Internal service.
    let serviceInternal: IKernelService

    // Service to test.
    let service: KernelServiceConnector

    // Vapor Application.
    let app: Application

    init() async throws {

        // Create and populate the internal service.
        serviceInternal = InMemoryKernelServiceImpl()
        await serviceInternal.addCustomer(Customer("my-id", "my-secret"))
        await serviceInternal.addCustomer(Customer("my-id-2", "my-secret-2"))

        // Run embeded Vapor server.
        let env = try Environment.detect()
        app = try await Application.make(env)
        try app.register(collection: KernelServiceCustomerController(service: serviceInternal))
        try await app.startup()

        // Create a connector.
        service = KernelServiceConnector()
    }

    func vaporStop() async throws {
        try await app.asyncShutdown()
    }

    @Test("Default constructor should not throw exception")
    func defaultConstructorShouldNotThrowException() async throws {

        // Arrange, act and assert.
        #expect(throws: Never.self) {
            KernelServiceConnector()
        }

        // Stop vapor instance.
        try await vaporStop()
    }

    @Test("'addCustomer' then 'getCustomer' should return this customer")
    func addCustomerShouldThenGetCustomerShouldReturnThisCustomer() async throws {

        // Arrange.
        let expected: Customer = Customer("my-id-3", "my-secret-3")

        // Act.
        await service.addCustomer(expected)
        let actual: Customer? = await service.getCustomer(expected.id)

        // Assert.
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()
    }

    @Test("Calling 'createNewCustomer' should return one more customer")
    func createNewCustomerShouldReturnOneMoreCustomer() async throws {

        // Arrange.
        let numberOfCustomersBefore: Int = await service.getCustomers().count
        let expected: Int = numberOfCustomersBefore + 1

        // Act.
        _ = await service.createNewCustomer()

        // Assert.
        let actual: Int = await service.getCustomers().count
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()
    }

    @Test("get customer by id with 'my-id' should return this customer")
    func getCustomerByIdWithIdOneShouldReturnThisCustomer() async throws {

        // Arrange.
        let expected: Customer = Customer("my-id", "my-secret")

        // Act.
        let actual: Customer? = await service.getCustomer("my-id")

        // Assert
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()
    }

    @Test("get customer by id with 'my-id-2' should return this customer")
    func getCustomerByIdWithIdTwoShouldReturnThisCustomer() async throws {

        // Arrange.
        let expected: Customer = Customer("my-id-2", "my-secret-2")

        // Act.
        let actual: Customer? = await service.getCustomer("my-id-2")

        // Assert
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()
    }

    @Test("get customer by id with 'my-id-3' should return nil")
    func getCustomerByIdWithIdThreeShouldReturnNil() async throws {

        // Arrange.
        let expected: Customer? = nil

        // Act.
        let actual: Customer? = await service.getCustomer("my-id-3")

        // Assert
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()
    }

    @Test("get all customers should return all customers")
    func getCustomersShouldReturnThisCustomers() async throws {

        // Arrange.
        let expected: [Customer] = [
            Customer("my-id", "my-secret"),
            Customer("my-id-2", "my-secret-2")
        ]

        // Act.
        let actual: [Customer] = await service.getCustomers()

        // Assert
        #expect(actual == expected)

        // Stop vapor instance.
        try await vaporStop()
    }
}
