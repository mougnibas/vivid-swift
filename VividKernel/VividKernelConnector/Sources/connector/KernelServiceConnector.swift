// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import VividKernelContract

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

        let customerDTO: CustomerDTO = CustomerDTO(id: customer.id, secret: customer.secret)
        let jsonData: Data = try JSONEncoder().encode(customerDTO)

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
        let customerDTO: CustomerDTO = try JSONDecoder().decode(CustomerDTO.self, from: json)

        // Convert the DTO back to it's original form.
        let customer: Customer = Customer(customerDTO.id, customerDTO.secret)

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
        let customerDTO: CustomerDTO = try JSONDecoder().decode(CustomerDTO.self, from: json)

        // Convert the DTO back to it's original form.
        let customer: Customer = Customer(customerDTO.id, customerDTO.secret)

        // Return the result.
        return customer
    }

    public func getCustomers() async throws -> [Customer] {

        let url: URL = URL(string: baseAddress + ":" + String(port) + "/customer/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        let json: Data = String(data: data, encoding: .utf8)!.data(using: .utf8)!
        let customerDTOs: [CustomerDTO] = try JSONDecoder().decode([CustomerDTO].self, from: json)

        // Convert the DTOs back to it's original form.
        // Put the customers in Vapor Model.
        var customers: [Customer] = []
        for customerDTO: CustomerDTO in customerDTOs {
            customers.append(Customer(customerDTO.id, customerDTO.secret))
        }

        // Return the result.
        return customers
    }
}
