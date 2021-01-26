import SwiftUI
import RoutineShared

struct TaskDetailsView: View {
    
    let cancelAction: () -> Void
    let savedAction: () -> Void
    let presenter: TodoDetailsPresenter
    
    @State var state: TodoDetailsPresenter.State
    @State private var selectionStrategy = PeriodResetStrategy.fromnow
    
    init(
        presenter: TodoDetailsPresenter,
        cancelAction: @escaping () -> Void,
        savedAction: @escaping () -> Void
    ) {
        self.presenter = presenter
        self.cancelAction = cancelAction
        self.savedAction = savedAction
        let value = presenter.states.value as! TodoDetailsPresenter.State
        _state = State<TodoDetailsPresenter.State>.init(initialValue: value)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if(state.progress) {
                    ProgressView()
                        .padding()
                }
                PlaceholderTextField(
                    placeholder: Text("Type recurring task name…")
                        .foregroundColor(Color(red: 0.678, green: 0.682, blue: 0.686)),
                    text: self.state.todo.title ?? ""
                )
                .font(.title)
                
                Picker(selection: $selectionStrategy, label: Text("Reset strategy")) {
                    Text("Reset to period").tag(PeriodResetStrategy.fromnow)
                    Text("Reset to date").tag(PeriodResetStrategy.fromnextevent)
                }.pickerStyle(SegmentedPickerStyle())
                
                LabelledDivider(label: "Repeat every", color: Color(red: 0.667, green: 0.663, blue: 0.663))
                ForEach(state.periods, id: \.unit) { period in
                    PeriodItemView(period: period, selected: period.unit == state.todo.periodUnit)
                        .onTapGesture {
                            let action = TodoDetailsPresenter.ActionChangePeriodUnit(periodUnit: period.unit)
                            presenter.sendAction(action: action)
                        }
                }
            }
        }
        .padding(.horizontal, 16)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: self.cancelAction) { Text("Cancel") }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) { Text("Done") }
            }
        }
        .disabled(state.progress)
        .progressViewStyle(CircularProgressViewStyle())
        .attachPresenter(presenter: presenter, bindedState: $state)
        
        .onChange(of: selectionStrategy, perform: { value in
            let action = TodoDetailsPresenter.ActionChangePeriodStrategy(periodStrategy: value)
            presenter.sendAction(action: action)
        })
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = Injector().makeTodoDetailsPresenter(todoId: nil)
        TaskDetailsView(
            presenter: presenter,
            cancelAction: {},
            savedAction: {}
        )
    }
}
