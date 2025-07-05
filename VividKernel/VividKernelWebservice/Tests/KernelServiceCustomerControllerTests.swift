// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

@testable import VividKernelWebservice
import VividCommon
import VaporTesting
import Testing

@Suite("KernelServiceCustomerController unit test")
struct KernelServiceCustomerControllerTests {

    @Test("Send POST to customer should return this new customer")
    func sendPostToCustomerShouldReturnThisNewCustomer() async throws {

        // Arrange
        let expectedStatus: HTTPResponseStatus = .ok
        let expectedContent: CustomerDTO = CustomerDTO(id: "my-new-id", secret: "my-new-secret")

        // Act.
        try await withApp(configure: configure) { app in

            try await app.testing().test(.POST, "customer", afterResponse: { res async throws in

                let actualStatus: HTTPResponseStatus = res.status
                let json: String = res.body.string
                let jsonData: Data? = json.data(using: .utf8)
                let actualContent: CustomerDTO? = try JSONDecoder().decode(CustomerDTO.self, from: jsonData!)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        }
    }

    @Test("Send Get To Customer With 'my-id-not-found' Parameter Should Return 404")
    func sendGetToCustomerWithUnknowIdShouldReturn404() async throws {

        // Arrange
        let expectedStatus: HTTPResponseStatus = .notFound

        // Act.
        try await withApp(configure: configure) { app in

            try await app.testing().test(.GET, "customer/my-id-not-found", afterResponse: { res async in

                let actualStatus: HTTPResponseStatus = res.status

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
        try await withApp(configure: configure) { app in

            try await app.testing().test(.GET, "customer/my-id", afterResponse: { res async throws in

                let actualStatus: HTTPResponseStatus = res.status
                let json: String = res.body.string
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
        try await withApp(configure: configure) { app in

            try await app.testing().test(.GET, "customer/my-id-2", afterResponse: { res async throws in

                let actualStatus: HTTPResponseStatus = res.status
                let json: String = res.body.string
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
        try await withApp(configure: configure) { app in
            try await app.testing().test(.GET, "customer", afterResponse: { res async throws in

                let actualStatus: HTTPResponseStatus = res.status
                let json: String = res.body.string
                let jsonData: Data? = json.data(using: .utf8)
                let actualContent: [CustomerDTO]? = try JSONDecoder().decode([CustomerDTO].self, from: jsonData!)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        }
    }
}
