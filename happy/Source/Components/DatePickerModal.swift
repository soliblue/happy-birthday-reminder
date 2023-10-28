import SwiftUI

struct DatePickerModal: View {
    @Binding var isShown: Bool
    @Binding var selectedDate: Date
    var onDateChanged: (() -> Void)?

    var body: some View {
        NavigationView {
            VStack {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
            }
            .navigationBarItems(trailing: Button("close") {
                isShown = false
            })
            .onDisappear {
                onDateChanged?()
            }
        }
    }
}
