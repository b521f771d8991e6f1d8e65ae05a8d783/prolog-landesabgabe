import ActKit
import CxxStdlib
import Foundation
import LogicKitC

public final class LogicVM: Sendable {
    public init() {
        let argv0 = CommandLine.arguments[0]
        looe.LogicKitC.startPrologVM(std.string(argv0))
    }

    public func process(query: String) -> String? {
        let result = looe.LogicKitC.runQuery(std.string(query))

        if result == "" {
            return String(result)
        } else {
            return Optional.none
        }
    }
}
