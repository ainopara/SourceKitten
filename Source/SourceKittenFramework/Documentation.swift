//
//  Documentation.swift
//  SourceKitten
//
//  Created by JP Simard on 10/27/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

#if !os(Linux)

#if SWIFT_PACKAGE
import Clang_C
#endif

public struct Documentation {
    public let abstract: [Text]
    public let warning: [Text]
    public let discussion: [Text]
    public let seeAlso: [Text]
    public let parameters: [Parameter]
    public let returnDiscussion: [Text]

    init(comment: CXComment) {
        let comments = (0..<comment.count()).map { comment[$0] }

        abstract = comments.filter {
            !($0.kind() == CXComment_ParamCommand) &&
            !($0.kind() == CXComment_BlockCommand && $0.commandName() == "warning") &&
            !($0.kind() == CXComment_BlockCommand && $0.commandName() == "discussion") &&
            !($0.kind() == CXComment_BlockCommand && $0.commandName() == "see") &&
            !($0.kind() == CXComment_BlockCommand && $0.commandName() == "return")
        }.flatMap {
            $0.paragraphToString()
        }

        warning = comments.filter {
            $0.kind() == CXComment_BlockCommand && $0.commandName() == "warning"
        }.flatMap {
            $0.paragraphToString()
        }

        discussion = comments.filter {
            $0.kind() == CXComment_BlockCommand && $0.commandName() == "discussion"
        }.flatMap {
            $0.paragraphToString()
        }

        seeAlso = comments.filter {
            $0.kind() == CXComment_BlockCommand && $0.commandName() == "see"
        }.flatMap {
            $0.paragraphToString()
        }

        parameters = comments.filter {
            $0.kind() == CXComment_ParamCommand
        }.map(Parameter.init)

        returnDiscussion = comments.filter {
            $0.kind() == CXComment_BlockCommand && $0.commandName() == "return"
        }.flatMap {
            $0.paragraphToString()
        }
    }
}

#endif
