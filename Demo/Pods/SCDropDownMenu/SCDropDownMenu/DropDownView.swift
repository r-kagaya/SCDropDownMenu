
import Foundation
import UIKit

// View displayed when DropDown
public class DropDownView: UIView, UITableViewDelegate {
    
    public var tableView = UITableView()
    public var dropViewWidth: CGFloat? // Set the value when changing width of dropDownView to width of dropDownBtn
    public var separatorStyle: UITableViewCellSeparatorStyle = .none
    public var isBounces: Bool = false
    
    // Override the backgroundColor and set the value of tableView backgroundColor. Set backgroundColor of DropDownView to clear
    override public var backgroundColor: UIColor? {
        get {
            return tableView.backgroundColor ?? .clear
        }
        set(newValue) {
            tableView.backgroundColor = newValue ?? .clear
        }
    }
    
    internal var delegate: dropDownViewProtocol! // delegate for sending messages to dropDownBtn
    
    private var dataSource: DropDownViewDataSource!

    private override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    /** Set up Constraints, backgroundColor etc., do first setup */
    private func initSetup() {
        dataSource = DropDownViewDataSource(presenter: self)
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.backgroundColor = .clear
        tableView.separatorStyle = separatorStyle
        tableView.bounces = isBounces
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }


    // func to set the option to display in dropDownView and dropDownViewType.
    public func setupDropDownViews(options: [String]) {
        for option in options {
            dataSource.options.append(option)
        }
        dataSource.viewType = dropDownViewType.string
    }
    
    public func setupDropDownViews(options: [dropDownViewImages]) {
        for option in options {
            dataSource.options.append(DropDownBtn.getImage(named: option.rawValue))
        }
        dataSource.viewType = dropDownViewType.image
    }
    
    //    public func setupDropDownViews<T>(options: [T], type: dropDownViewType) {
    //        for option in options {
    //            dropDownOptions.append(option)
    //        }
    //        viewType = type
    //    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendMessageToDropDownBtn(indexPath: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // send a message to DropDownBtn
    private func sendMessageToDropDownBtn(indexPath: Int) {
        switch dataSource.viewType {
        case .string:
            delegate.dropDownPressed(option: dataSource.options[indexPath] as! String,
                                     indexPath: indexPath,
                                     dropDownViewType: dataSource.viewType)
        case .image:
            delegate.dropDownPressed(option: dataSource.options[indexPath] as! UIImage,
                                     indexPath: indexPath,
                                     dropDownViewType: dataSource.viewType)
        }
    }

}

