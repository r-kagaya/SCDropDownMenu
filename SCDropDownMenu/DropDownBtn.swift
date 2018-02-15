
import Foundation
import UIKit

// A protocol that connects DropDownBtn and DropDownView
protocol dropDownViewProtocol {
    func dropDownPressed<T>(option: T, indexPath: Int, dropDownViewType: dropDownViewType)
}

// Protocol implemented by the caller to customize the behavior of DropDownBtn
public protocol SCDropDownMenuDelegate {
    func dropDownMenu(dropDownBtn: DropDownBtn, didSelectAt indexPath: Int, type: dropDownViewType)
    func dropDownViewWillShow(dropDownBtn: DropDownBtn)
    func dropDownViewDidShow(dropDownBtn: DropDownBtn)
    func dropDownViewWillHide(dropDownBtn: DropDownBtn)
    func dropDownViewDidHide(dropDownBtn: DropDownBtn)
}

public extension SCDropDownMenuDelegate {
    func dropDownMenu(dropDownBtn: DropDownBtn, didSelectAt indexPath: Int, type: dropDownViewType) {}
    func dropDownViewWillShow(dropDownBtn: DropDownBtn) {}
    func dropDownViewDidShow(dropDownBtn: DropDownBtn) {}
    func dropDownViewWillHide(dropDownBtn: DropDownBtn) {}
    func dropDownViewDidHide(dropDownBtn: DropDownBtn) {}
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
    
    public var dropView = DropDownView() // DropDownView held by dropDownBtn
    public var delegate: SCDropDownMenuDelegate? // Protocol for sending messages to the caller
    public static var dropDownImageFrame = CGRect()
    
    private var dropViewHeight = NSLayoutConstraint() // A value indicating the dropView height of the dropDownBtn
    private var btnType: dropDownBtnType = .sentence // The value of the configured dropDownBtnType. The initial value is sentence
    
    /** initializer. frame is set to initialize with zero by default. You must specify dropDownBtnType
     */
    public convenience init(frame: CGRect = .zero, dropDownBtnType type: dropDownBtnType) {
        self.init(frame: frame)
        btnType = type
        setupBtnFrom(type: type)
    }
    
    override public func didMoveToSuperview() {
        setupDropDownBtnLayout()
    }
    
    var isOpen = false
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isOpen ? dismissDropDownView() : presentDropDownView()
    }
    
    public func rotateDropDownBtn(to: UIView, angle: CGFloat = 90) {
        let rotateAngle = angle * CGFloat.pi / 180
        to.transform = CGAffineTransform(rotationAngle: CGFloat(rotateAngle))
    }
    
    
    /** Delegate method called when dropDownView is selected.
     * option: T -> The value of the selected dropDownViewOptions
     * indexPath: Int -> IndexPath of the selected dropDownViewOptions
     * dropDownViewType: dropDownViewType -> Currently set DropDownView type
     */
    func dropDownPressed<T>(option: T, indexPath: Int, dropDownViewType: dropDownViewType) {
        defer {
            dismissDropDownView()
        }
        delegate?.dropDownMenu(dropDownBtn: self, didSelectAt: indexPath, type: dropDownViewType)
        //        if btnType == dropDownBtnType.sentence {
        //            self.setTitle(option as? String, for: .normal)
        //        }
    }
    
    public class func getImage(named: String) -> UIImage {
        let bundle = Bundle(for: self)
        return UIImage(named: named, in: bundle, compatibleWith: nil)!
    }
    
    /** Present DropDownView */
    private func presentDropDownView() {
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
    }
    
    /** Dismiss DropDownView */
    private func dismissDropDownView() {
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
    
    /** Perform initial setup DropDownBtnLayout */
    private func setupDropDownBtnLayout() {
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
        
        guard let imgView = imageView else { return }
        DropDownBtn.dropDownImageFrame = imgView.frame
    }
    
    /** Perform initial setup according to the type of selected dropDownBtn
     */
    private func setupBtnFrom(type: dropDownBtnType) {
        switch type {
        case .sentence:
            setTitleColor(.white, for: .normal)
            setTitle("", for: .normal)
            
        case .more_vert_black, .more_vert_white:
            //            setImage(UIImage(named: type.rawValue, in: Bundle.current, compatibleWith: nil), for: .normal)
            setImage(DropDownBtn.getImage(named: type.rawValue), for: .normal)
        }
    }
    
    
}

