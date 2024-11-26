import ActKit
import CxxStdlib
import Foundation
import LogicKitC

public final class LogicVM: Sendable {
    let prologVM: looe.LogicKit.PrologVM

    public init() {
        let argv0 = CommandLine.arguments[0]
        prologVM = looe.LogicKit.PrologVM(std.string(argv0))
    }

    public func process(query: String) -> String {
        return "Hi"
    }
}
