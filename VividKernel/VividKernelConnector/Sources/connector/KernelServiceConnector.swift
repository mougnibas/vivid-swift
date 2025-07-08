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

    public func addCustomer(_ customer: Customer) async {

        do {

            let customerDTO: CustomerDTO = CustomerDTO(id: customer.id, secret: customer.secret)
            let jsonData: Data = try JSONEncoder().encode(customerDTO)

            let url = URL(string: "http://localhost:8080/customer/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            _ = try await URLSession.shared.data(for: request)
        } catch {}
    }

    public func createNewCustomer() async -> Customer {

        do {

            let url = URL(string: "http://localhost:8080/customer/auto")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let (data, _) = try await URLSession.shared.data(for: request)

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

            let (data, _) = try await URLSession.shared.data(for: request)

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

    public func getCustomers() async -> [Customer] {
        do {

            let url = URL(string: "http://localhost:8080/customer/")!
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

        } catch {
            return []
        }
    }
}
