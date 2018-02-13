# SCDropDownMenu

## Requirements
SCDropDownMenu is written in Swift 3. iOS 8.0+ Required

## Installation
SCDropDownMenu is available through CocoaPods or Carthage.

### Cocoapods
```
pod "SCDropDownMenu"
```

### Carthage
```
github "r-kaga/SCDropDownMenu"
```

## Example

```swift
navigationDropDownMenu = DropDownBtn(dropDownBtnType: .sentence)
navigationDropDownMenu.setTitle("Colors", for: .normal)
navigationDropDownMenu.backgroundColor = .black
navigationDropDownMenu.dropView.setupDropDownViews(options: ["black", "white", "blue"])
navigationDropDownMenu.dropView.backgroundColor = UIColor(red: 166/255, green: 193/255, blue: 238/255, alpha: 1.0)
self.view.addSubview(navigationDropDownMenu)

navigationDropDownMenu.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
navigationDropDownMenu.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
navigationDropDownMenu.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
navigationDropDownMenu.heightAnchor.constraint(equalToConstant: 50).isActive = true
```

```swift
let dropDownBtn = DropDownBtn(dropDownBtnType: .more_vert_white)
dropDownBtn.delegate = self
dropDownBtn.backgroundColor = .black
dropDownBtn.dropView.setupDropDownViews(options: [.add_black, .delete_white, .play_arrow_white])
dropDownBtn.dropView.backgroundColor = UIColor(red: 166/255, green: 193/255, blue: 238/255, alpha: 1.0)
self.view.addSubview(dropDownBtn)

dropDownBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
dropDownBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
dropDownBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
dropDownBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
```

## Customize

```swift
extension ViewController: SCDropDownMenuDelegate {

    func dropDownMenu(didSelectAt indexPath: Int, type: dropDownViewType) {
        switch indexPath {
        case 0: break
        case 1: break
        case 2: break
        default: break
        }
    }
    
    func dropDownViewWillShow(dropDownBtn: DropDownBtn) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            dropDownBtn.rotateDropDownBtn(to: dropDownBtn.imageView!)
            dropDownBtn.backgroundColor = UIColor(red: 166/255, green: 193/255, blue: 238/255, alpha: 1.0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
//                dropDownBtn.imageView?.image = UIImage(named: "more_vert_white")!
            })
        })
    }
    
    func dropDownViewWillHide(dropDownBtn: DropDownBtn) {
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
```
