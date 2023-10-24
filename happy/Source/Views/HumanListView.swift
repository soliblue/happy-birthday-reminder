import SwiftUI


struct HumanListView: View {
    @ObservedObject var viewModel = HumanListViewModel()
    
    var body: some View {
        ZStack {
            List {
                ForEach(Array(viewModel.monthSections.keys).sorted(), id: \.self) { monthInfo in
                    Section(header: Text(monthInfo.name).font(.headline)) {
                        ForEach(viewModel.monthSections[monthInfo]!, id: \.id) { human in
                            HumanCardView(human: human)
                        }
                    }
                }
            }
            .onAppear(perform: viewModel.fetchHumans)
        }
    }
}
