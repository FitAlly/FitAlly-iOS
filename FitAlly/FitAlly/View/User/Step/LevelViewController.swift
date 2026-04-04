//
//  LevelViewController.swift
//  FitAlly
//
//  Created by 차지용 on 3/30/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class LevelViewController: UIViewController, DesiginProtocolBind {
    
    private let disposeBag = DisposeBag()
    private var selectedLevel: UIButton?
    
    // MARK: - Top UI
    private let progressLabel = UILabel().then {
        $0.text = "설정 진행 중"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
    }
    
    private let stepLabel = UILabel().then {
        $0.text = "2/2"
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
        $0.image = UIImage(named: "수준")
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "운동 수준을 알려주세요"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "회원님의 수준에 맞는 운동 강도를 제안해드려요"
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .systemGray
        $0.textAlignment = .center
    }
    
    // MARK: - Level List
    private func createLevelCard(title: String, description: String) -> UIButton {
        let button = UIButton().then {
            $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
            $0.layer.cornerRadius = 20
        }
        
        let iconContainer = UIView().then {
            $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
            $0.layer.cornerRadius = 20
            $0.isUserInteractionEnabled = false
            $0.tag = 100
        }
        
        let iconView = UIImageView().then {
            $0.image = UIImage(named: "단계")
            $0.contentMode = .scaleAspectFit
            $0.tag = 101
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .systemFont(ofSize: 16, weight: .bold)
            $0.textColor = .white
            $0.tag = 102
        }
        
        let descLabel = UILabel().then {
            $0.text = description
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .systemGray
            $0.tag = 103
        }
        
        button.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        button.addSubview(titleLabel)
        button.addSubview(descLabel)
        
        iconContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalTo(iconContainer.snp.trailing).offset(15)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-18)
        }
        
        return button
    }
    
    private lazy var beginnerCard = createLevelCard(title: "초보", description: "운동 경험이 거의 없어요")
    private lazy var intermediateCard = createLevelCard(title: "중급", description: "어느 정도 운동을 해봤어요")
    private lazy var advancedCard = createLevelCard(title: "고급", description: "운동 경험이 많아요")
    
    private let listStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
        $0.distribution = .fillEqually
    }
    
    // MARK: - Footer UI
    private let prevButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let doneButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
        $0.layer.cornerRadius = 12
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
        
        view.addSubview(listStackView)
        listStackView.addArrangedSubview(beginnerCard)
        listStackView.addArrangedSubview(intermediateCard)
        listStackView.addArrangedSubview(advancedCard)
        
        view.addSubview(prevButton)
        view.addSubview(doneButton)
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
            make.edges.equalToSuperview() // Full progress for step 2/2
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
        
        listStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        prevButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(80)
            make.height.equalTo(54)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.equalTo(prevButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(prevButton)
            make.height.equalTo(54)
        }
    }
    
    func bind() {
        let levelCards = [beginnerCard, intermediateCard, advancedCard]
        
        levelCards.forEach { card in
            card.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.selectLevel(card)
                })
                .disposed(by: disposeBag)
        }
        
        prevButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func selectLevel(_ target: UIButton) {
        let levelCards = [beginnerCard, intermediateCard, advancedCard]
        let brandColor = UIColor(named: "#00D3F3") ?? .cyan
        let darkBgColor = UIColor(white: 0.1, alpha: 1.0)
        
        UIView.animate(withDuration: 0.2) {
            levelCards.forEach { card in
                let isTarget = (card == target)
                card.backgroundColor = isTarget ? brandColor : darkBgColor
                
                // Update subviews
                if let iconContainer = card.viewWithTag(100) {
                    iconContainer.backgroundColor = isTarget ? UIColor.black.withAlphaComponent(0.1) : UIColor(white: 0.15, alpha: 1.0)
                }
                if let icon = card.viewWithTag(101) as? UIImageView {
                    icon.tintColor = isTarget ? .black : .white
                }
                if let title = card.viewWithTag(102) as? UILabel {
                    title.textColor = isTarget ? .black : .white
                }
                if let desc = card.viewWithTag(103) as? UILabel {
                    desc.textColor = isTarget ? .black.withAlphaComponent(0.7) : .systemGray
                }
            }
            
            // Enable and update Done button
            self.doneButton.isEnabled = true
            self.doneButton.backgroundColor = brandColor
            self.doneButton.setTitleColor(.black, for: .normal)
        }
    }
}
