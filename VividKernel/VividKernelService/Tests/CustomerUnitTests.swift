// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Testing
@testable import VividKernelService

/// Unit tests of ``Customer`` struct.
@Suite("Customer unit test")
struct CustomerUnitTests {

    @Test("Full constructor with this given identifier should have the same identifier", arguments: [
        "",
        "my-awesome-id"])
    func fullConstructorWithThisGivenIdShouldHaveTheSameId(id: String) throws {

        // Arrange.
        let expected: String = id
        let customer: Customer = Customer(id, "secret")

        // Act.
        let actual: String = customer.id

        // Assert.
        #expect(actual == expected)
    }

    @Test("Full constructor with this given secret should have the same secret", arguments: [
        "",
        "my-awesome-secret"])
    func fullConstructorWithThisGivenIdShouldHaveTheSameId(secret: String) throws {

        // Arrange.
        let expected: String = secret
        let customer: Customer = Customer("id", secret)

        // Act.
        let actual: String = customer.secret

        // Assert.
        #expect(actual == expected)
    }

    @Test("Equals", arguments: zip(
        [Customer("", ""), Customer("my-awesome-id", "my-awesome-secret")],
        [Customer("", ""), Customer("my-awesome-id", "my-awesome-secret")]))
    func thoseAreEquals(customerOne: Customer, customerTwo: Customer) throws {

        // Act.
        let actual: Bool = customerOne == customerTwo

        // Assert.
        #expect(actual == true)
    }

    @Test("Not Equals", arguments: zip(
        [Customer("a", "c"), Customer("my-awesome-id-1", "my-awesome-secret-1")],
        [Customer("b", "d"), Customer("my-awesome-id-2", "my-awesome-secret-2")]))
    func thoseAreNotEquals(customerOne: Customer, customerTwo: Customer) throws {

        // Act.
        let actual: Bool = customerOne != customerTwo

        // Assert.
        #expect(actual == true)
    }
}
