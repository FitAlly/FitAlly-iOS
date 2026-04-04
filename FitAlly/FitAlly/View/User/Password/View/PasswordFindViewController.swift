//
//  PasswordFindViewController.swift
//  FitAlly
//
//  Created by 차지용 on 3/30/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class PasswordFindViewController: UIViewController, DesiginProtocolBind {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let backButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        $0.setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
        $0.tintColor = .white
    }
    
    private let lockIconContainer = UIView().then {
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 20
    }
    
    private let lockIcon = UIImageView().then {
        $0.image = UIImage(named: "rock")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor(named: "#00D3F3")
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "비밀번호 찾기"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "가입하신 이메일 주소를 입력하시면\n인증 코드를 보내드립니다"
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .systemGray
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "이메일 주소"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
    }
    
    private let emailTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "example@email.com",
            attributes: [.foregroundColor: UIColor.systemGray]
        )
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 15
        $0.textColor = .white
        $0.setLeftPaddingPoints(45)
        
        let icon = UIImageView(image: UIImage(named: "e-mail")).then {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .systemGray
        }
        $0.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    private let sendCodeButton = UIButton().then {
        $0.setTitle("인증 코드 받기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0) // Initially dark teal
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
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
        view.addSubview(lockIconContainer)
        lockIconContainer.addSubview(lockIcon)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(sendCodeButton)
    }
    
    func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }
        
        lockIconContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        
        lockIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(lockIconContainer.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        sendCodeButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
    
    func bind() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
            
        sendCodeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let certificationVC = CertificationViewController()
                certificationVC.modalPresentationStyle = .fullScreen
                self?.present(certificationVC, animated: true)
            })
            .disposed(by: disposeBag)
            
        // Enable button when email is not empty (simple check)
        emailTextField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .subscribe(onNext: { [weak self] hasText in
                let brandColor = UIColor(named: "#00D3F3") ?? .cyan
                let disabledColor = UIColor(red: 0.15, green: 0.35, blue: 0.4, alpha: 1.0)
                
                self?.sendCodeButton.isEnabled = hasText
                self?.sendCodeButton.backgroundColor = hasText ? brandColor : disabledColor
                self?.sendCodeButton.setTitleColor(hasText ? .black : .white, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
