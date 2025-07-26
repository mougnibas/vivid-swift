// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VaporTesting
import Testing
import VividKernelService
import VividKernelServiceImpl
import VividKernelDataAccessService
import VividKernelDataAccessServiceFluent
import VividKernelWebserviceLibFluent
@testable import VividKernelWebserviceLib

@Suite("CustomerControllerFluent test")
final class CustomerControllerFluentTests {

    // Random port used by vapor for the current test method to run.
    var vaporPort: Int

    // PostgreSQL host.
    let pgsqlHost: String = "localhost"

    // Random port used by docker for postgresql container for the current test method to run.
    var pgsqlPort: Int

    // Random name used by docker for postgresql container for the current test method to run.
    let postgresqlName: String

    init() async throws {

        // Random ports and name.
        vaporPort = Int.random(in: 1024...65_535)
        pgsqlPort = Int.random(in: 1024...65_535)
        postgresqlName = "postgresql-test-\(pgsqlPort)"
    }

    func dockerStart() async throws {

        // Start a docker container running a postgresql instance.
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/local/bin/docker")
        process.arguments = [
            "run", "--rm", "--detach",
            "--name", postgresqlName,
            "--hostname", postgresqlName,
            "--env", "POSTGRES_PASSWORD=mysecretpassword",
            "--publish", "\(pgsqlPort):5432",
            "postgres:17.5-bookworm"
        ]
        try process.run()
        process.waitUntilExit()

        // Wait for the PostgreSQL Docker container to become ready.
        let maxAttempts = 15
        let delay: UInt64 = 500_000_000 // 0.5 seconds
        for _ in 0..<maxAttempts {
            let checkProcess = Process()
            checkProcess.executableURL = URL(fileURLWithPath: "/usr/local/bin/docker")
            checkProcess.arguments = [
                "exec", postgresqlName,
                "pg_isready",
                "-U", "postgres"
            ]
            let pipe = Pipe()
            checkProcess.standardOutput = pipe
            try checkProcess.run()
            checkProcess.waitUntilExit()
            let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: outputData, encoding: .utf8), output.contains("accepting connections") {
                break
            }
            try await Task.sleep(nanoseconds: delay)
        }
    }

    func dockerStop() async throws {

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/local/bin/docker")
        process.arguments = [
            "container", "stop", postgresqlName
        ]
        try process.run()
        process.waitUntilExit()
    }

    @Test("Send POST to customer (with json) should return this new customer")
    func sendPostToCustomerWithJsonShouldReturnThisNewCustomer() async throws {

        // Start docker instance.
        try await dockerStart()

        try await withApp(
            configure: { app in
                try await configureWithFluent(app, self.vaporPort, self.pgsqlHost, self.pgsqlPort)}, { app in

            // Arrange.
            let kernelService: any IKernelService = app.kernelService
            try await kernelService.addCustomer(Customer("my-id", "my-secret"))
            try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
            let expectedStatus: HTTPResponseStatus = .ok
            let expected: Customer = Customer("my-id-3", "my-secret-3")
            let json: Data = try JSONEncoder().encode(Customer(expected.id, expected.secret))

            // Act.
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
                }
            )
        })

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("Send POST to customer should return one more customer")
    func sendPostToCustomerShouldReturnOneMoreCustomer() async throws {

        // Start docker instance.
        try await dockerStart()

        try await withApp(
            configure: { app in
                try await configureWithFluent(app, self.vaporPort, self.pgsqlHost, self.pgsqlPort)}, { app in

            // Arrange.
            let kernelService: any IKernelService = app.kernelService
            try await kernelService.addCustomer(Customer("my-id", "my-secret"))
            try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
            let numberOfCustomersBefore: Int = try await kernelService.getCustomers().count
            let expectedStatus: HTTPResponseStatus = .ok
            let expectedNumberOfCustomersAfter: Int = numberOfCustomersBefore + 1

            // Act.
            try await app.testing().test(.POST, "customer/auto", afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let actualNumberOfCustomersAfter: Int = try await kernelService.getCustomers().count

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualNumberOfCustomersAfter == expectedNumberOfCustomersAfter)
            })
        })

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("Send Get To Customer With 'my-id-not-found' Parameter Should Return 404")
    func sendGetToCustomerWithUnknowIdShouldReturn404() async throws {

        // Start docker instance.
        try await dockerStart()

        try await withApp(
            configure: { app in
                try await configureWithFluent(app, self.vaporPort, self.pgsqlHost, self.pgsqlPort)}, { app in

            // Arrange.
            let kernelService: any IKernelService = app.kernelService
            try await kernelService.addCustomer(Customer("my-id", "my-secret"))
            try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
            let expectedStatus: HTTPResponseStatus = .notFound

            // Act.
            try await app.testing().test(.GET, "customer/my-id-not-found", afterResponse: { response async in

                let actualStatus: HTTPResponseStatus = response.status

                // Assert.
                #expect(actualStatus == expectedStatus)
            })
        })

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("Send Get To Customer With 'my-id' Parameter Should Return That Customer")
    func sendGetToCustomerWithMyIdParameterShouldReturnThatCustomer() async throws {

        // Start docker instance.
        try await dockerStart()

        try await withApp(
            configure: { app in
                try await configureWithFluent(app, self.vaporPort, self.pgsqlHost, self.pgsqlPort)}, { app in

            // Arrange
            let kernelService: any IKernelService = app.kernelService
            try await kernelService.addCustomer(Customer("my-id", "my-secret"))
            try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
            let expectedStatus: HTTPResponseStatus = .ok
            let expectedContent: Customer = Customer("my-id", "my-secret")

            // Act.
            try await app.testing().test(.GET, "customer/my-id", afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let json: String = response.body.string
                let jsonData: Data? = json.data(using: .utf8)
                let actualContent: Customer? = try JSONDecoder().decode(Customer.self, from: jsonData!)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        })

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("Send Get To Customer With 'my-id-2' Parameter Should Return That Customer")
    func sendGetToCustomerWithMyId2ParameterShouldReturnThatCustomer() async throws {

        // Start docker instance.
        try await dockerStart()

        try await withApp(
            configure: { app in
                try await configureWithFluent(app, self.vaporPort, self.pgsqlHost, self.pgsqlPort)}, { app in

            // Arrange.
            let kernelService: any IKernelService = app.kernelService
            try await kernelService.addCustomer(Customer("my-id", "my-secret"))
            try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
            let expectedStatus: HTTPResponseStatus = .ok
            let expectedContent: Customer = Customer("my-id-2", "my-secret-2")

            // Act.
            try await app.testing().test(.GET, "customer/my-id-2", afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let json: String = response.body.string
                let jsonData: Data? = json.data(using: .utf8)
                let actualContent: Customer? = try JSONDecoder().decode(Customer.self, from: jsonData!)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        })

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("Send Get To Customer Without Any Parameter Should Return Those Customers")
    func sendGetToCustomerWithoutAnyParameterShouldReturnThoseCustomers() async throws {

        // Start docker instance.
        try await dockerStart()

        try await withApp(
            configure: { app in
                try await configureWithFluent(app, self.vaporPort, self.pgsqlHost, self.pgsqlPort)}, { app in

            // Arrange.
            let kernelService: any IKernelService = app.kernelService
            try await kernelService.addCustomer(Customer("my-id", "my-secret"))
            try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
            let expectedStatus: HTTPResponseStatus = .ok
            let expectedContent: [Customer] = [
                Customer("my-id", "my-secret"),
                Customer("my-id-2", "my-secret-2")
            ]

            // Act.
            try await app.testing().test(.GET, "customer", afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let json: String = response.body.string
                let jsonData: Data? = json.data(using: .utf8)
                let actualContent: [Customer]? = try JSONDecoder().decode(
                    [Customer].self, from: jsonData!)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        })

        // Stop docker instance.
        try await dockerStop()
    }

    @Test("Create a default app then send Get To Customer Without Any Parameter Should Return Those Customers")
    func createDefaultThenSendGetToCustomerWithoutAnyParameterShouldReturnThoseCustomers() async throws {

        // Override random ports.
        self.vaporPort = 50_000
        self.pgsqlPort = 5_432

        // Start docker instance.
        try await dockerStart()

        try await withApp(
            configure: { app in
                try await configureWithFluent(app, nil, nil, nil)}, { app in

            // Arrange.
            let kernelService: any IKernelService = app.kernelService
            try await kernelService.addCustomer(Customer("my-id", "my-secret"))
            try await kernelService.addCustomer(Customer("my-id-2", "my-secret-2"))
            let expectedStatus: HTTPResponseStatus = .ok
            let expectedContent: [Customer] = [
                Customer("my-id", "my-secret"),
                Customer("my-id-2", "my-secret-2")
            ]

            // Act.
            try await app.testing().test(.GET, "customer", afterResponse: { response async throws in

                let actualStatus: HTTPResponseStatus = response.status
                let json: String = response.body.string
                let jsonData: Data? = json.data(using: .utf8)
                let actualContent: [Customer]? = try JSONDecoder().decode(
                    [Customer].self, from: jsonData!)

                // Assert.
                #expect(actualStatus == expectedStatus)
                #expect(actualContent == expectedContent)
            })
        })

        // Stop docker instance.
        try await dockerStop()
    }
}
