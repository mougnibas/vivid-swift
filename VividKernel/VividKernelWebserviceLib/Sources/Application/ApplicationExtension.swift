// GNU AFFERO GENERAL PUBLIC LICENSE
// Version 3, 19 November 2007
//
// Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
// Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.

import Foundation
import Vapor
import VividKernelService

private struct KernelServiceKey: StorageKey {
    typealias Value = any IKernelService
}

extension Application {

    public var kernelService: any IKernelService {
            get {
                let service = self.storage[KernelServiceKey.self]!
                return service
            }
            set {
                self.storage[KernelServiceKey.self] = newValue
            }
        }
}
