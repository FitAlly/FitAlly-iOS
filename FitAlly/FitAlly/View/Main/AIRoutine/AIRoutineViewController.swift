//
//  AIRoutineViewController.swift
//  FitAlly
//
//  Created by 차지용 on 4/6/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class AIRoutineViewController: UIViewController, DesiginProtocol {
    
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
        $0.text = "AI 추천 루틴"
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
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let backButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        $0.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        $0.setTitle(" 뒤로", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .left
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
        
        [titleLabel, closeButton, divider, scrollView].forEach { containerView.addSubview($0) }
        
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(backButton)
        
        // Add Routine Cards
        contentStackView.addArrangedSubview(createAIRoutineCard(
            title: "초보자 풀바디 루틴",
            desc: "전신을 골고루 발달시키는 초보자용 프로그램",
            info: ("60분", "400 kcal", "5가지 운동"),
            exercises: [
                ("💪", "스쿼트", "3세트 x 12회 (20kg)"),
                ("💪", "벤치 프레스", "3세트 x 10회 (20kg)"),
                ("🔥", "데드리프트", "3세트 x 10회 (30kg)"),
                ("💪", "숄더 프레스", "3세트 x 10회 (10kg)"),
                ("🔥", "플랭크", "3세트 x 30회")
            ]
        ))
        
        contentStackView.addArrangedSubview(createAIRoutineCard(
            title: "상체 집중 루틴",
            desc: "가슴, 등, 어깨를 강화하는 상체 특화 프로그램",
            info: ("50분", "380 kcal", "5가지 운동"),
            exercises: [
                ("💪", "벤치 프레스", "4세트 x 10회 (30kg)"),
                ("💪", "인클라인 벤치 프레스", "3세트 x 12회 (25kg)"),
                ("🔥", "바벨 로우", "4세트 x 10회 (30kg)"),
                ("🔥", "풀업", "3세트 x 8회"),
                ("💪", "숄더 프레스", "3세트 x 12회 (15kg)")
            ]
        ))
        
        contentStackView.addArrangedSubview(createAIRoutineCard(
            title: "하체 강화 루틴",
            desc: "하체 근력과 파워를 기르는 전문 프로그램",
            info: ("55분", "450 kcal", "4가지 운동"),
            exercises: [
                ("🦵", "스쿼트", "5세트 x 8회 (50kg)"),
                ("🦵", "레그 프레스", "4세트 x 12회 (80kg)"),
                ("🦵", "런지", "3세트 x 12회 (20kg)"),
                ("🔥", "데드리프트", "4세트 x 8회 (60kg)")
            ]
        ))
    }
    
    func configureLayout() {
        dimView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24); make.leading.equalToSuperview().offset(24)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel); make.trailing.equalToSuperview().offset(-24); make.size.equalTo(24)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16); make.leading.trailing.equalToSuperview(); make.height.equalTo(1)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
            make.width.equalTo(scrollView).offset(-48)
        }
    }
    
    private func bind() {
        closeButton.rx.tap.subscribe(onNext: { [weak self] in self?.view.window?.rootViewController?.dismiss(animated: true) }).disposed(by: disposeBag)
        backButton.rx.tap.subscribe(onNext: { [weak self] in self?.dismiss(animated: true) }).disposed(by: disposeBag)
    }
    
    // MARK: - Routine Card Creator
    private func createAIRoutineCard(title: String, desc: String, info: (String, String, String), exercises: [(String, String, String)]) -> UIView {
        let brandCyan = UIColor(named: "#00D3F3") ?? .cyan
        let card = UIView().then {
            $0.backgroundColor = brandCyan.withAlphaComponent(0.05)
            $0.layer.cornerRadius = 24
            $0.layer.borderWidth = 1
            $0.layer.borderColor = brandCyan.withAlphaComponent(0.3).cgColor
        }
        
        let icon = UIImageView(image: UIImage(systemName: "sparkles")).then { $0.tintColor = brandCyan }
        let titleLb = UILabel().then { $0.text = title; $0.font = .systemFont(ofSize: 18, weight: .bold); $0.textColor = .white; $0.numberOfLines = 2 }
        let badge = UILabel().then { $0.text = "AI 추천"; $0.font = .systemFont(ofSize: 12, weight: .bold); $0.textColor = .black; $0.backgroundColor = brandCyan; $0.layer.cornerRadius = 11; $0.clipsToBounds = true; $0.textAlignment = .center }
        
        let descLb = UILabel().then { $0.text = desc; $0.font = .systemFont(ofSize: 13); $0.textColor = .gray; $0.numberOfLines = 2 }
        
        let infoStack = UIStackView().then { $0.axis = .horizontal; $0.spacing = 12; $0.distribution = .fillEqually }
        let info1 = createMiniInfo("timer", text: info.0)
        let info2 = createMiniInfo("flame.fill", text: info.1, color: .orange)
        let info3 = createMiniInfo("근육", text: info.2, isAsset: true)
        [info1, info2, info3].forEach { infoStack.addArrangedSubview($0) }
        
        let listStack = UIStackView().then { $0.axis = .vertical; $0.spacing = 10 }
        exercises.forEach { data in
            let row = UIView().then { $0.backgroundColor = .black.withAlphaComponent(0.3); $0.layer.cornerRadius = 12 }
            let eLb = UILabel().then { $0.text = data.0; $0.font = .systemFont(ofSize: 16) }
            let nLb = UILabel().then { $0.text = data.1; $0.font = .systemFont(ofSize: 14, weight: .bold); $0.textColor = .white }
            let dLb = UILabel().then { $0.text = data.2; $0.font = .systemFont(ofSize: 12); $0.textColor = .gray }
            [eLb, nLb, dLb].forEach { row.addSubview($0) }
            eLb.snp.makeConstraints { make in make.leading.equalToSuperview().offset(12); make.centerY.equalToSuperview() }
            nLb.snp.makeConstraints { make in make.leading.equalTo(eLb.snp.trailing).offset(10); make.centerY.equalToSuperview() }
            dLb.snp.makeConstraints { make in make.trailing.equalToSuperview().offset(-12); make.centerY.equalToSuperview() }
            listStack.addArrangedSubview(row); row.snp.makeConstraints { make in make.height.equalTo(44) }
        }
        
        let addBtn = UIButton().then {
            $0.backgroundColor = brandCyan; $0.layer.cornerRadius = 16
            $0.setTitle("이 루틴 추가하기", for: .normal); $0.setTitleColor(.black, for: .normal); $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        }
        
        [icon, titleLb, badge, descLb, infoStack, listStack, addBtn].forEach { card.addSubview($0) }
        
        icon.snp.makeConstraints { make in make.top.leading.equalToSuperview().offset(20); make.size.equalTo(20) }
        titleLb.snp.makeConstraints { make in make.top.equalTo(icon); make.leading.equalTo(icon.snp.trailing).offset(8); make.trailing.equalTo(badge.snp.leading).offset(-8) }
        badge.snp.makeConstraints { make in make.top.equalToSuperview().offset(20); make.trailing.equalToSuperview().offset(-20); make.width.equalTo(60); make.height.equalTo(22) }
        descLb.snp.makeConstraints { make in make.top.equalTo(titleLb.snp.bottom).offset(8); make.leading.equalTo(titleLb); make.trailing.equalToSuperview().offset(-20) }
        infoStack.snp.makeConstraints { make in make.top.equalTo(descLb.snp.bottom).offset(16); make.leading.trailing.equalToSuperview().inset(20) }
        listStack.snp.makeConstraints { make in make.top.equalTo(infoStack.snp.bottom).offset(20); make.leading.trailing.equalToSuperview().inset(20) }
        addBtn.snp.makeConstraints { make in make.top.equalTo(listStack.snp.bottom).offset(20); make.leading.trailing.bottom.equalToSuperview().inset(20); make.height.equalTo(48) }
        
        return card
    }
    
    private func createMiniInfo(_ icon: String, text: String, color: UIColor = .gray, isAsset: Bool = false) -> UIView {
        let v = UIView()
        let iv = UIImageView().then {
            if isAsset { $0.image = UIImage(named: icon) }
            else { $0.image = UIImage(systemName: icon); $0.tintColor = color }
            $0.contentMode = .scaleAspectFit
        }
        let lb = UILabel().then { $0.text = text; $0.font = .systemFont(ofSize: 12); $0.textColor = .white; $0.numberOfLines = 2; $0.textAlignment = .center }
        [iv, lb].forEach { v.addSubview($0) }
        iv.snp.makeConstraints { make in make.top.centerX.equalToSuperview(); make.size.equalTo(16) }
        lb.snp.makeConstraints { make in make.top.equalTo(iv.snp.bottom).offset(4); make.leading.trailing.bottom.equalToSuperview() }
        return v
    }
}
