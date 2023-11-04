import SwiftUI

struct ListContacts: View {
    @State private var collapsedMonths = Set<String>()
    @ObservedObject var viewModel = ContactViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.accessDenied {
                AllowContactsAccess()
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
                                        ContactCard(contact: contact, viewModel: viewModel)
                                    }
                                    
                                }
                            }
                            .id(monthInfo.name)
                        }
                    }
                    .padding(.top,1)
                    .listStyle(PlainListStyle())
                    .animation(.easeInOut(duration: 1.0), value: collapsedMonths)
                    .refreshable {
                        viewModel.fetchContacts()
                    }
                    
                }
            }
        }
    }
}
