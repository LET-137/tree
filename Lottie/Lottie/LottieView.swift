import UIKit
import Lottie

class LottieView: UIView {

    @IBOutlet weak var containerView: UIView!
    private var animationView: LottieAnimationView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("LottieView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func playAnimation(named name: String, loop: Bool = true) {
        animationView?.removeFromSuperview()
        animationView = LottieAnimationView(name: name)
        animationView?.frame = containerView.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = loop ? .loop : .playOnce
        containerView.addSubview(animationView!)
        animationView?.play()
    }
}
