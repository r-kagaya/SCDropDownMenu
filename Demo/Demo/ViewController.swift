
import UIKit
import SCDropDownMenu

class ViewController: UIViewController {

    private var navigationDropDownMenu: DropDownBtn!
    private let colors = ["black", "white", "blue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationDropDownMenu()
        setupDropDownButton()
    }

    private func setupNavigationDropDownMenu() {
        navigationDropDownMenu = DropDownBtn(dropDownBtnType: .sentence)
        navigationDropDownMenu.delegate = self
        navigationDropDownMenu.tag = 1
        navigationDropDownMenu.setTitle("Colors", for: .normal)
        navigationDropDownMenu.backgroundColor = .black
        navigationDropDownMenu.dropView.setupDropDownViews(options: colors)
        navigationDropDownMenu.dropView.backgroundColor = UIColor(red: 166/255, green: 193/255, blue: 238/255, alpha: 1.0)
        self.view.addSubview(navigationDropDownMenu)
        
        navigationDropDownMenu.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        navigationDropDownMenu.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        navigationDropDownMenu.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        navigationDropDownMenu.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupDropDownButton() {
        let dropDownBtn = DropDownBtn(dropDownBtnType: .more_vert_white)
        dropDownBtn.delegate = self
        dropDownBtn.tag = 2

        dropDownBtn.backgroundColor = .black
        dropDownBtn.dropView.setupDropDownViews(options: [.add_black, .delete_white, .play_arrow_white])
        dropDownBtn.dropView.backgroundColor = UIColor(red: 166/255, green: 193/255, blue: 238/255, alpha: 1.0)
        self.view.addSubview(dropDownBtn)
        
//        dropDownBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        dropDownBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        dropDownBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dropDownBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let dropDownBtnTopConstraint = NSLayoutConstraint(item: dropDownBtn,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: navigationDropDownMenu,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 200)
        self.view.addConstraint(dropDownBtnTopConstraint)
        
        let dropDownBtnTrailingConstraint = NSLayoutConstraint(item: dropDownBtn,
                                                          attribute: .left,
                                                          relatedBy: .equal,
                                                          toItem: self.view,
                                                          attribute: .left,
                                                          multiplier: 1.0,
                                                          constant: 10)
        self.view.addConstraint(dropDownBtnTrailingConstraint)
    }
    

}

extension ViewController: SCDropDownMenuDelegate {

    func dropDownMenu(dropDownBtn: DropDownBtn, didSelectAt indexPath: Int, type: dropDownViewType) {
        switch dropDownBtn.tag {
        case 1:
            dropDownBtn.setTitle(colors[indexPath], for: .normal)
        default: break
        }
    }
    
    func dropDownViewWillShow(dropDownBtn: DropDownBtn) {
        if dropDownBtn.tag == 2 {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                dropDownBtn.rotateDropDownBtn(to: dropDownBtn.imageView!)
                dropDownBtn.backgroundColor = UIColor(red: 166/255, green: 193/255, blue: 238/255, alpha: 1.0)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                    //                dropDownBtn.imageView?.image = UIImage(named: "more_vert_white")!
                })
            })
        }
    }
    
    func dropDownViewWillHide(dropDownBtn: DropDownBtn) {
        if dropDownBtn.tag == 2 {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: {
                dropDownBtn.backgroundColor = .black
    //            dropDownBtn.imageView?.image = UIImage(named: "more_vert_black")!
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                    dropDownBtn.imageView?.transform = .identity
                })
            })
        }
    }

    
}
