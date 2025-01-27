// swiftc main.swift ../generated/SwiftBridgeCore.swift ../generated/LX-rs/LX-rs.swift -import-objc-header ../bridging-header.h -L ../target/debug -lcorpus

import Foundation

let content: RustString = fetch_from_corpus("labgg.pl")
let contentStr = content.toString()
print(" \(contentStr))")
