import SwiftUI
import AVKit

struct ShowWidgetAlertSheetModifier: ViewModifier {
    @AppStorage("isWidgetAlertPermanentlyDismissed") private var isWidgetAlertPermanentlyDismissed = false
    @State private var isWidgetAlertPresented = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {isWidgetAlertPresented = !isWidgetAlertPermanentlyDismissed}
            .sheet(isPresented: $isWidgetAlertPresented) {
                ScrollView{
                    VStack(alignment: .center,spacing: 25){
                        Text("Add Widget to Home Screen")
                            .font(.headline)
                        Image("WidgetPreview")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                        Text("Follow the steps below to add our widget to your home screen")
                            .font(.subheadline)
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(zip(1..., [
                                "From the Home Screen, touch and hold a widget or an empty area until the apps jiggle.",
                                "Tap the Add button in the top-left corner.",
                                "Search for 'happy', select our widget, then tap 'Add Widget'."
                            ])), id: \.1) { (number, step) in
                                HStack(alignment: .top){
                                    Text("\(number).")
                                        .fontWeight(.semibold)
                                    Text(step)
                                }
                            }.font(.subheadline)
                        }
                        Divider()
                        VStack(spacing: 15) {
                            Button("Remind me later", action: { isWidgetAlertPresented = false })
                                .buttonStyle(.bordered)
                                .tint(Color.accentColor)
                            Button("Do not show again", action: {
                                isWidgetAlertPermanentlyDismissed = true
                                isWidgetAlertPresented = false
                            })
                            .foregroundColor(.red)
                            .font(.caption)
                        }
                    }
                }.padding()
            }
    }
}

extension View {
    func showWidgetAlertSheet() -> some View {
        self.modifier(ShowWidgetAlertSheetModifier())
    }
}
