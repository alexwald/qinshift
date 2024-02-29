import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            if !isSelected {
                layer.cornerRadius = cornerRadius
            }
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            if !isSelected {
                layer.borderWidth = borderWidth
            }
        }
    }

    @IBInspectable var selectedBorderWidth: CGFloat = 0 {
        didSet {
            if isSelected {
                layer.borderWidth = selectedBorderWidth
            }
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            if !isSelected {
                layer.borderColor = borderColor.cgColor
            }
        }
    }

    @IBInspectable var selectedBorderColor: UIColor = .clear {
        didSet {
            if isSelected {
                layer.borderColor = selectedBorderColor.cgColor
            }
        }
    }

    @IBInspectable var enabledBackgroundColor: UIColor = .systemBlue {
        didSet {
            if isEnabled {
                backgroundColor = enabledBackgroundColor
            }
        }
    }

    @IBInspectable var disabledBackgroundColor: UIColor = .systemGray {
        didSet {
            if !isEnabled {
                backgroundColor = disabledBackgroundColor
            }
        }
    }

    @IBInspectable var selectedBackgroundColor: UIColor = .white {
        didSet {
            if isSelected {
                backgroundColor = selectedBackgroundColor
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = selectedBorderColor.cgColor
                layer.cornerRadius = cornerRadius
                layer.borderWidth = selectedBorderWidth
                backgroundColor = selectedBackgroundColor

            } else {
                layer.borderColor = borderColor.cgColor
                layer.cornerRadius = cornerRadius
                layer.borderWidth = borderWidth
                backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = enabledBackgroundColor
            } else {
                backgroundColor = disabledBackgroundColor
            }
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = enabledBackgroundColor
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
    }
}
