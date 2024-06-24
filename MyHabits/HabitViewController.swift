import UIKit

class HabitViewController: UIViewController {

    var habitToEdit: Habit?
    
    private let habitNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Название"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let habitNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название привычки"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .systemBlue
        return textField
    }()

    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeText: UILabel = {
        let label = UILabel()
        label.text = "Каждый день"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.backgroundColor = .white
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = habitToEdit == nil ? "Создать привычку" : "Править привычку"

        setupNavigationBar()
        setupViews()
        if let habit = habitToEdit {
            setupEditView(with: habit)
        }
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: habitToEdit == nil ? "Создать" : "Сохранить", style: .done, target: self, action: #selector(saveButtonTapped))
        
    }
    

    private func setupViews() {
        view.addSubview(habitNameLabel)
        view.addSubview(habitNameTextField)
        view.addSubview(colorLabel)
        view.addSubview(colorCircle)
        view.addSubview(timeLabel)
        view.addSubview(timeText)
        view.addSubview(timePicker)
        
        if habitToEdit != nil {
            view.addSubview(deleteButton)
            deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorCircleTapped))
        colorCircle.addGestureRecognizer(tapGesture)
        colorCircle.isUserInteractionEnabled = true

        NSLayoutConstraint.activate([
            habitNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            habitNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            habitNameTextField.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 5),
            habitNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            colorLabel.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 20),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            colorCircle.centerYAnchor.constraint(equalTo: colorLabel.centerYAnchor),
            colorCircle.leadingAnchor.constraint(equalTo: colorLabel.trailingAnchor, constant: 10),
            colorCircle.widthAnchor.constraint(equalToConstant: 30),
            colorCircle.heightAnchor.constraint(equalToConstant: 30),

            timeLabel.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 20),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            timeText.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            timeText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            timePicker.centerYAnchor.constraint(equalTo: timeText.centerYAnchor),
            timePicker.leadingAnchor.constraint(equalTo: timeText.trailingAnchor, constant: 10),
        ])
        
        if habitToEdit != nil {
            NSLayoutConstraint.activate([
                deleteButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 20),
                deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }

    private func setupEditView(with habit: Habit) {
        habitNameTextField.text = habit.name
        colorCircle.backgroundColor = habit.color
        colorCircle.layer.borderColor = habit.color.cgColor
        timePicker.date = habit.date
    }

    @objc private func colorCircleTapped() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = colorCircle.backgroundColor ?? .systemBlue
        
        colorPicker.delegate = self
        colorPicker.supportsAlpha = false
        present(colorPicker, animated: true, completion: nil)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func saveButtonTapped() {
        guard let name = habitNameTextField.text, !name.isEmpty else {
            let alert = UIAlertController(title: "Ошибка", message: "Название привычки не может быть пустым", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        let newHabit = Habit(name: name, date: timePicker.date, color: colorCircle.backgroundColor ?? .systemBlue)
        let store = HabitsStore.shared
        
        if let habitToEdit = habitToEdit, let index = store.habits.firstIndex(of: habitToEdit) {
            store.habits[index] = newHabit
        } else {
            store.habits.append(newHabit)
        }

        NotificationCenter.default.post(name: NSNotification.Name("habitsChanged"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteButtonTapped() {
        guard let habitToEdit = habitToEdit else { return }
        
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы уверены, что хотите удалить привычку \"\(habitToEdit.name)\"?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            let store = HabitsStore.shared
            if let index = store.habits.firstIndex(of: habitToEdit) {
                store.habits.remove(at: index)
            }
            NotificationCenter.default.post(name: NSNotification.Name("habitsChanged"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorCircle.backgroundColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorCircle.backgroundColor = viewController.selectedColor
    }
}
