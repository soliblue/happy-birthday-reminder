import SwiftUI

struct HumanListView: View {
    @State private var collapsedMonths = Set<String>()
    @ObservedObject var viewModel = HumanListViewModel()
    @State private var isSearchBarExpanded = false  // Flag to check if the search bar should be expanded
    private let backgroundColor = LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment:.bottomTrailing){
//                VStack{
//                    if isSearchBarExpanded {
//                        TextField("Search", text: $viewModel.searchText)
//                            .padding(8)
//                            .background(Color.white.opacity(0.2))
//                            .cornerRadius(15)
//                            .transition(.move(edge: .trailing).combined(with: .opacity))
//                            .animation(.spring(response: 0.4, dampingFraction: 0.7))
//                            .padding(.leading)
//                    }
//
//
//                    Button(action: {
//                        withAnimation {
//                            isSearchBarExpanded.toggle()
//                        }
//                    }) {
//                        Image(systemName: isSearchBarExpanded ? "xmark.circle.fill" : "magnifyingglass")
//                            .foregroundColor(.white)
//                            .padding(.horizontal)
//                    }
//
//                    Button(action: {
//                        scrollToCurrentMonth(using: proxy)
//                    }) {
//                        Image(systemName: "gift.fill")
//                            .foregroundColor(.white)
//                    }
//
//                }.background(backgroundColor)
//                    .zIndex(1)
                
                List{
                    ForEach(Array(viewModel.monthSections.keys).sorted(), id: \.self) { monthInfo in
                        Section(
                            header: HStack {
                                Text(monthInfo.name).font(.headline).id(monthInfo.name)
                                Spacer()
                                if collapsedMonths.contains(monthInfo.name) {
                                    Text("\(viewModel.monthSections[monthInfo]?.count ?? 0)")
                                }
                            }.contentShape(Rectangle())  // Makes the entire HStack tappable
                                .onTapGesture {
                                    if collapsedMonths.contains(monthInfo.name) {
                                        collapsedMonths.remove(monthInfo.name)
                                    } else {
                                        collapsedMonths.insert(monthInfo.name)
                                    }
                                }
                        ) {
                            if !collapsedMonths.contains(monthInfo.name) {
                                ForEach(viewModel.monthSections[monthInfo]!, id: \.id) { human in
                                    HumanCardView(human: human)
                                }
                            }
                        }
                        .id(monthInfo.name)
                    }
                }
                .animation(.easeInOut(duration: 1.0), value: collapsedMonths)
                .refreshable {
                    viewModel.fetchHumans()
                }
                .onAppear {
                    viewModel.fetchHumans()
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
}
