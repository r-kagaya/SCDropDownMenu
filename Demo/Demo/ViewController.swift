
import UIKit
import SCDropDownMenu

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dropButton = DropDownBtn.init(frame: .zero, dropDownBtnType: .more_vert_black)
        dropButton.delegate = self
        dropButton.dropView.setupDropDownViews(options: [.delete_white])
        dropButton.dropView.backgroundColor = .black
        dropButton.backgroundColor = .clear
        self.cardView.addSubview(dropButton)
        
        dropButton.topAnchor.constraint(equalTo: self.cardView.topAnchor).isActive = true
        dropButton.rightAnchor.constraint(equalTo: self.cardView.rightAnchor).isActive = true
        dropButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dropButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}

extension ViewController: dropDownProtocol {
    func dropDownDidSelectAt(indexPath: Int, type: dropDownViewType) {
        switch indexPath {
        case 0:
            let alert = SimpleAlert.new(title: "Done", description: "削除しました")
            alert.setDailogImage(type: .done)
            alert.fadeIn()
        case 1:
            self.close()
        case 2: break
        default: break
        }
    }
    
    func dropDownViewWillShow(dropDownBtn: DropDownBtn) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            let angle = 90 * CGFloat.pi / 180
            dropDownBtn.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            dropDownBtn.backgroundColor = App.appColor
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                //                self.cicleView.backgroundColor = .black
                //                self.cicleView.transform = CGAffineTransform(scaleX: dropDownBtn.frame.width, y: dropDownBtn.frame.height)
                dropDownBtn.imageView?.image = UIImage(named: "more_vert_white")!
            })
        })
    }
    
    func dropDownViewWillHide(dropDownBtn: DropDownBtn) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: {
            dropDownBtn.backgroundColor = .clear
            //            self.cicleView.backgroundColor = .clear
            dropDownBtn.imageView?.image = UIImage(named: "more_vert_black")!
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                dropDownBtn.transform = .identity
            })
        })
    }
    
}

