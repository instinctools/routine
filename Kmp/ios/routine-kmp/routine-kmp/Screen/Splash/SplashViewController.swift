import SwiftUI
import RoutineShared

class SplashViewController : UIViewController {
        
    private lazy var presenter: SplashPresenter = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return SplashPresenter(ensureLoginSideEffect: appDelegate.ensureLoginSideEffect)
    }()
    private lazy var uiBinder = UiBinder<SplashPresenter.Action, SplashPresenter.State>()

    let contentView = UIHostingController(rootView: SplashScreen())

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstrains()
    }
    
    fileprivate func setupConstrains() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
}

struct SplashScreen: View {

    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            Image("Splash Logo")
            Text("Setting up account")
            circularProgress
            Button("Retry", action: {})
        }
    }
    
    var circularProgress: some View {
        Circle()
        .size(width: 60, height: 60)
            .stroke(lineWidth: 4)
            .opacity(0.3)
            .foregroundColor(.blue)
//            .foregroundColor(Color(red: 0x83, green: 0x5D, blue: 0x51))
    }
}

struct SplashViewController_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
