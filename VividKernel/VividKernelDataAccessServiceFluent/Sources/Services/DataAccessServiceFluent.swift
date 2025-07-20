// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Fluent
import VividKernelService
import VividKernelDataAccessService

/// Fluent data access service implementation..
public actor DataAccessServiceFluent: IDataAccessService {

    /// Fluet database for persistence.
    var database: Database

    /// Initialize the service.
    /// - Parameter database : Fluent Database.
    public init ( _ database: Database) {
        self.database = database
    }

    public func addCustomer(_ customer: Customer) async throws {

        // Create a CustomerModel from Customer.
        let model: CustomerModel = CustomerModel(customer.id, customer.secret)

        // Save a new model to the databse.
        _ = try await model.create(on: database)
    }

    public func getCustomer( _ id: String) async throws -> Customer? {

        // Try to find the customer.
        let model: CustomerModel? = try await CustomerModel.find(id, on: database)

        // If the customer is not found, return nil.
        guard model != nil else {
            return nil
        }
        let foundedModel: CustomerModel = model!

        // Create a customer from CustomerModel.
        let customer: Customer = Customer(foundedModel.id!, foundedModel.secret)

        // Customer if found. Return it.
        return customer
    }

    public func getCustomers() async throws -> [Customer] {

        // Get the customer models.
        let models: [CustomerModel] = try await CustomerModel.query(on: database).all()

        // Create the customers.
        var customers: [Customer] = []
        for model: CustomerModel in models {
            let customer: Customer = Customer(model.id!, model.secret)
            customers.append(customer)
        }

        // Sort the customers, to retrieve them always in the same order.
        customers.sort { $0.id < $1.id }

        // Return the result.
        return customers
    }
}
