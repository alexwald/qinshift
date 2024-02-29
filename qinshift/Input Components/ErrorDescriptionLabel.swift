import UIKit

@IBDesignable
class ErrorDescriptionLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        setup()
        self.text = NSLocalizedString("Error description", comment: "")
    }

    private func setup() {
        self.text = nil
        self.textColor = UIColor(named: "AWRed")
        self.backgroundColor = UIColor.clear
        self.font = UIFont(name: "Helvetica Neue", size: 13)
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
    }

    func configure(error: Error?) {
        self.text = error?.localizedDescription
    }
}
