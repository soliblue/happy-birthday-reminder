import SwiftUI

struct ContactListView: View {
    @State private var collapsedMonths = Set<String>()
    @ObservedObject var viewModel = ContactViewModel()
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                List{
                    ForEach(Array(viewModel.monthSections.keys).sorted(), id: \.self) { monthInfo in
                        Section(
                            header: HStack {
                                Text(monthInfo.name).font(.headline).id(monthInfo.name)
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
                                    ContactListCardView(contact: contact)
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
                .onChange(of: viewModel.monthSections) { _ in
                    scrollToCurrentMonth(using: proxy)
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
    }}



