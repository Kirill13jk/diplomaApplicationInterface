import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProgressCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Всё получится!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .systemPurple
        progressView.layer.cornerRadius = 6
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(progressLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            progressLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressBar.heightAnchor.constraint(equalToConstant: 10)
            

        ])
    }
    
    func updateProgress() {
        let progress = HabitsStore.shared.todayProgress
        progressBar.setProgress(progress, animated: true)
        progressLabel.text = "\(Int(progress * 100))%"
    }
}
