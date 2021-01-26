import SwiftUI
import RoutineShared

struct SplashView: View {
    
    let presenter: SplashPresenter
    let loginAction: () -> Void
    @State var state: SplashPresenter.State
    
    init(presenter: SplashPresenter, loginAction: @escaping () -> Void) {
        self.presenter = presenter
        self.loginAction = loginAction
        let value = presenter.states.value as! SplashPresenter.State
        _state = State<SplashPresenter.State>.init(initialValue: value)
    }
    
    var body: some View {
        VStack {
            Image("Splash Logo")
            Text("Setting up account")
                .font(.headline)
                .padding(.vertical)
            switch state {
            case is SplashPresenter.StateLoading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            case is SplashPresenter.StateError:
                Button("Retry", action: {})
                    .padding()
                    .foregroundColor(Color.white)
                    .background(UIColor.splashPrimary())
                    .cornerRadius(4)
            default :
                let _ = self.loginAction()
                EmptyView()
            }
        }
        .navigationBarHidden(true)
        .attachPresenter(presenter: presenter, bindedState: $state)
    }
}
