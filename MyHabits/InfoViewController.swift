import UIKit

class InfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Информация"
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "Привычка за 21 день"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let infoLabel = UILabel()
        infoLabel.text = """
        Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:
        
        1. Провести 1 день без обращения
        к старым привычкам, стараться вести себя так, как будто цель, загаданная
        в перспективу, находится на расстоянии шага.
        
        2. Выдержать 2 дня в прежнем состоянии самоконтроля.
        
        3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче,
        с чем еще предстоит серьезно бороться.
        
        4. Поздравить себя с прохождением первого серьезного порога в 21 день.
        За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.
        
        5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.
        
        6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.
        """
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
}
