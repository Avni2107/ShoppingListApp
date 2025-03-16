//
//  ShoppingListViewController.swift
//  ShoppingApp
//
//

import UIKit

class ShoppingListViewController: UITableViewController {
    
    var shoppingList: [ShoppingItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "🛒 My Shopping List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    }
    
    @objc func addNewItem() {
        performSegue(withIdentifier: "showAddItem", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddItem",
           let destinationVC = segue.destination as? AddItemViewController {
            destinationVC.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath)
        let item = shoppingList[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.isPurchased ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoppingList[indexPath.row].isPurchased.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - AddItemViewControllerDelegate
extension ShoppingListViewController: AddItemViewControllerDelegate {
    func didAddNewItem(_ item: ShoppingItem) {
        shoppingList.append(item)
        tableView.reloadData()
    }
}
