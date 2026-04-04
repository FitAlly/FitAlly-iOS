//
//  PurposeViewController.swift
//  FitAlly
//
//  Created by 차지용 on 3/30/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class PurposeViewController: UIViewController, DesiginProtocolBind {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Top UI
    private let progressLabel = UILabel().then {
        $0.text = "설정 진행 중"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
    }
    
    private let stepLabel = UILabel().then {
        $0.text = "1/2"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .white
    }
    
    private let progressBarContainer = UIView().then {
        $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        $0.layer.cornerRadius = 2
    }
    
    private let progressBarActive = UIView().then {
        $0.backgroundColor = UIColor(named: "#00D3F3")
        $0.layer.cornerRadius = 2
    }
    
    // MARK: - Header UI
    private let mainIcon = UIImageView().then {
        $0.image = UIImage(named: "목적")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor(named: "#00D3F3")
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "운동 목적을 선택해주세요"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "회원님의 목표에 맞는 운동을 추천해드려요"
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .systemGray
        $0.textAlignment = .center
    }
    
    // MARK: - Purpose Cards
    private func createPurposeCard(title: String, imageName: String) -> UIButton {
        let button = UIButton().then {
            $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
            $0.layer.cornerRadius = 20
        }
        
        let iconView = UIImageView().then {
            $0.image = UIImage(named: imageName)
            $0.contentMode = .scaleAspectFit
            $0.tag = 100
        }
        
        let label = UILabel().then {
            $0.text = title
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .white
            $0.tag = 101
        }
        
        button.addSubview(iconView)
        button.addSubview(label)
        
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        return button
    }
    
    private lazy var muscleCard = createPurposeCard(title: "근육 키우기", imageName: "근육")
    private lazy var staminaCard = createPurposeCard(title: "체력 키우기", imageName: "체력")
    private lazy var dietCard = createPurposeCard(title: "다이어트", imageName: "다이어트")
    private lazy var academyCard = createPurposeCard(title: "입시", imageName: "학업")
    
    private let cardStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
        $0.distribution = .fillEqually
    }
    
    private let topRowStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.distribution = .fillEqually
    }
    
    private let bottomRowStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.distribution = .fillEqually
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.isEnabled = false
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    // MARK: - Protocol Conformity
    func configureUI() {
        view.backgroundColor = .black
    }
    
    func configureHierarchy() {
        view.addSubview(progressLabel)
        view.addSubview(stepLabel)
        view.addSubview(progressBarContainer)
        progressBarContainer.addSubview(progressBarActive)
        
        view.addSubview(mainIcon)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        
        view.addSubview(cardStackView)
        cardStackView.addArrangedSubview(topRowStack)
        cardStackView.addArrangedSubview(bottomRowStack)
        
        topRowStack.addArrangedSubview(muscleCard)
        topRowStack.addArrangedSubview(staminaCard)
        
        bottomRowStack.addArrangedSubview(dietCard)
        bottomRowStack.addArrangedSubview(academyCard)
        
        view.addSubview(nextButton)
    }
    
    func configureLayout() {
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(24)
        }
        
        stepLabel.snp.makeConstraints { make in
            make.centerY.equalTo(progressLabel)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        progressBarContainer.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(4)
        }
        
        progressBarActive.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        mainIcon.snp.makeConstraints { make in
            make.top.equalTo(progressBarContainer.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainIcon.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        cardStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(320)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(cardStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
    
    func bind() {
        let cards = [muscleCard, staminaCard, dietCard, academyCard]
        
        cards.forEach { card in
            card.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.toggleCardSelection(card)
                    self?.updateNextButtonState()
                })
                .disposed(by: disposeBag)
        }
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let levelVC = LevelViewController()
                levelVC.modalPresentationStyle = .fullScreen
                self?.present(levelVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func toggleCardSelection(_ button: UIButton) {
        button.isSelected.toggle()
        
        let isSelected = button.isSelected
        let brandColor = UIColor(named: "#00D3F3") ?? .cyan
        
        UIView.animate(withDuration: 0.2) {
            button.backgroundColor = isSelected ? brandColor : UIColor(white: 0.1, alpha: 1.0)
            
            if let icon = button.viewWithTag(100) as? UIImageView {
                icon.tintColor = isSelected ? .black : .white
            }
            if let label = button.viewWithTag(101) as? UILabel {
                label.textColor = isSelected ? .black : .white
            }
        }
    }
    
    private func updateNextButtonState() {
        let cards = [muscleCard, staminaCard, dietCard, academyCard]
        let hasSelection = cards.contains { $0.isSelected }
        let brandColor = UIColor(named: "#00D3F3") ?? .cyan
        let disabledColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
        
        UIView.animate(withDuration: 0.3) {
            self.nextButton.isEnabled = hasSelection
            self.nextButton.backgroundColor = hasSelection ? brandColor : disabledColor
            self.nextButton.setTitleColor(hasSelection ? .black : .white, for: .normal)
        }
    }
}
