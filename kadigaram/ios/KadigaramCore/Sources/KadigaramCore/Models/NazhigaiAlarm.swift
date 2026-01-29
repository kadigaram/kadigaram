import Foundation

public struct NazhigaiAlarm: Codable, Identifiable, Equatable, Sendable {
    public let id: UUID
    public var nazhigai: Int
    public var vinazhigai: Int
    public var label: String
    public var isEnabled: Bool
    public var addToSystemClock: Bool  // iOS 26+ AlarmKit integration
    public var systemAlarmId: String?  // Tracks the Clock app alarm ID
    
    public init(id: UUID = UUID(), nazhigai: Int = 0, vinazhigai: Int = 0, label: String = "", isEnabled: Bool = true, addToSystemClock: Bool = false, systemAlarmId: String? = nil) {
        self.id = id
        self.nazhigai = nazhigai
        self.vinazhigai = vinazhigai
        self.label = label
        self.isEnabled = isEnabled
        self.addToSystemClock = addToSystemClock
        self.systemAlarmId = systemAlarmId
    }
}
