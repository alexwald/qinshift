import UIKit

protocol ErrorViewWithTextFieldProtocol: ErrorConfigurableProtocol {
    associatedtype TextFieldType: ErrorTextFieldProtocol

    var textField: TextFieldType { get set }
    var errorLabel: ErrorDescriptionLabel { get set }
}

extension ErrorViewWithTextFieldProtocol {

    var isFirstResponder: Bool { textField.isFirstResponder }
    var canBecomeFirstResponder: Bool { textField.canBecomeFirstResponder }
    var canResignFirstResponder: Bool { textField.canResignFirstResponder }

    var isEnabled: Bool {
        get { textField.isEnabled }
        set { textField.isEnabled = newValue }
    }

    weak var delegate: UITextFieldDelegate? {
        get { textField.delegate }
        set { textField.delegate = newValue }
    }

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }

    var autocapitalizationType: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }

    var autocorrectionType: UITextAutocorrectionType {
        get { textField.autocorrectionType }
        set { textField.autocorrectionType = newValue }
    }

    var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }

    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    var textContentType: UITextContentType {
        get { textField.textContentType }
        set { textField.textContentType = newValue }
    }

    @discardableResult
    func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    @discardableResult
    func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

    func configure(error: Error?) {
        textField.inputIsValid = (error == nil)
        errorLabel.configure(error: error)
    }
}
