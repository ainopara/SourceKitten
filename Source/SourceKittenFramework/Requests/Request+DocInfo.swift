//
//  Request+DocInfo.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE
import SourceKit
#endif

// swiftlint:disable nesting
extension Request {
    /// A documentation request for the given source text.
    /// Or a documentation request for the given module.
    public struct DocInfo: RequestType {
        public struct Source {
            public let sourceFile: String?
            public let sourceText: String?
            public let moduleName: String?

            public static func file(_ sourceFile: String) -> Source {
                return Source(sourceFile: sourceFile, sourceText: nil, moduleName: nil)
            }

            public static func text(_ sourceText: String, name: String? = nil) -> Source {
                return Source(sourceFile: name, sourceText: sourceText, moduleName: nil)
            }

            public static func module(name moduleName: String) -> Source {
                return Source(sourceFile: nil, sourceText: nil, moduleName: moduleName)
            }
        }
        public let source: Source
        public let arguments: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .docInfo)
            requestBuilder[.sourceFile] = source.sourceFile
            requestBuilder[.sourceText] = source.sourceText
            requestBuilder[.moduleName] = source.moduleName
            requestBuilder[.compilerArgs] = arguments

            return requestBuilder.makeRequest()
        }
    }

    public static func docInfo(text: String, arguments: [String]) -> Request {
        return Request(type: DocInfo(source: .text(text), arguments: arguments))
    }

    public static func moduleInfo(module: String, arguments: [String]) -> Request {
        return Request(type: DocInfo(source: .module(name: module), arguments: arguments))
    }

    public static func docInfo(source: DocInfo.Source, arguments: [String]) -> Request {
        return Request(type: DocInfo(source: source, arguments: arguments))
    }
}
