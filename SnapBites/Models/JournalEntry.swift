import Foundation

enum LogTimeframe: String, CaseIterable, Identifiable {
    case morning = "Morning"
    case noon = "Noon"
    case evening = "Evening"

    var id: String { rawValue }

    var startHour: Int {
        switch self {
        case .morning: return 5
        case .noon: return 12
        case .evening: return 17
        }
    }
}

struct JournalEntry: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let subtitle: String
    let isSymptom: Bool
    let hour: Int // 24h hour used to bucket into a LogTimeframe

    var timeframe: LogTimeframe {
        switch hour {
        case ..<LogTimeframe.noon.startHour:
            return .morning
        case ..<LogTimeframe.evening.startHour:
            return .noon
        default:
            return .evening
        }
    }
}
