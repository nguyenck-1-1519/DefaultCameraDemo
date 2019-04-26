import UIKit
import ContactsUI

extension UIAlertController {
    
    /// Add Contacts Picker
    ///
    /// - Parameters:
    ///   - selection: action for selection of contact
    
    func addParamsPicker(selection: @escaping ParamsPickerViewController.Selection) {
        let selection: ParamsPickerViewController.Selection = selection
        var params = [String]()
        
        let addParam = UIAlertAction(title: "Upload Photo", style: .default) { action in
            selection(params)
        }
        addParam.isEnabled = false
        
        let vc = ParamsPickerViewController { new in
            addParam.isEnabled = new.count > 0
            params = new
        }
        
        set(vc: vc)
        addAction(addParam)
    }
}

final class ParamsPickerViewController: UIViewController {
    
    // MARK: UI Metrics
    
    struct UI {
        static let rowHeight: CGFloat = 58
        static let separatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
    
    // MARK: Properties
    
    public typealias Selection = ([String]) -> ()
    
    fileprivate var selection: Selection?
    
    //Contacts ordered in dicitonary alphabetically
    fileprivate var orderedContacts = [String: [CNContact]]()
    fileprivate var sortedContactKeys = [String]()
    fileprivate var filteredContacts: [CNContact] = []
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = true
        $0.rowHeight = UI.rowHeight
        $0.separatorColor = UI.separatorColor
        $0.bounces = true
        $0.backgroundColor = nil
        $0.tableFooterView = UIView()
        $0.sectionIndexBackgroundColor = .clear
        $0.sectionIndexTrackingBackgroundColor = .clear
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    // MARK: Initialize
    
    required init(selection: Selection?) {
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredContentSize.width = UIScreen.main.bounds.width / 2
        }

        tableView.register(UINib(nibName: ParameterTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: ParameterTableViewCell.identifier)
        
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .bottom
        definesPresentationContext = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize.height = tableView.contentSize.height
        Log("preferredContentSize.height = \(preferredContentSize.height), tableView.contentSize.height = \(tableView.contentSize.height)")
    }
}

// MARK: - TableViewDataSource, TableViewDelegate

extension ParamsPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppInfo.shared.listParameter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParameterTableViewCell.identifier)
            as? ParameterTableViewCell else {
            return UITableViewCell()
        }
        cell.contentLabel?.text = AppInfo.shared.listParameter[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedParam = [String]()
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for selectedRow in selectedRows {
                selectedParam.append(AppInfo.shared.listParameter[selectedRow.row])
            }
        }
        selection?(selectedParam)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows == nil {
            selection?([])
            return
        }
        var selectedParam = [String]()
        if let selectedRows = tableView.indexPathsForSelectedRows {
            if selectedRows.count == 0 {
                selection?([])
                return
            }
            for selectedRow in selectedRows {
                selectedParam.append(AppInfo.shared.listParameter[selectedRow.row])
            }
        }
        selection?(selectedParam)
    }
}
