import CxxStdlib
import Foundation
import LogicKitC

public final class LogicVM: Sendable {
    public init() {
        let argv0 = CommandLine.arguments[0]
        looe.LogicKitC.start_prolog_VM(std.string(argv0))
    }

    public func process(query: String) -> String? {
        // TODO
        let result = "TODO"

        if result == "" {
            return String(result)
        } else {
            return Optional.none
        }
    }
}
