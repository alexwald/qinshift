import UIKit

protocol ErrorTextFieldProtocol: UITextField {
    var inputIsValid: Bool { get set }
    var defaultTextColor: UIColor { get set }
    var defaultBorderColor: UIColor { get set }
}

extension ErrorTextFieldProtocol {
    var inputIsValid: Bool {
        get { !(textColor == UIColor(named: "AWRed")) }
        set {
            layer.borderWidth = 2.0
            layer.borderColor = newValue ? defaultBorderColor.cgColor : UIColor(named: "AWRed")?.cgColor
            textColor = newValue ? defaultTextColor : UIColor(named: "AWRed")
        }
    }
}
