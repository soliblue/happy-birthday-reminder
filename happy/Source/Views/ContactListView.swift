import SwiftUI

struct ContactListView: View {
    @State private var collapsedMonths = Set<String>()
    @ObservedObject var viewModel = ContactViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.accessDenied {
                // This is your special view for an empty list
                VStack(spacing:25) {
                    VStack(spacing: 5){
                        Image(systemName: "person.crop.circle.badge.xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text("No Contacts Found").font(.headline)
                        Text("Please allow access to your contacts").font(.subheadline)
                    }
                    
                    
                    VStack(spacing:5){
                        Button("Enable Access") {
                            if let url = URL(string: UIApplication.openSettingsURLString),
                               UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                        
                        Text("Your data remains on this device.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                }
                
                
            } else {
                let currentMonth = Calendar.current.component(.month, from: Date())
                let sortedKeys = Array(viewModel.monthSections.keys).sorted {
                    let diff1 = ($0.number - currentMonth + 12) % 12
                    let diff2 = ($1.number - currentMonth + 12) % 12
                    return diff1 < diff2
                }
                ScrollViewReader { proxy in
                    List{
                        ForEach(sortedKeys, id: \.self) { monthInfo in
                            Section(
                                header: HStack {
                                    Text(monthInfo.name).font(.title3).id(monthInfo.name)
                                    Spacer()
                                    if collapsedMonths.contains(monthInfo.name) {
                                        Text("\(viewModel.monthSections[monthInfo]?.count ?? 0)")
                                    }
                                }.contentShape(Rectangle())
                                    .onTapGesture {
                                        if collapsedMonths.contains(monthInfo.name) {
                                            collapsedMonths.remove(monthInfo.name)
                                        } else {
                                            collapsedMonths.insert(monthInfo.name)
                                        }
                                    }
                            ) {
                                if !collapsedMonths.contains(monthInfo.name) {
                                    ForEach(viewModel.monthSections[monthInfo] ?? [], id: \.self) { contact in
                                        ContactListCardView(contact: contact, viewModel: viewModel)
                                    }
                                    
                                }
                            }
                            .id(monthInfo.name)
                        }
                    }
                    .animation(.easeInOut(duration: 1.0), value: collapsedMonths)
                    .refreshable {
                        viewModel.fetchContacts()
                    }
                    
                }
            }
        }
    }
}

private func scrollToCurrentMonth(using proxy: ScrollViewProxy) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    let currentMonth = dateFormatter.string(from: Date())
    
    withAnimation {
        proxy.scrollTo(currentMonth, anchor: .top)
    }
}



