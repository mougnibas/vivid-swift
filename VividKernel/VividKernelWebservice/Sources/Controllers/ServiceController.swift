// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Vapor
import VividCommon
import VividKernelContract
import VividKernelImpl

/// Kernel service as a Vapor Controller.
struct ServiceController: RouteCollection {

    /// Service to use.
    // TODO Bad practice, use inversion of control pattern instead.
    let service: any IKernelService = KernelServiceImpl()

    func boot(routes: any RoutesBuilder) throws {

        // Route POST "/customer" : Create a new customer, then return it.
        routes.post("customer", use: postCustomer)

        // Route GET "/customer/{id}" : Return the given customer, if any (404 otherwise).
        routes.get("customer", ":id", use: getCustomer)

        // Route GET "/customer" : Return all customers.
        routes.get("customer", use: getAllCustomers)
    }

    func postCustomer(req: Request) async throws -> CustomerContent {

        // Create the customer
        let newCustomer: Customer = service.createNewCustomer()

        // Put the customer in Vapor Model.
        let customerContent: CustomerContent = CustomerContent(id: newCustomer.id, secret: newCustomer.secret)

        // Return the customer (Vapor Model).
        return customerContent
    }

    func getCustomer(req: Request) async throws -> CustomerContent {

        // Get the customer ID from paramters.
        let customerId: String = req.parameters.get("id")!

        // Get this customer, if any.
        let customer: Customer? = service.getCustomer(customerId)

        // Handle customer not found.
        guard customer != nil else {
            throw Abort(.notFound)
        }

        // Put the customer in Vapor Model.
        let customerContent: CustomerContent = CustomerContent(id: customer!.id, secret: customer!.secret)

        // Return the customer (Vapor Model).
        return customerContent
    }

    func getAllCustomers(req: Request) async throws -> [CustomerContent] {

        // Get all customers.
        let customers: [Customer] = service.getCustomers()

        // Put the customers in Vapor Model.
        var customerContents: [CustomerContent] = []
        for customer: Customer in customers {
            customerContents.append(CustomerContent(id: customer.id, secret: customer.secret))
        }

        // Return the customers (Vapor Model).
        return customerContents
    }
}
