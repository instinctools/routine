import UIKit

class BottomCardViewController: UIViewController {

    private let transition = BottomCardTransition()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = transition
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
