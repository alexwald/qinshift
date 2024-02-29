import UIKit

class SecureTextField: BaseTextField {
    let togglePasswordVisibilityButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))

    override var isSecureTextEntry: Bool {
        didSet {
            togglePasswordVisibilityButton.setImage(
                isSecureTextEntry ? UIImage(named: "icon-show-password") : UIImage(named: "icon-hide-password"),
                for: .normal
            )
        }
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.size.width - 24 - 10,
            y: (bounds.size.height - 24) / 2,
            width: 24, height: 24
        )
    }

    override func setup() {
        super.setup()

        isSecureTextEntry = true

        togglePasswordVisibilityButton.setImage(UIImage(named: "icon-show-password"), for: .normal)
        togglePasswordVisibilityButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        togglePasswordVisibilityButton.tintColor = UIColor(named: "MSMSHidePasswordGray")
        rightView = togglePasswordVisibilityButton
        rightViewMode = .always
    }

    @objc func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry

        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if selectedTextRange != nil {
            selectedTextRange = nil
        }
    }
}
