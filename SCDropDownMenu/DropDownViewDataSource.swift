
import Foundation
import UIKit

public class DropDownViewDataSource: NSObject, UITableViewDataSource {
    
    var viewType: dropDownViewType = .string // What sets the value type to display in dropDownView. If string, treat dropDownViewOptions as String type
    var options: [Any] // Display the value of this Array in dropDownView
    var viewWidth: CGFloat
    
    required public init(option: [Any] = [Any](), viewWidth: CGFloat) {
        self.options = option
        self.viewWidth = viewWidth
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupDropDownViewCell(indexPath: indexPath.row)
    }
    
    /** Set up DropDownViewCell */
    private func setupDropDownViewCell(indexPath: Int) ->  UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        switch viewType {
        case .image:
            let imageView = UIImageView(frame: DropDownBtn.dropDownImageFrame)
            imageView.center = CGPoint(x: viewWidth / 2, y: cell.frame.height / 2)
            imageView.image = options[indexPath] as? UIImage
            //            imageView.image = self.dropDownOptions[indexPath] as? UIImage
            imageView.contentMode = .scaleAspectFit
            cell.addSubview(imageView)
            //            cell.imageView?.image = self.dropDownOptions[indexPath] as? UIImage
            //            cell.imageView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height)
            
        case .string:
            let label = UILabel(frame: CGRect(x: 5, y: 0, width: viewWidth - 10, height: cell.frame.height))
            cell.addSubview(label)
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 1
            label.textAlignment = .center
            label.textColor = .white
            label.text = options[indexPath] as? String
        }
        
        return cell
    }
    
}
