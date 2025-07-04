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
        let expected: Customer = Customer("my-id", "my-name")

        // Act.
        let actual: Customer = service.createNewCustomer()

        // Assert.
        #expect(actual == expected)
    }
}
