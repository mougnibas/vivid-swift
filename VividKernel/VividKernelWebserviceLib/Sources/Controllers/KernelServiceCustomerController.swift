// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Vapor
import VividKernelService
import VividKernelImpl

/// Kernel service about customers as a Vapor Controller.
public struct KernelServiceCustomerController: RouteCollection, Sendable {

    // Service to use.
    let service: any IKernelService

    public init(service: any IKernelService) {
        self.service = service
    }

    public func boot(routes: any RoutesBuilder) throws {

        // Route POST "/customer" with customer json : Create that new customer.
        routes.post("customer", use: postCustomerWithJson)

        // Route POST "/customer/auto" : Create a new customer, then return it.
        routes.post("customer", "auto", use: postCustomer)

        // Route GET "/customer/{id}" : Return the given customer, if any (404 otherwise).
        routes.get("customer", ":id", use: getCustomer)

        // Route GET "/customer" : Return all customers.
        routes.get("customer", use: getAllCustomers)
    }

    func postCustomerWithJson(req: Request) async throws -> HTTPStatus {

        // Decode the json to get back the customer to create.
        let customerDTO: CustomerDTO = try req.content.decode(CustomerDTO.self)

        // Convert the DTO back to it's original form.
        let customer: Customer = Customer(customerDTO.id, customerDTO.secret)

        // Add it.
        try await service.addCustomer(customer)

        // Return http status
        return .ok
    }

    func postCustomer(req: Request) async throws -> CustomerDTO {

        // Create the customer
        let newCustomer: Customer = try await service.createNewCustomer()

        // Put the customer in Vapor Model.
        let customerDTO: CustomerDTO = CustomerDTO(id: newCustomer.id, secret: newCustomer.secret)

        // Return the customer (Vapor Model).
        return customerDTO
    }

    func getCustomer(req: Request) async throws -> CustomerDTO {

        // Get the customer ID from paramters.
        let customerId: String = req.parameters.get("id")!

        // Get this customer, if any.
        let customer: Customer? = try await service.getCustomer(customerId)

        // Handle customer not found.
        guard customer != nil else {
            throw Abort(.notFound)
        }

        // Put the customer in Vapor Model.
        let customerDTO: CustomerDTO = CustomerDTO(id: customer!.id, secret: customer!.secret)

        // Return the customer (Vapor Model).
        return customerDTO
    }

    func getAllCustomers(req: Request) async throws -> [CustomerDTO] {

        // Get all customers.
        let customers: [Customer] = try await service.getCustomers()

        // Put the customers in Vapor Model.
        var customerDTOs: [CustomerDTO] = []
        for customer: Customer in customers {
            customerDTOs.append(CustomerDTO(id: customer.id, secret: customer.secret))
        }

        // Return the customers (Vapor Model).
        return customerDTOs
    }
}
