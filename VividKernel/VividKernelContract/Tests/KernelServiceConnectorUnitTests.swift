// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Testing
import VividCommon
@testable import VividKernelContract

/// Unit tests of ``KernelServiceConnector`` class.
@Suite("KernelServiceConnector unit test")
struct KernelServiceConnectorUnitTests {

    @Test("Default constructor should not throw exception")
    func defaultConstructorShouldNotThrowException() throws {

        // Arrange, act and assert.
        #expect(throws: Never.self) {
            KernelServiceConnector()
        }
    }

    @Test("Calling 'createNewCustomer' should return this customer")
    func createNewCustomerShouldReturnThisCustomer() throws {

        // Arrange.
        let service: IKernelService = KernelServiceConnector()
        let expected: Customer = Customer("my-new-id", "my-new-name")

        // Act.
        let actual: Customer = service.createNewCustomer()

        // Assert.
        #expect(actual == expected)
    }

    @Test("get customer by id with 'my-id' should return this customer")
    func getCustomerByIdWithIdOneShouldReturnThisCustomer() throws {

        // Arrange.
        let service: IKernelService = KernelServiceConnector()
        let expected: Customer = Customer("my-id", "my-name")

        // Act.
        let actual: Customer? = service.getCustomer("my-id")

        // Assert
        #expect(actual == expected)
    }

    @Test("get customer by id with 'my-id-2' should return this customer")
    func getCustomerByIdWithIdTwoShouldReturnThisCustomer() throws {

        // Arrange.
        let service: IKernelService = KernelServiceConnector()
        let expected: Customer = Customer("my-id-2", "my-name-2")

        // Act.
        let actual: Customer? = service.getCustomer("my-id-2")

        // Assert
        #expect(actual == expected)
    }

    @Test("get customer by id with 'my-id-3' should return nil")
    func getCustomerByIdWithIdThreeShouldReturnNil() throws {

        // Arrange.
        let service: IKernelService = KernelServiceConnector()
        let expected: Customer? = nil

        // Act.
        let actual: Customer? = service.getCustomer("my-id-3")

        // Assert
        #expect(actual == expected)
    }

    @Test("get all customers should return all customers")
    func getCustomersShouldReturnThisCustomers() throws {

        // Arrange.
        let service: IKernelService = KernelServiceConnector()
        let expected: [Customer] = [
            Customer("my-id", "my-name"),
            Customer("my-id-2", "my-name-2")
        ]

        // Act.
        let actual: [Customer] = service.getCustomers()

        // Assert
        #expect(actual == expected)
    }
}
