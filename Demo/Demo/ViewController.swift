
import UIKit
import SCDropDownMenu

class ViewController: UIViewController {

    var dropButton: DropDownBtn!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropButton = DropDownBtn(dropDownBtnType: .more_vert_black)
        dropButton.delegate = self
        dropButton.dropView.setupDropDownViews(options: [.delete_white])
        dropButton.dropView.backgroundColor = .black
        dropButton.backgroundColor = .clear
        self.view.addSubview(dropButton)
        
        dropButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dropButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        dropButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dropButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController: dropDownProtocol {
    func dropDownViewDidShow(dropDownBtn: DropDownBtn) {
        
    }
    
    func dropDownViewDidHide(dropDownBtn: DropDownBtn) {
        
    }
    
    func dropDownDidSelectAt(indexPath: Int, type: dropDownViewType) {
        switch indexPath {
        case 0: break
        case 1: break
        case 2: break
        default: break
        }
    }
    
    func dropDownViewWillShow(dropDownBtn: DropDownBtn) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            let angle = 90 * CGFloat.pi / 180
            dropDownBtn.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            dropDownBtn.backgroundColor = .black
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                dropDownBtn.imageView?.image = UIImage(named: "more_vert_white")!
            })
        })
    }
    
    func dropDownViewWillHide(dropDownBtn: DropDownBtn) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: {
            dropDownBtn.backgroundColor = .clear
            dropDownBtn.imageView?.image = UIImage(named: "more_vert_black")!
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                dropDownBtn.transform = .identity
            })
        })
    }
    
}
