// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

@testable import VividKernelWebserviceLib
import VividKernelContract
import VividKernelImpl
import VaporTesting
import Testing

@Suite("KernelServiceCustomerController unit test")
struct KernelServiceCustomerControllerTests {

    // KernelService to be used by controller.
    let kernelService: any IKernelService

    init() async throws {
        kernelService = InMemoryKernelServiceImpl()
        try await kernelService.addCustomer(Customer("my-id", "my-secret"))
        try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
    }

    @Test("Send POST to customer (with json) should return this new customer")
    func sendPostToCustomerWithJsonShouldReturnThisNewCustomer() async throws {

        // Arrange
        let expectedStatus: HTTPResponseStatus = .ok
        let expected: Customer = Customer("my-id-3", "my-secret-3")
        let json: Data = try JSONEncoder().encode(CustomerDTO(id: expected.id, secret: expected.secret))

        // Act.
        // swiftlint:disable multiple_closures_with_trailing_closure
        try await withApp(configure: { app in try await configure(kernelService, app)}) { app in
        // swiftlint:enable multiple_closures_with_trailing_closure

            try await app.testing().test(
                .POST,
                "customer",
                headers: ["Content-Type": "application/json"],
                body: .init(data: json),
                afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let actual: Customer? = try await kernelService.getCustomer(expected.id)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actual == expected)
            })
        }
    }

    @Test("Send POST to customer should return one more customer")
    func sendPostToCustomerShouldReturnOneMoreCustomer() async throws {

        // Arrange
        let expectedStatus: HTTPResponseStatus = .ok
        let numberOfCustomersBefore: Int = try await kernelService.getCustomers().count
        let expectedNumberOfCustomersAfter: Int = numberOfCustomersBefore + 1

        // Act.
        // swiftlint:disable multiple_closures_with_trailing_closure
        try await withApp(configure: { app in try await configure(kernelService, app)}) { app in
        // swiftlint:enable multiple_closures_with_trailing_closure

            try await app.testing().test(.POST, "customer/auto", afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let actualNumberOfCustomersAfter: Int = try await kernelService.getCustomers().count

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualNumberOfCustomersAfter == expectedNumberOfCustomersAfter)
            })
        }
    }

    @Test("Send Get To Customer With 'my-id-not-found' Parameter Should Return 404")
    func sendGetToCustomerWithUnknowIdShouldReturn404() async throws {

        // Arrange
        let expectedStatus: HTTPResponseStatus = .notFound

        // Act.
        // swiftlint:disable multiple_closures_with_trailing_closure
        try await withApp(configure: { app in try await configure(kernelService, app)}) { app in
        // swiftlint:enable multiple_closures_with_trailing_closure

            try await app.testing().test(.GET, "customer/my-id-not-found", afterResponse: { response async in

                let actualStatus: HTTPResponseStatus = response.status

                // Assert.
                #expect(actualStatus == expectedStatus)
            })
        }
    }

    @Test("Send Get To Customer With 'my-id' Parameter Should Return That Customer")
    func sendGetToCustomerWithMyIdParameterShouldReturnThatCustomer() async throws {

        // Arrange
        let expectedStatus: HTTPResponseStatus = .ok
        let expectedContent: CustomerDTO = CustomerDTO(id: "my-id", secret: "my-secret")

        // Act.
        // swiftlint:disable multiple_closures_with_trailing_closure
        try await withApp(configure: { app in try await configure(kernelService, app)}) { app in
        // swiftlint:enable multiple_closures_with_trailing_closure

            try await app.testing().test(.GET, "customer/my-id", afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let json: String = response.body.string
                let jsonData: Data? = json.data(using: .utf8)
                let actualContent: CustomerDTO? = try JSONDecoder().decode(CustomerDTO.self, from: jsonData!)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        }
    }

    @Test("Send Get To Customer With 'my-id-2' Parameter Should Return That Customer")
    func sendGetToCustomerWithMyId2ParameterShouldReturnThatCustomer() async throws {

        // Arrange
        let expectedStatus: HTTPResponseStatus = .ok
        let expectedContent: CustomerDTO = CustomerDTO(id: "my-id-2", secret: "my-secret-2")

        // Act.
        // swiftlint:disable multiple_closures_with_trailing_closure
        try await withApp(configure: { app in try await configure(kernelService, app)}) { app in
        // swiftlint:enable multiple_closures_with_trailing_closure

            try await app.testing().test(.GET, "customer/my-id-2", afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let json: String = response.body.string
                let jsonData: Data? = json.data(using: .utf8)
                let actualContent: CustomerDTO? = try JSONDecoder().decode(CustomerDTO.self, from: jsonData!)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        }
    }

    @Test("Send Get To Customer Without Any Parameter Should Return Those Customers")
    func sendGetToCustomerWithoutAnyParameterShouldReturnThoseCustomers() async throws {

        // Arrange
        let expectedStatus: HTTPResponseStatus = .ok
        let expectedContent: [CustomerDTO] = [
            CustomerDTO(id: "my-id", secret: "my-secret"),
            CustomerDTO(id: "my-id-2", secret: "my-secret-2")
        ]

        // Act.
        // swiftlint:disable multiple_closures_with_trailing_closure
        try await withApp(configure: { app in try await configure(kernelService, app)}) { app in
        // swiftlint:enable multiple_closures_with_trailing_closure

            try await app.testing().test(.GET, "customer", afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let json: String = response.body.string
                let jsonData: Data? = json.data(using: .utf8)
                let actualContent: [CustomerDTO]? = try JSONDecoder().decode([CustomerDTO].self, from: jsonData!)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        }
    }
}
