// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Vapor
import VividCommon

/// A representation of a customer.
struct CustomerContent: Content {

    /// Unique identifier of the customer.
    public let id: String

    /// Secret of the customer.
    public let secret: String
}
