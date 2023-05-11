import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLbl = K.nameApp
        var indexTime = 0
        titleLabel.text = ""
        for it in titleLbl {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(indexTime), repeats: false) { timer in
                self.titleLabel.text?.append(it)
            }
            indexTime += 1
        }
    }
}
