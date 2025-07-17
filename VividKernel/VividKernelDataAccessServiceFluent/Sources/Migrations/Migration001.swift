// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Fluent

/// Fluent Migration #001.
struct Migration001: AsyncMigration {

    func prepare(on database: Database) async throws {
        try await database.schema(CustomerModel.schema)
            .id()
            .field("name", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(CustomerModel.schema).delete()
    }
}
