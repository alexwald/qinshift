import UIKit

@IBDesignable
class BaseTextField: UITextField, ErrorTextFieldProtocol {

    var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    @IBInspectable var defaultTextColor: UIColor = UIColor(named: "AWBlack")! { didSet { setup() } }
    @IBInspectable var placeholderColor: UIColor = UIColor(named: "AWGray")! { didSet { setup() } }
    @IBInspectable var defaultBorderColor: UIColor = UIColor.clear { didSet { setup() } }

    override var placeholder: String? { didSet { setup() } }

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
        setupUI()
    }

    func setup() {
        clearButtonMode = .never

        setupUI()
    }

    func setupUI() {
        
        font = UIFont(name: "Helvetica Neue", size: 15)
        layer.borderColor = defaultBorderColor.cgColor
        textColor = defaultTextColor
        backgroundColor = .white
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: placeholderColor]
        )
    }
}

// MARK: - Content insets
extension BaseTextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }
}
