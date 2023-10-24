import SwiftUI

struct TimeView: View {
    let title: String
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    
    var body: some View {
        VStack(spacing: 25) {
            
            HStack(spacing: 25) {
                VStack {
                    Text("\(days)")
                        .fontWeight(.bold)
                    Text("Days")
                        .font(.subheadline)
                }
                VStack {
                    Text("\(hours)")
                        .fontWeight(.bold)
                    Text("Hours")
                        .font(.subheadline)
                }
            }
            
            HStack(spacing: 25) {
                VStack {
                    Text("\(minutes)")
                        .fontWeight(.bold)
                    Text("Mins")
                        .font(.subheadline)
                }
                VStack {
                    Text("\(seconds)")
                        .fontWeight(.bold)
                    Text("Secs")
                        .font(.subheadline)
                }
            }
            
           
        }
        .padding()
    }
}
