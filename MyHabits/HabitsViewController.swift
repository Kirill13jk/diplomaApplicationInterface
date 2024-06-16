import UIKit

class HabitsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HabitCollectionViewCellDelegate {
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupCollectionView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabitTapped))
        navigationItem.title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @objc private func addHabitTapped() {
        let habitViewController = HabitViewController()
        let navigationController = UINavigationController(rootViewController: habitViewController)
        present(navigationController, animated: true, completion: nil)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HabitsStore.shared.habits.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
            cell.updateProgress()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as! HabitCollectionViewCell
            let habit = HabitsStore.shared.habits[indexPath.item - 1]
            cell.configure(with: habit)
            cell.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != 0 else { return }
        let habit = HabitsStore.shared.habits[indexPath.item - 1]
        let habitDetailsViewController = HabitDetailsViewController(habit: habit)
        navigationController?.pushViewController(habitDetailsViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 130)
    }

    func habitCell(_ cell: HabitCollectionViewCell, didToggleCompletionFor habit: Habit) {
        if !habit.isAlreadyTakenToday {
            HabitsStore.shared.track(habit)
        } else {
            habit.trackDates.removeAll { Calendar.current.isDate($0, inSameDayAs: Date()) }
        }
        collectionView.reloadData()
    }

    func habitCellDidTap(_ cell: HabitCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let habit = HabitsStore.shared.habits[indexPath.item - 1]
        let habitDetailsViewController = HabitDetailsViewController(habit: habit)
        navigationController?.pushViewController(habitDetailsViewController, animated: true)
    }
}
