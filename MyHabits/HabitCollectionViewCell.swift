import UIKit

protocol HabitCollectionViewCellDelegate: AnyObject {
    func habitCell(_ cell: HabitCollectionViewCell, didToggleCompletionFor habit: Habit)
    func habitCellDidTap(_ cell: HabitCollectionViewCell)
}

class HabitCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HabitCollectionViewCell"
    
    weak var delegate: HabitCollectionViewCellDelegate?
    
    private var habit: Habit?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completionCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupViews()
        setupConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
        
        let circleTapGesture = UITapGestureRecognizer(target: self, action: #selector(circleTapped))
        completionCircle.addGestureRecognizer(circleTapGesture)
        completionCircle.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(completionCircle)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: completionCircle.leadingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            counterLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30),
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            completionCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completionCircle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            completionCircle.widthAnchor.constraint(equalToConstant: 30),
            completionCircle.heightAnchor.constraint(equalToConstant: 30)
        ])
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
    }
    
    @objc private func cellTapped() {
        delegate?.habitCellDidTap(self)
    }
    
    @objc private func circleTapped() {
        guard let habit = habit else { return }
        delegate?.habitCell(self, didToggleCompletionFor: habit)
    }
    
    func configure(with habit: Habit) {
        self.habit = habit
        titleLabel.text = habit.name
        titleLabel.textColor = habit.color
        dateLabel.text = habit.dateString
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        completionCircle.layer.borderColor = habit.color.cgColor
        completionCircle.backgroundColor = habit.isAlreadyTakenToday ? habit.color : .clear
        if habit.isAlreadyTakenToday {
            let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmark.tintColor = .white
            checkmark.translatesAutoresizingMaskIntoConstraints = false
            completionCircle.addSubview(checkmark)
            NSLayoutConstraint.activate([
                checkmark.centerXAnchor.constraint(equalTo: completionCircle.centerXAnchor),
                checkmark.centerYAnchor.constraint(equalTo: completionCircle.centerYAnchor)
            ])
        } else {
            completionCircle.subviews.forEach { $0.removeFromSuperview() }
        }
    }
}
