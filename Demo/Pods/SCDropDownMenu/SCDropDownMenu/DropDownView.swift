
import Foundation
import UIKit

// Type of Options displayed in DropDownView
public enum dropDownViewType: Int {
    case string
    case image
}

// Default image collection that can be set in DropDownView
// rawValue is the name of the Image file
public enum dropDownViewImages: String {
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

// View displayed when DropDown
public class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
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

    private var dropDownOptions = [Any]() // Display the value of this Array in dropDownView
    private var viewType: dropDownViewType = .string // What sets the value type to display in dropDownView. If string, treat dropDownViewOptions as String type

    // func to set the option to display in dropDownView and dropDownViewType.
    public func setupDropDownViews(options: [String]) {
        for option in options {
            dropDownOptions.append(option)
        }
        viewType = dropDownViewType.string
    }

    public func setupDropDownViews(options: [dropDownViewImages]) {
        for option in options {
            dropDownOptions.append(DropDownBtn.getImage(named: option.rawValue))
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
        return setupDropDownViewCell(indexPath: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendMessageToDropDownBtn(indexPath: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
        tableView.delegate = self
        tableView.dataSource = self
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
    
    /** Set up DropDownViewCell */
    private func setupDropDownViewCell(indexPath: Int) ->  UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        switch viewType {
        case .image:
            let imageView = UIImageView(frame: DropDownBtn.dropDownImageFrame)
            imageView.center = CGPoint(x: tableView.frame.width / 2, y: cell.frame.height / 2)
            imageView.image = self.dropDownOptions[indexPath] as? UIImage
            imageView.contentMode = .scaleAspectFit
            cell.addSubview(imageView)
//            cell.imageView?.image = self.dropDownOptions[indexPath] as? UIImage
//            cell.imageView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height)
            
        case .string:
            let label = UILabel(frame: CGRect(x: 5, y: 0, width: tableView.frame.width - 10, height: cell.frame.height))
            cell.addSubview(label)
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 1
            label.textAlignment = .center
            label.textColor = .white
            label.text = dropDownOptions[indexPath] as? String
        }
        
        return cell
    }
    
    // send a message to DropDownBtn
    private func sendMessageToDropDownBtn(indexPath: Int) {
        switch viewType {
        case .string:
            delegate.dropDownPressed(option: dropDownOptions[indexPath] as! String,
                                     indexPath: indexPath,
                                     dropDownViewType: viewType)
        case .image:
            delegate.dropDownPressed(option: dropDownOptions[indexPath] as! UIImage,
                                     indexPath: indexPath,
                                     dropDownViewType: viewType)
        }
    }
    
    
}

