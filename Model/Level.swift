import Foundation
import SwiftUI
// Modelo Level
struct Levelq: Identifiable, Hashable {
    let id = UUID()
    let number: Int
    let command: String
}

struct Commandw: Identifiable, Hashable {
    let id = UUID()
    let commandtype: String
}
