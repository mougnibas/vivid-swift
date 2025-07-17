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
import VividKernelDataAccessService
@testable import VividKernelDataAccessServiceFluent

/// Unit tests of ``DataAccessServiceFluent`` class.
@Suite("DataAccessServiceFluent unit test")
struct DataAccessServiceFluentUnitTests {

    // Service to test
    let service: DataAccessServiceFluent

    // Vapor Application.
    let app: Application

    init() async throws {

        // Run embeded Vapor server.
        let env = try Environment.detect()
        app = try await Application.make(env)
        app.http.server.configuration.hostname = "0.0.0.0"
        app.http.server.configuration.port = 50_000
        try await app.startup()

        // Service to test.
        service = DataAccessServiceFluent(app.db)
        try await service.addCustomer(Customer("my-id", "my-secret"))
        try await service.addCustomer(Customer("my-id-2", "my-secret-2"))
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
    }

    @Test("get customer by id with 'my-id' should return this customer")
    func getCustomerByIdWithIdOneShouldReturnThisCustomer() async throws {

        // Arrange.
        let expected: Customer = Customer("my-id", "my-secret")

        // Act.
        let actual: Customer? = try await service.getCustomer("my-id")

        // Assert
        #expect(actual == expected)
    }

    @Test("get customer by id with 'my-id-2' should return this customer")
    func getCustomerByIdWithIdTwoShouldReturnThisCustomer() async throws {

        // Arrange.
        let expected: Customer = Customer("my-id-2", "my-secret-2")

        // Act.
        let actual: Customer? = try await service.getCustomer("my-id-2")

        // Assert
        #expect(actual == expected)
    }

    @Test("get customer by id with 'my-id-3' should return nil")
    func getCustomerByIdWithIdThreeShouldReturnNil() async throws {

        // Arrange.
        let expected: Customer? = nil

        // Act.
        let actual: Customer? = try await service.getCustomer("my-id-3")

        // Assert
        #expect(actual == expected)
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
    }
}
