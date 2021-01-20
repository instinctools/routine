import Foundation
import SwiftUI
import RoutineShared


extension View {
    func attachPresenter<Action, State>(presenter: Store<Action, State>, bindedState: Binding<State>) -> some View {
        let uiBinder = UiBinder<Action, State>()
        return self
            .onAppear {
                print("asd_asd: bind presenter \(presenter)")
                uiBinder.bindTo(presenter: presenter, listener: {state in
                    bindedState.wrappedValue = state
                })
            }
            .onDisappear {
                print("asd_asd: unbind presenter \(presenter)")
                uiBinder.destroy()
            }
    }
}
