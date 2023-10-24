import SwiftUI

struct HumanListView: View {
    @ObservedObject var viewModel = HumanListViewModel()
    
    var body: some View {
        List {
            ForEach(Array(viewModel.monthSections.keys).sorted(), id: \.self) { monthInfo in
                Section(header: Text(monthInfo.name).font(.headline)) {
                    ForEach(viewModel.monthSections[monthInfo]!, id: \.id) { human in
                        NavigationLink(destination: HumanDetailView(human: human)) {
                            HStack {
                                AvatarView(imageData: human.imageData, size: 50)
                                VStack(alignment: .leading) {
                                    Text(human.nickname ?? human.name)
                                    Text(human.nextBirthday.relativeString)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: viewModel.fetchHumans)
    }
}

