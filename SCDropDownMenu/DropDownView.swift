
import Foundation
import UIKit


public enum dropDownViewType: Int {
    case string
    case image
}

public enum dropDownViewImageType: String {
    case more_vert_white
    case more_vert_black
    case done_white
    case done_black
    case clear_white
    case clear_black
    case play_arrow_white
    case play_arrow_black
    case create_white
    case create_black
    case delete_white
    case delete_black
    case menu_white
    case menu_black
    case mail_white
    case mail_black
    case add_white
    case add_black
    case add_circle_outline_white
    case add_circle_outline_black
    case search_white
    case search_black
}

final public class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    private var dropDownOptions = [Any]() // Display the value of this Array in dropDownView
    private var viewType: dropDownViewType = .string // What sets the value type to display in dropDownView. If string, treat dropDownViewOptions as String type
    
    var delegate: dropDownViewProtocol! // delegate for sending messages to dropDownBtn
    
    public var dropViewWidth: CGFloat? // Set the value when changing width of dropDownView to width of dropDownBtn
    
    // Override the backgroundColor and set the value of tableView backgroundColor. Set backgroundColor of DropDownView to clear
    override public var backgroundColor: UIColor? {
        get {
            return tableView.backgroundColor ?? .clear
        }
        set(newValue) {
            tableView.backgroundColor = newValue ?? .clear
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    /** Set up Constraints, backgroundColor etc., do first setup
     */
    private func initSetup() {
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    // func to set the option to display in dropDownView and dropDownViewType.
    public func setupDropDownViews<T>(options: [T], type: dropDownViewType) {
        for option in options {
            dropDownOptions.append(option)
        }
        viewType = type
    }

    public func setupDropDownViews(options: [dropDownViewImageType]) {
        for option in options {
            dropDownOptions.append(UIImage(named: option.rawValue, in: Bundle(for: type(of: self)), compatibleWith: nil)!)
            
        }
        viewType = dropDownViewType.image
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: tableView.frame.width - 10, height: cell.frame.height))
        cell.addSubview(label)
        
        switch viewType {
        case .image:
            cell.imageView?.image = dropDownOptions[indexPath.row] as? UIImage
        case .string:
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 1
            //        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .center
            label.textColor = .white
            label.text = dropDownOptions[indexPath.row] as? String
            
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewType {
        case .string:
            delegate.dropDownPressed(option: dropDownOptions[indexPath.row] as! String, indexPath: indexPath.row, dropDownViewType: viewType)
        case .image:
            delegate.dropDownPressed(option: dropDownOptions[indexPath.row] as! UIImage, indexPath: indexPath.row, dropDownViewType: viewType)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

