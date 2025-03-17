import UIKit

class ShoppingListViewController: UITableViewController {
    
    private var shoppingList: [ShoppingItem] = []
    private var categorizedShoppingList: [String: [ShoppingItem]] = [:]
    
    // Define category colors and icons
    private let categoryColors: [String: UIColor] = [
        "Groceries": .systemGreen,
        "Electronics": .systemBlue,
        "Clothing": .systemPurple,
        "Home & Kitchen": .systemOrange,
        "Others": .systemGray
    ]
    
    private let categoryIcons: [String: String] = [
        "Groceries": "cart.fill",
        "Electronics": "tv.fill",
        "Clothing": "tshirt.fill",
        "Home & Kitchen": "house.fill",
        "Others": "questionmark.circle.fill"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "🛒 Shopping List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        categorizeItems()
    }
    
    @objc private func addNewItem() {
        performSegue(withIdentifier: "showAddItem", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddItem",
           let destinationVC = segue.destination as? AddItemViewController {
            destinationVC.delegate = self
        }
    }
    
    // MARK: - Categorizing Items
    private func categorizeItems() {
        categorizedShoppingList.removeAll()
        
        for item in shoppingList {
            categorizedShoppingList[item.category, default: []].append(item)
        }
        
        tableView.reloadData()
    }

    // MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categorizedShoppingList.keys.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(categorizedShoppingList.keys)[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = Array(categorizedShoppingList.keys)[section]
        
        let headerView = UIView()
        headerView.backgroundColor = categoryColors[category] ?? .systemGray
        
        let label = UILabel()
        label.text = category
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: categoryIcons[category] ?? "questionmark.circle.fill")
        iconImageView.tintColor = .white
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(iconImageView)
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Array(categorizedShoppingList.keys)[section]
        return categorizedShoppingList[category]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath)

        let category = Array(categorizedShoppingList.keys)[indexPath.section]
        if let items = categorizedShoppingList[category] {
            let item = items[indexPath.row]
            cell.textLabel?.text = item.name
            cell.accessoryType = item.isPurchased ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = Array(categorizedShoppingList.keys)[indexPath.section]
        if var items = categorizedShoppingList[category] {
            items[indexPath.row].isPurchased.toggle()
            categorizedShoppingList[category] = items
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Deleting Items
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = Array(categorizedShoppingList.keys)[indexPath.section]
            categorizedShoppingList[category]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - AddItemViewControllerDelegate
extension ShoppingListViewController: AddItemViewControllerDelegate {
    func didAddNewItem(_ item: ShoppingItem) {
        shoppingList.append(item)
        categorizeItems()
    }
}
