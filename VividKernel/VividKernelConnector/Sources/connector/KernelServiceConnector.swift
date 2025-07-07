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

    public func addCustomer(_ customer: Customer) {
        // TODO Write this method.
    }

    public func createNewCustomer() async -> Customer {

        do {

            let url = URL(string: "http://localhost:8080/customer/auto")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }

            let json: Data = String(data: data, encoding: .utf8)!.data(using: .utf8)!
            let customerDTO: CustomerDTO = try JSONDecoder().decode(CustomerDTO.self, from: json)

            // Convert the DTO back to it's original form.
            let customer: Customer = Customer(customerDTO.id, customerDTO.secret)

            // Return the result.
            return customer

        } catch {
            // TODO Add exception handling.
            return Customer("todo", "TODO")
        }
    }

    public func getCustomer( _ id: String) async -> Customer? {

        do {

            let url = URL(string: "http://localhost:8080/customer/" + id)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }

            let json: Data = String(data: data, encoding: .utf8)!.data(using: .utf8)!
            let customerDTO: CustomerDTO = try JSONDecoder().decode(CustomerDTO.self, from: json)

            // Convert the DTO back to it's original form.
            let customer: Customer = Customer(customerDTO.id, customerDTO.secret)

            // Return the result.
            return customer

        } catch {
            return nil
        }
    }

    public func getCustomers() -> [Customer] {
        // TODO Write this method.
        return [Customer("todo", "TODO")]
    }
}
