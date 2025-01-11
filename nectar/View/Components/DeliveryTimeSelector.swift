import SwiftUI

struct DeliveryTimeSelector: View {
    @Binding var selectedTime: DeliveryTimeSlot?
    let availableTimes: [DeliveryTimeSlot]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(availableTimes) { time in
                    TimeSlotButton(
                        time: time,
                        isSelected: selectedTime == time,
                        action: { selectedTime = time }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct TimeSlotButton: View {
    let time: DeliveryTimeSlot
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(time.formattedDay)
                    .font(.custom("Gilroy-Medium", size: 14))
                Text(time.formattedTime)
                    .font(.custom("Gilroy-SemiBold", size: 16))
            }
            .padding()
            .background(isSelected ? Color.green : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(10)
        }
    }
} 