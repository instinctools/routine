import SwiftUI
import RoutineShared

struct TodoRowView: View {

    var uiModel: TodoListUiModel

    var body: some View {
        VStack {
            HStack {
                Text(uiModel.todo.title)
                        .font(Font.system(size: 19, weight: .semibold))
                        .foregroundColor(Color.white)
                Spacer()
            }
                    .padding(.bottom, 8)

            HStack {
//                Text(viewModel.period)
                Text("Weekly")
                        .font(Font.system(size: 14, weight: .medium))
                        .foregroundColor(Color.white)
                Spacer()
//                Text(viewModel.timeLeft)
                Text("4 days")
                        .font(Font.system(size: 14, weight: .medium))
                        .foregroundColor(Color.white)
            }
        }
                .padding(.all, 14)
                .background(SwiftUI.Color(red: uiModel.color.redD, green: uiModel.color.greenD, blue: uiModel.color.blueD))
                .cornerRadius(12)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
    }
}

//struct TaskRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskRowView(viewModel: .init(task: .mock, color: .red))
//    }
//}
