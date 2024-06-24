import UIKit

protocol HabitCollectionViewCellDelegate: AnyObject {
    func habitCell(_ cell: HabitCollectionViewCell, didTapCompleteButton habit: Habit)
}

final class HabitCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HabitCollectionViewCell"
    weak var delegate: HabitCollectionViewCellDelegate?
    
    private var habit: Habit?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray2
        return label
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(completeButton)
        
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func completeButtonTapped() {
        guard let habit = habit else { return }
        delegate?.habitCell(self, didTapCompleteButton: habit)
    }
    
    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: completeButton.leadingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -16),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            counterLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            counterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            completeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 36),
            completeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func configure(with habit: Habit) {
        self.habit = habit
        nameLabel.text = habit.name
        nameLabel.textColor = habit.color
        completeButton.layer.borderColor = habit.color.cgColor
        dateLabel.text = habit.dateString
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        
        if habit.isAlreadyTakenToday {
            completeButton.backgroundColor = habit.color
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeButton.tintColor = .white
        } else {
            completeButton.backgroundColor = .clear
            completeButton.setImage(nil, for: .normal)
            completeButton.tintColor = habit.color
        }
    }
}
