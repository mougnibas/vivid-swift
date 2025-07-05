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

@Suite("VividKernelWebservice unit test")
struct VividKernelWebserviceTests {

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
            try await app.testing().test(.GET, "customer", afterResponse: { res async in

                let actualStatus: HTTPResponseStatus = res.status
                var actualContent: [CustomerDTO]? = []
                do {
                    let json: String = res.body.string
                    let jsonData: Data? = json.data(using: .utf8)
                    actualContent = try JSONDecoder().decode([CustomerDTO].self, from: jsonData!)
                } catch {
                    actualContent = nil
                }

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        }
    }
}
