import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
    func didAddNewItem(_ item: ShoppingItem)
}

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!  // Add Outlet for PickerView
    
    weak var delegate: AddItemViewControllerDelegate?
    
    let categories = ["Groceries", "Electronics", "Clothing", "Home & Kitchen", "Others"]  // Category List
    var selectedCategory: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Picker View Delegates
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        // Set Default Selection
        selectedCategory = categories.first
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let itemName = itemNameTextField.text, !itemName.isEmpty else { return }
        
        let newItem = ShoppingItem(name: itemName, isPurchased: false, category: selectedCategory ?? "Others")
        delegate?.didAddNewItem(newItem)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension AddItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
    }
}
