//
//  CertificationViewController.swift
//  FitAlly
//
//  Created by 차지용 on 3/30/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class CertificationViewController: UIViewController, DesiginProtocolBind {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let backButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        $0.setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
        $0.tintColor = .white
    }
    
    private let emailIconContainer = UIView().then {
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 20
    }
    
    private let emailIcon = UIImageView().then {
        $0.image = UIImage(named: "e-mail")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor(named: "#00D3F3")
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "인증 코드 입력"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "으로 전송된 인증 코드를 입력해주세요"
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .systemGray
        $0.textAlignment = .center
    }
    
    private let codeLabel = UILabel().then {
        $0.text = "인증 코드"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
    }
    
    private let timerLabel = UILabel().then {
        $0.text = "2:58"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = UIColor(named: "#00D3F3")
    }
    
    private let codeTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "6자리 코드 입력",
            attributes: [.foregroundColor: UIColor.systemGray]
        )
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 15
        $0.textColor = .white
        $0.setLeftPaddingPoints(20)
        $0.keyboardType = .numberPad
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.isEnabled = false
    }
    
    private let resendButton = UIButton().then {
        $0.setTitle("인증 코드 재전송", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
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
        view.addSubview(backButton)
        view.addSubview(emailIconContainer)
        emailIconContainer.addSubview(emailIcon)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(codeLabel)
        view.addSubview(timerLabel)
        view.addSubview(codeTextField)
        view.addSubview(confirmButton)
        view.addSubview(resendButton)
    }
    
    func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }
        
        emailIconContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        
        emailIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailIconContainer.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(24)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(codeLabel)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        resendButton.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
            
        codeTextField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .subscribe(onNext: { [weak self] hasText in
                let brandColor = UIColor(named: "#00D3F3") ?? .cyan
                let disabledColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
                
                self?.confirmButton.isEnabled = hasText
                self?.confirmButton.backgroundColor = hasText ? brandColor : disabledColor
                self?.confirmButton.setTitleColor(hasText ? .black : .white, for: .normal)
            })
            .disposed(by: disposeBag)

        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let newPasswordVC = NewPasswordViewController()
                newPasswordVC.modalPresentationStyle = .fullScreen
                self?.present(newPasswordVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
