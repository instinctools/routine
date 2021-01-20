import SwiftUI
import RoutineShared

struct TaskView: View {
    
    let task: TodoListUiModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(task.todo.title)
                .font(.headline)
            Spacer()
            HStack {
                Text(task.todo.periodFriendlyTitle())
                Spacer()
                Text(task.daysLeftTitle())
            }
            .font(.caption)
        }
        .padding(12)
        .background(Color(red: task.color.redD, green: task.color.greenD, blue: task.color.blueD))
        .cornerRadius(12)
        .foregroundColor(.white)
    }
}
struct TaskView_Previews: PreviewProvider {

    static var previews: some View {
        let mockedTask = TodoListUiModel.Companion().MOCK.get(index: 0)!
        TaskView(task: mockedTask)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
