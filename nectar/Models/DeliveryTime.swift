import Foundation

struct DeliveryTimeSlot: Identifiable, Equatable {
    let id = UUID()
    let time: Date
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: time)
    }
    
    var formattedDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: time)
    }
} 