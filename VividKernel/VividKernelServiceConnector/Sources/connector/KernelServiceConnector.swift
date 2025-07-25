// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividKernelService

// Swift Foundation on GNU/Linux don't provide networking types.
// This import is mandatory on GNU/Linux systems.
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Connector based implementation of kernel service.
public actor KernelServiceConnector: IKernelService {

    /// Base address to send requests to.
    let baseAddress: String

    /// Port to send requests to.
    let port: Int

    /// Initialize the actor.
    ///
    /// - Parameters :
    ///  - baseAddress : Base address to send requests to.
    ///  - port :Port to send requests to.
    init(_ baseAddress: String, _ port: Int) {
        self.baseAddress = baseAddress
        self.port = port
    }

    public func addCustomer(_ customer: Customer) async throws {

        let customer: Customer = Customer(customer.id, customer.secret)
        let jsonData: Data = try JSONEncoder().encode(customer)

        let url: URL = URL(string: baseAddress + ":" + String(port) + "/customer/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        _ = try await URLSession.shared.data(for: request)
    }

    public func createNewCustomer() async throws -> Customer {

        let url: URL = URL(string: baseAddress + ":" + String(port) + "/customer/auto")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let (data, _) = try await URLSession.shared.data(for: request)

        let json: Data = String(data: data, encoding: .utf8)!.data(using: .utf8)!
        let customer: Customer = try JSONDecoder().decode(Customer.self, from: json)

        // Return the result.
        return customer
    }

    public func getCustomer( _ id: String) async throws -> Customer? {

        let url: URL = URL(string: baseAddress + ":" + String(port) + "/customer/" + id)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else {
                return nil
            }
        }

        let json: Data = String(data: data, encoding: .utf8)!.data(using: .utf8)!
        let customer: Customer = try JSONDecoder().decode(Customer.self, from: json)

        // Return the result.
        return customer
    }

    public func getCustomers() async throws -> [Customer] {

        let url: URL = URL(string: baseAddress + ":" + String(port) + "/customer/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        let json: Data = String(data: data, encoding: .utf8)!.data(using: .utf8)!
        let customers: [Customer] = try JSONDecoder().decode([Customer].self, from: json)

        // Return the result.
        return customers
    }
}
