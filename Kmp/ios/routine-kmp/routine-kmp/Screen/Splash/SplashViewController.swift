import SwiftUI
import RoutineShared

class SplashViewController : UIViewController {
        
    private lazy var presenter: SplashPresenter = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return SplashPresenter(ensureLoginSideEffect: appDelegate.ensureLoginSideEffect)
    }()
    private lazy var uiBinder = UiBinder<SplashPresenter.Action, SplashPresenter.State>()

    private lazy var rootView = SplashScreen(state: presenter.states.value as! SplashPresenter.State)
    private lazy var contentView = UIHostingController(rootView: rootView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstrains()
        
        uiBinder.bindTo(presenter: presenter, listener: { state in
            if (state is SplashPresenter.StateSuccess) {
                self.showTodoListView()
            } else {
                self.rootView.state = state
            }
        })
    }
    
    fileprivate func setupConstrains() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
    
    private func showTodoListView() {
        let rootViewController = TodoListViewController()
        navigationController?.setViewControllers([rootViewController], animated: true)
    }
}

struct SplashScreen: View {
    
    @State var state: SplashPresenter.State

    var body: some View {
        VStack(spacing: 16) {
            Image("Splash Logo")
            Text("Setting up account")
            if(state is SplashPresenter.StateLoading) {
                SpinnerView()
            } else {
                Button("Retry", action: {})
                    .padding()
                    .foregroundColor(Color.white)
                    .background(UIColor.splashPrimary())
                    .cornerRadius(4)
            }
        }
        .navigationBarHidden(true)
    }
}

struct SpinnerView: View {
    
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
