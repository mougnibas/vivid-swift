// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Fluent

/// Fluent Migration #001.
public struct Migration001: AsyncMigration {

    public init() {}

    public func prepare(on database: Database) async throws {
        try await database.schema(CustomerModel.schema)
            .field("id", .string, .identifier(auto: false))
            .field("secret", .string)
            .create()
    }

    public func revert(on database: Database) async throws {
        try await database.schema(CustomerModel.schema).delete()
    }
}
