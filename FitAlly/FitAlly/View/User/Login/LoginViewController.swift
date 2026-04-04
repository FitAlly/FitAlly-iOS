//
//  LoginViewController.swift
//  FitAlly
//
//  Created by 차지용 on 3/25/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import AuthenticationServices

class LoginViewController: UIViewController, DesiginProtocol {
    
    private let disposeBag = DisposeBag()
    private var isLoginMode = false
    
    // MARK: - Common UI
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "FitAlly"
        $0.font = .systemFont(ofSize: 42, weight: .bold)
        $0.textColor = .white
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "함께 운동하며 성장하는 피트니스 커뮤니티"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .systemGray
    }
    
    // MARK: - Containers
    private let startContainerView = UIView().then {
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 24
    }
    
    private let loginContainerView = UIView().then {
        $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        $0.layer.cornerRadius = 24
        $0.alpha = 0
        $0.isHidden = true
    }
    
    // MARK: - Social Login (Unified)
    private let socialStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white).then {
        $0.cornerRadius = 8
    }
    
    private let kakaoLoginButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "kakao_login"), for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let naverLoginButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "naver_login"), for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    // MARK: - Start Mode UI
    private let emailSignUpButton = UIButton().then {
        $0.setTitle("이메일로 가입하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(named: "#00D3F3")
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let startSeparatorContainer = UIView()
    private let startLeftLine = UIView().then { $0.backgroundColor = .systemGray4 }
    private let startSeparatorLabel = UILabel().then {
        $0.text = "또는"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
    }
    private let startRightLine = UIView().then { $0.backgroundColor = .systemGray4 }
    
    // MARK: - Login Mode UI
    private let idTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "아이디를 입력하세요",
            attributes: [.foregroundColor: UIColor.systemGray]
        )
        $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        $0.layer.cornerRadius = 12
        $0.textColor = .white
        $0.setLeftPaddingPoints(45)
        let icon = UIImageView(image: UIImage(named: "e-mail")).then { $0.contentMode = .scaleAspectFit }
        $0.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    private let pwTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 입력하세요",
            attributes: [.foregroundColor: UIColor.systemGray]
        )
        $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        $0.layer.cornerRadius = 12
        $0.textColor = .white
        $0.isSecureTextEntry = true
        $0.setLeftPaddingPoints(45)
        let icon = UIImageView(image: UIImage(named: "rock")).then { $0.contentMode = .scaleAspectFit }
        $0.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(named: "#00D3F3")
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let loginSeparatorContainer = UIView()
    
    private let findPwButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(UIColor(named: "#00D3F3"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.alpha = 0
        $0.isHidden = true
    }
    
    // MARK: - Footer UI (Shared)
    private let footerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private let footerTextLabel = UILabel().then {
        $0.text = "이미 계정이 있으신가요?"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
    }
    
    private let footerActionButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(UIColor(named: "#00D3F3"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func bind() {
        footerActionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleLoginMode()
            })
            .disposed(by: disposeBag)
            
        emailSignUpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let joinVC = JoinViewController()
                joinVC.modalPresentationStyle = .fullScreen
                self?.present(joinVC, animated: true)
            })
            .disposed(by: disposeBag)
            
        findPwButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let findVC = PasswordFindViewController()
                findVC.modalPresentationStyle = .fullScreen
                self?.present(findVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func toggleLoginMode() {
        isLoginMode.toggle()
        let isLogin = isLoginMode
        
        UIView.animate(withDuration: 0.3) {
            // Toggle Containers
            self.startContainerView.alpha = isLogin ? 0 : 1
            self.startContainerView.isHidden = isLogin
            
            self.loginContainerView.alpha = isLogin ? 1 : 0
            self.loginContainerView.isHidden = !isLogin
            
            self.findPwButton.alpha = isLogin ? 1 : 0
            self.findPwButton.isHidden = !isLogin
            
            // Move socialStackView to active container
            if isLogin {
                self.loginContainerView.addSubview(self.socialStackView)
            } else {
                self.startContainerView.addSubview(self.socialStackView)
            }
            
            self.socialStackView.snp.remakeConstraints { make in
                let separator = isLogin ? self.loginSeparatorContainer : self.startSeparatorContainer
                make.top.equalTo(separator.snp.bottom).offset(24)
                make.leading.trailing.equalToSuperview().inset(24)
                make.bottom.equalToSuperview().offset(-30)
            }
            
            // Update Footer text
            self.footerTextLabel.text = isLogin ? "계정이 없으신가요?" : "이미 계정이 있으신가요?"
            self.footerActionButton.setTitle(isLogin ? "회원가입" : "로그인", for: .normal)
            
            // Update Logo Position
            self.logoImageView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(isLogin ? 60 : 120)
                make.size.equalTo(isLogin ? 70 : 100)
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    func configureHierarchy() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        
        // Start Container
        view.addSubview(startContainerView)
        startContainerView.addSubview(emailSignUpButton)
        startContainerView.addSubview(startSeparatorContainer)
        startSeparatorContainer.addSubview(startLeftLine)
        startSeparatorContainer.addSubview(startSeparatorLabel)
        startSeparatorContainer.addSubview(startRightLine)
        
        // Login Container
        view.addSubview(loginContainerView)
        loginContainerView.addSubview(idTextField)
        loginContainerView.addSubview(pwTextField)
        loginContainerView.addSubview(loginButton)
        loginContainerView.addSubview(loginSeparatorContainer)
        
        let lLine = UIView().then { $0.backgroundColor = .darkGray }
        let rLine = UIView().then { $0.backgroundColor = .darkGray }
        let sLabel = UILabel().then { $0.text = "또는"; $0.font = .systemFont(ofSize: 12); $0.textColor = .darkGray }
        loginSeparatorContainer.addSubview(lLine)
        loginSeparatorContainer.addSubview(sLabel)
        loginSeparatorContainer.addSubview(rLine)
        
        lLine.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.trailing.equalTo(sLabel.snp.leading).offset(-10)
            make.height.equalTo(1)
        }
        sLabel.snp.makeConstraints { make in make.center.equalToSuperview() }
        rLine.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.leading.equalTo(sLabel.snp.trailing).offset(10)
            make.height.equalTo(1)
        }
        
        // Unified Social Login (Initially in startContainerView)
        startContainerView.addSubview(socialStackView)
        socialStackView.addArrangedSubview(appleLoginButton)
        socialStackView.addArrangedSubview(kakaoLoginButton)
        socialStackView.addArrangedSubview(naverLoginButton)
        
        // Footer (Always outside containers)
        view.addSubview(footerStackView)
        footerStackView.addArrangedSubview(footerTextLabel)
        footerStackView.addArrangedSubview(footerActionButton)
        
        view.addSubview(findPwButton)
    }
    
    func configureUI() {
        view.backgroundColor = .black
    }
    
    func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // Start Container
        startContainerView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(socialStackView.snp.bottom).offset(30)
        }
        
        emailSignUpButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        startSeparatorContainer.snp.makeConstraints { make in
            make.top.equalTo(emailSignUpButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        startSeparatorLabel.snp.makeConstraints { make in make.center.equalToSuperview() }
        startLeftLine.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.trailing.equalTo(startSeparatorLabel.snp.leading).offset(-10)
            make.height.equalTo(1)
        }
        startRightLine.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.leading.equalTo(startSeparatorLabel.snp.trailing).offset(10)
            make.height.equalTo(1)
        }
        
        socialStackView.snp.makeConstraints { make in
            make.top.equalTo(startSeparatorContainer.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        appleLoginButton.snp.makeConstraints { make in make.height.equalTo(54) }
        kakaoLoginButton.snp.makeConstraints { make in make.height.equalTo(54) }
        naverLoginButton.snp.makeConstraints { make in make.height.equalTo(54) }
        
        // Login Container
        loginContainerView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(socialStackView.snp.bottom).offset(30)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        loginSeparatorContainer.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        // Shared Footer
        footerStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }
        
        findPwButton.snp.makeConstraints { make in
            make.top.equalTo(loginContainerView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}


