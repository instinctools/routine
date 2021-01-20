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
                SplashSpinnerView()
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

struct SplashSpinnerView: View {
    
    let timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
    @State var leftOffset: CGFloat = -100
    @State var rightOffset: CGFloat = 100
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: 1))
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: 1).delay(0.2))
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: 1).delay(0.4))
        }
        .onReceive(timer) { (_) in
            swap(&self.leftOffset, &self.rightOffset)
        }
    }
}
