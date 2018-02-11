
import Foundation
import UIKit

protocol dropDownViewProtocol {
    func dropDownPressed<T>(option: T, indexPath: Int, dropDownViewType: dropDownViewType)
}


// DropDownBtn Delegate
public protocol dropDownProtocol: class {
    func dropDownDidSelectAt(indexPath: Int, type: dropDownViewType)
    func dropDownViewWillShow(dropDownBtn: DropDownBtn)
    func dropDownViewDidShow(dropDownBtn: DropDownBtn)
    func dropDownViewWillHide(dropDownBtn: DropDownBtn)
    func dropDownViewDidHide(dropDownBtn: DropDownBtn)
}

extension dropDownProtocol {
    func dropDownDidSelectAt(indexPath: Int, type: dropDownViewType) { }
    func dropDownViewWillShow(dropDownBtn: DropDownBtn) { }
    func dropDownViewDidShow(dropDownBtn: DropDownBtn) { }
    func dropDownViewWillHide(dropDownBtn: DropDownBtn) { }
    func dropDownViewDidHide(dropDownBtn: DropDownBtn) { }
}

extension Bundle {
    static var current: Bundle {
        class dummyClass{}
        return Bundle(for: type(of: dummyClass()))
    }
}

/** Type of title of DropDownBtn. Whether to display a character string or an image
 * sentence -> display sentence
 * more_vert_white -> Display an image in which three white dots are arranged vertically
 * more_vert_black -> Display an image in which three black dots are arranged vertically
 */
public enum dropDownBtnType: String {
    case sentence
    case more_vert_white
    case more_vert_black
}


final public class DropDownBtn: UIButton, dropDownViewProtocol {

    private var dropViewHeight = NSLayoutConstraint() // A value indicating the dropView height of the dropDownBtn
    public var dropView = DropDownView() // DropDownView held by dropDownBtn
    public weak var delegate: dropDownProtocol? // Protocol for sending messages to the caller

//    var dropDownOptions: [String]  {
//        get {
//            return dropView.dropDownOptions
//        }
//        set(newValue) {
//            for val in newValue {
//                dropView.dropDownOptions.append(val)
//            }
//        }
//    }
    
    /** Delegate method called when dropDownView is selected.
     * option: T -> The value of the selected dropDownViewOptions
     * indexPath: Int -> IndexPath of the selected dropDownViewOptions
     * dropDownViewType: dropDownViewType -> Currently set DropDownView type
     */
    func dropDownPressed<T>(option: T, indexPath: Int, dropDownViewType: dropDownViewType) {
        defer {
            dismissDropDown()
        }
        delegate?.dropDownDidSelectAt(indexPath: indexPath, type: dropDownViewType)
        
        if btnType == dropDownBtnType.sentence {
            self.setTitle(option as? String, for: .normal)
        }
    }

//    private var optionsAction = [String: ( () -> Void) ]()
//    func addAction(option: String, _ handler: ( () -> Void)? = nil) {
//        if let closure = handler {
//            optionsAction[option] = closure
//        }
//    }
//    func addAction(_ handler: () -> Void ) {
//    }

    private var btnType: dropDownBtnType = .sentence // The value of the configured dropDownBtnType. The initial value is sentence
    
    /** initializer. frame is set to initialize with zero by default. You must specify dropDownBtnType
     */
    public convenience init(frame: CGRect = .zero, dropDownBtnType type: dropDownBtnType) {
        self.init(frame: frame)
        btnType = type
        setupBtnFrom(type: type)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    /** Set up Constraints etc., do first setup
     */
    private func initSetup() {
//        backgroundColor = .clear
//        dropView = DropDownView.init(frame: .zero)
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /** Perform initial setup according to the type of selected dropDownBtn
     */
    private func setupBtnFrom(type: dropDownBtnType) {
        switch type {
        case .sentence:
            setTitleColor(.white, for: .normal)
            setTitle("", for: .normal)
            
        case .more_vert_black, .more_vert_white:
            setImage(UIImage(named: type.rawValue, in: Bundle.main, compatibleWith: nil)!, for: .normal)
        }
    }
    
    override public func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
 
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        if let width = dropView.dropViewWidth {
            dropView.widthAnchor.constraint(equalToConstant: width).isActive = true
        } else {
            dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        }
    
        dropViewHeight = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            delegate?.dropDownViewWillShow(dropDownBtn: self)
            
            isOpen = true
            NSLayoutConstraint.deactivate([self.dropViewHeight])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.dropViewHeight.constant = 150
            } else {
                self.dropViewHeight.constant = self.dropView.tableView.contentSize.height
            }

            NSLayoutConstraint.activate([self.dropViewHeight])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: { _ in
                self.delegate?.dropDownViewDidShow(dropDownBtn: self)
            })
            
        } else {
            dismissDropDown()
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        delegate?.dropDownViewWillHide(dropDownBtn: self)
        NSLayoutConstraint.deactivate([self.dropViewHeight])
        self.dropViewHeight.constant = 0
        NSLayoutConstraint.activate([self.dropViewHeight])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: { _ in
            self.delegate?.dropDownViewDidHide(dropDownBtn: self)
        })
    }
    
}

