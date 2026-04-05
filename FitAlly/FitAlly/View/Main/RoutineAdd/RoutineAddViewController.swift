//
//  RoutineAddViewController.swift
//  FitAlly
//
//  Created by 차지용 on 4/6/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class RoutineAddViewController: UIViewController, DesiginProtocol {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let dimView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "운동 루틴 추가"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .white
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
    }
    
    // AI Recommendation Card
    private let aiRoutineCard = UIButton().then {
        $0.backgroundColor = UIColor(named: "#00D3F3")?.withAlphaComponent(0.05)
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "#00D3F3")?.withAlphaComponent(0.3).cgColor
    }
    
    // Manual Creation Card
    private let manualRoutineCard = UIButton().then {
        $0.backgroundColor = UIColor(white: 0.18, alpha: 1.0)
        $0.layer.cornerRadius = 16
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    func configureUI() {
        view.backgroundColor = .clear
    }
    
    func configureHierarchy() {
        view.addSubview(dimView)
        view.addSubview(containerView)
        
        [titleLabel, closeButton, divider, aiRoutineCard, manualRoutineCard].forEach { containerView.addSubview($0) }
        
        setupAICardContent()
        setupManualCardContent()
    }
    
    func configureLayout() {
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(380)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(24)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-24)
            make.size.equalTo(24)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        aiRoutineCard.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(110)
        }
        
        manualRoutineCard.snp.makeConstraints { make in
            make.top.equalTo(aiRoutineCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(110)
        }
    }
    
    private func bind() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
            
        let tapGesture = UITapGestureRecognizer()
        dimView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        manualRoutineCard.rx.tap
            .subscribe(onNext: { [weak self] in
                let customRoutineVC = CustomRoutineViewController()
                customRoutineVC.modalPresentationStyle = .overFullScreen
                customRoutineVC.modalTransitionStyle = .crossDissolve
                self?.present(customRoutineVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    private func setupAICardContent() {
        let icon = UIImageView(image: UIImage(systemName: "sparkles")).then {
            $0.tintColor = UIColor(named: "#00D3F3")
            $0.contentMode = .scaleAspectFit
        }
        let title = UILabel().then {
            $0.text = "AI 추천 루틴"
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.textColor = .white
        }
        let desc = UILabel().then {
            $0.text = "AI가 만든 최적화된 운동 프로그램"
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .lightGray
        }
        
        [icon, title, desc].forEach { aiRoutineCard.addSubview($0) }
        
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(32)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        desc.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupManualCardContent() {
        let icon = UIImageView(image: UIImage(named: "Icon")).then {
            $0.contentMode = .scaleAspectFit
        }
        let title = UILabel().then {
            $0.text = "직접 만들기"
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.textColor = .white
        }
        let desc = UILabel().then {
            $0.text = "나만의 커스텀 운동 루틴 생성"
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .lightGray
        }
        
        [icon, title, desc].forEach { manualRoutineCard.addSubview($0) }
        
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(32)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        desc.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}
