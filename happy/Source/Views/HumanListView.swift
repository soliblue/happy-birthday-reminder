import SwiftUI

struct HumanListView: View {
    @ObservedObject var viewModel = HumanListViewModel()
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack {
                List {
                    ForEach(Array(viewModel.monthSections.keys).sorted(), id: \.self) { monthInfo in
                        Section(header: Text(monthInfo.name).font(.headline).id(monthInfo.name)) {
                            ForEach(viewModel.monthSections[monthInfo]!, id: \.id) { human in
                                HumanCardView(human: human)
                            }
                        }
                        .id(monthInfo.name)
                    }
                }
                .refreshable {
                    viewModel.fetchHumans()
                }
                .onAppear {
                    viewModel.fetchHumans()
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
    }
}
