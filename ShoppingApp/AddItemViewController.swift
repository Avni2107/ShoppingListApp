import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
    func didAddNewItem(_ item: ShoppingItem)
}
//name field of the item
class AddItemViewController: UIViewController {

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    weak var delegate: AddItemViewControllerDelegate?
    
    private let categories = ["Groceries", "Electronics", "Clothing", "Home & Kitchen", "Others"]
    private var selectedCategory = "Groceries"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
    }

    private func setupPickerView() {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let itemName = itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !itemName.isEmpty else { return }

        let newItem = ShoppingItem(name: itemName, isPurchased: false, category: selectedCategory)
        delegate?.didAddNewItem(newItem)
        dismiss(animated: true)
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
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