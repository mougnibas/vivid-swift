// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Testing
import VividKernelService
@testable import VividKernelDataAccessService

/// Unit tests of ``IDataAccessService``  protocol with a dummy implementation.
@Suite("IDataAccessService unit test")
struct IDataAccessServiceUnitTest {

    // Service to test.
    let service: IDataAccessService

    init() {

        // The  service to test is actually a protocol.
        // We have created a dummy implementation to "test" the protocol logic, not the actual implementation.
        service = DataAccessServiceDummy()
    }

    @Test("Calling 'addCustomer' should not throw exception")
    func addCustomerShouldNotThrowException() async throws {

        // Arrange, act and assert.
        await #expect(throws: Never.self) {
            try await service.addCustomer(Customer("", ""))
        }
    }

    @Test("Calling 'getCustomer' should return nil")
    func getCustomerShouldReturnNil() async throws {

        // Arrange.
        let id: String = "fakeId"
        let expected: Customer? = nil

        // Act.
        let actual: Customer? = try await service.getCustomer(id)

        // Assert.
        #expect(actual == expected)
    }

    @Test("Calling 'getCustomers' should return an empty array")
    func getCustomersShouldReturnEmptyArray() async throws {

        // Arrange.
        let expected: [Customer] = []

        // Act.
        let actual: [Customer] = try await service.getCustomers()

        // Expected.
        #expect(actual == expected)
    }
}
