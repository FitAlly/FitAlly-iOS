//
//  ExerciseViewController.swift
//  FitAlly
//
//  Created by 차지용 on 4/5/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ExerciseViewController: UIViewController, DesiginProtocol {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .black
        $0.alwaysBounceVertical = true
    }
    
    private let contentView = UIView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    // Header
    private let headerView = UIView().then { $0.backgroundColor = .black }
    private let logoIcon = UIImageView().then {
        $0.image = UIImage(named: "Icon")
        $0.contentMode = .scaleAspectFit
    }
    
    private let logoTitle = UILabel().then {
        $0.text = "FitAlly"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .white
    }
    
    private let chatButton = UIButton().then {
        $0.setImage(UIImage(named: "message"), for: .normal)
    }
    
    private let chatBadge = UILabel().then {
        $0.text = "3"
        $0.font = .systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .black
        $0.backgroundColor = UIColor(named: "#00D3F3")
        $0.layer.cornerRadius = 8; $0.clipsToBounds = true; $0.textAlignment = .center
    }
    
    private let notificationButton = UIButton().then {
        $0.setImage(UIImage(named: "알림"), for: .normal)
    }
    
    private let notificationBadge = UILabel().then {
        $0.text = "5"
        $0.font = .systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .black
        $0.backgroundColor = UIColor(named: "#00D3F3")
        $0.layer.cornerRadius = 8; $0.clipsToBounds = true; $0.textAlignment = .center
    }
    
    // Floating Button
    private let fabButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = .black
        $0.backgroundColor = UIColor(named: "#00D3F3")
        $0.layer.cornerRadius = 28
    }

    // Tab Bar (Custom)
    private let customTabBar = UIView().then {
        $0.backgroundColor = .black
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.darkGray.cgColor
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHierarchy()
        configureLayout()
    }
    
    func configureUI() {
        view.backgroundColor = .black
    }
    
    func configureHierarchy() {
        view.addSubview(headerView)
        [logoIcon, logoTitle, chatButton, chatBadge, notificationButton, notificationBadge].forEach { headerView.addSubview($0) }
        
        view.addSubview(customTabBar)
        setupTabBarItems()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Sections
        stackView.addArrangedSubview(createMotivationCard())
        
        let routineHeader = createSectionHeader(title: "나의 운동 루틴", count: "2개", moreText: "더보기")
        stackView.addArrangedSubview(routineHeader)
        stackView.addArrangedSubview(createMyRoutineCard())
        stackView.addArrangedSubview(createPageIndicator())
        
        stackView.addArrangedSubview(createAIRecommendedSection())
        
        let allHeader = createSectionHeader(title: "모든 운동", moreText: "전체보기")
        stackView.addArrangedSubview(allHeader)
        stackView.addArrangedSubview(createAllExerciseList())
        
        view.addSubview(fabButton)
    }
    
    func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview(); make.height.equalTo(60)
        }
        logoIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20); make.centerY.equalToSuperview(); make.size.equalTo(44)
        }
        logoTitle.snp.makeConstraints { make in
            make.leading.equalTo(logoIcon.snp.trailing).offset(10); make.centerY.equalToSuperview()
        }
        notificationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20); make.centerY.equalToSuperview(); make.size.equalTo(24)
        }
        notificationBadge.snp.makeConstraints { make in
            make.top.equalTo(notificationButton).offset(-6); make.trailing.equalTo(notificationButton).offset(8); make.size.equalTo(16)
        }
        chatButton.snp.makeConstraints { make in
            make.trailing.equalTo(notificationButton.snp.leading).offset(-24); make.centerY.equalToSuperview(); make.size.equalTo(24)
        }
        chatBadge.snp.makeConstraints { make in
            make.top.equalTo(chatButton).offset(-6); make.trailing.equalTo(chatButton).offset(8); make.size.equalTo(16)
        }
        
        customTabBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview(); make.height.equalTo(90)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview(); make.bottom.equalTo(customTabBar.snp.top)
        }
        contentView.snp.makeConstraints { make in make.edges.equalToSuperview(); make.width.equalToSuperview() }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10); make.leading.trailing.equalToSuperview().inset(20); make.bottom.equalToSuperview().offset(-20)
        }
        
        fabButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20); make.bottom.equalTo(customTabBar.snp.top).offset(-20); make.size.equalTo(56)
        }
        
        fabButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let routineAddVC = RoutineAddViewController()
                routineAddVC.modalPresentationStyle = .overFullScreen
                routineAddVC.modalTransitionStyle = .crossDissolve
                self?.present(routineAddVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Section Creators
    private func createMotivationCard() -> UIView {
        let brandCyan = UIColor(named: "#00D3F3") ?? .cyan
        let card = UIView().then {
            $0.backgroundColor = brandCyan.withAlphaComponent(0.05) // Figma 5%
            $0.layer.cornerRadius = 24
            $0.layer.borderWidth = 1
            $0.layer.borderColor = brandCyan.withAlphaComponent(0.3).cgColor // Figma 30%
        }
        let icon = UILabel().then {
            $0.text = "💪"
            $0.font = .systemFont(ofSize: 45)
            $0.textAlignment = .center
        }
        let lb1 = UILabel().then { $0.text = "오늘의 동기부여"; $0.font = .systemFont(ofSize: 14); $0.textColor = .gray }
        let lb2 = UILabel().then { $0.text = "FitAlly"; $0.font = .systemFont(ofSize: 16, weight: .bold); $0.textColor = UIColor(named: "#00D3F3") }
        let lb3 = UILabel().then { $0.text = "오늘 흘린 땀 한 방울이\n내일의 근육이 됩니다"; $0.font = .systemFont(ofSize: 22, weight: .bold); $0.textColor = .white; $0.numberOfLines = 2 }
        let refresh = UIImageView(image: UIImage(systemName: "arrow.clockwise")).then { $0.tintColor = .gray }
        
        [icon, lb1, lb2, lb3, refresh].forEach { card.addSubview($0) }
        card.snp.makeConstraints { make in make.height.equalTo(190) }
        icon.snp.makeConstraints { make in make.top.leading.equalToSuperview().offset(24); make.size.equalTo(54) }
        lb1.snp.makeConstraints { make in make.top.equalToSuperview().offset(26); make.leading.equalTo(icon.snp.trailing).offset(16) }
        lb2.snp.makeConstraints { make in make.top.equalTo(lb1.snp.bottom).offset(4); make.leading.equalTo(lb1) }
        lb3.snp.makeConstraints { make in make.top.equalTo(icon.snp.bottom).offset(20); make.leading.trailing.equalToSuperview().inset(24) }
        refresh.snp.makeConstraints { make in make.top.trailing.equalToSuperview().inset(24); make.size.equalTo(18) }
        return card
    }
    
    private func createSectionHeader(title: String, count: String? = nil, moreText: String) -> UIView {
        let view = UIView()
        let tLabel = UILabel().then { $0.text = title; $0.font = .systemFont(ofSize: 22, weight: .bold); $0.textColor = .white }
        view.addSubview(tLabel); tLabel.snp.makeConstraints { make in make.leading.centerY.equalToSuperview() }
        
        if let c = count {
            let badge = UILabel().then {
                $0.text = c; $0.font = .systemFont(ofSize: 12, weight: .medium); $0.textColor = .lightGray
                $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0); $0.layer.cornerRadius = 11; $0.clipsToBounds = true; $0.textAlignment = .center
            }
            view.addSubview(badge); badge.snp.makeConstraints { make in make.leading.equalTo(tLabel.snp.trailing).offset(8); make.centerY.equalToSuperview(); make.width.equalTo(38); make.height.equalTo(22) }
        }
        
        let more = UIButton().then {
            $0.setTitle(moreText, for: .normal); $0.setTitleColor(.white, for: .normal); $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            let icon = UIImageView(image: UIImage(systemName: "chevron.right")).then { $0.tintColor = .white }
            $0.addSubview(icon); icon.snp.makeConstraints { make in make.centerY.equalToSuperview(); make.trailing.equalToSuperview(); make.size.equalTo(14) }
        }
        view.addSubview(more); more.snp.makeConstraints { make in make.trailing.centerY.equalToSuperview(); make.width.equalTo(75) }
        view.snp.makeConstraints { make in make.height.equalTo(40) }
        return view
    }
    
    private func createMyRoutineCard() -> UIView {
        let card = UIView().then { $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0); $0.layer.cornerRadius = 24 }
        let title = UILabel().then { $0.text = "초보자를 위한 상체 루틴"; $0.font = .systemFont(ofSize: 20, weight: .bold); $0.textColor = .white }
        let ai = UILabel().then { $0.text = "✨ AI"; $0.font = .systemFont(ofSize: 12, weight: .bold); $0.textColor = .black; $0.backgroundColor = UIColor(named: "#00D3F3"); $0.layer.cornerRadius = 11; $0.clipsToBounds = true; $0.textAlignment = .center }
        [title, ai].forEach { card.addSubview($0) }
        title.snp.makeConstraints { make in make.top.leading.equalToSuperview().offset(24) }
        ai.snp.makeConstraints { make in make.centerY.equalTo(title); make.leading.equalTo(title.snp.trailing).offset(10); make.width.equalTo(54); make.height.equalTo(22) }
        
        let info = UIStackView().then { $0.axis = .horizontal; $0.spacing = 16 }
        card.addSubview(info)
        info.snp.makeConstraints { make in make.top.equalTo(title.snp.bottom).offset(12); make.leading.equalToSuperview().offset(24) }
        info.addArrangedSubview(createInfoItem(icon: "timer", text: "30분"))
        info.addArrangedSubview(createEmojiInfoItem(emoji: "🔥", text: "250 kcal"))
        info.addArrangedSubview(createEmojiInfoItem(emoji: "💪", text: "4가지 운동"))
        
        let list = UIStackView().then { $0.axis = .vertical; $0.spacing = 10 }
        card.addSubview(list)
        [("벤치 프레스", "3세트 x 10회"), ("인클라인 벤치 프레스", "3세트 x 12회"), ("풀업", "3세트 x 8회")].enumerated().forEach { i, data in
            let row = createRoutineRow(index: i+1, name: data.0, detail: data.1)
            list.addArrangedSubview(row)
        }
        list.snp.makeConstraints { make in make.top.equalTo(info.snp.bottom).offset(24); make.leading.trailing.equalToSuperview().inset(20) }
        
        let more = UILabel().then { $0.text = "+1개 더보기"; $0.font = .systemFont(ofSize: 14); $0.textColor = .gray; $0.textAlignment = .center }
        card.addSubview(more); more.snp.makeConstraints { make in make.top.equalTo(list.snp.bottom).offset(16); make.centerX.equalToSuperview() }
        
        let start = UIButton().then {
            $0.backgroundColor = UIColor(named: "#00D3F3"); $0.layer.cornerRadius = 16
            let stack = UIStackView().then { $0.axis = .horizontal; $0.spacing = 8; $0.isUserInteractionEnabled = false }
            let icon = UIImageView(image: UIImage(systemName: "dumbbell.fill")).then { $0.tintColor = .black }
            let lb = UILabel().then { $0.text = "루틴 시작하기"; $0.font = .systemFont(ofSize: 16, weight: .bold); $0.textColor = .black }
            stack.addArrangedSubview(icon); stack.addArrangedSubview(lb); $0.addSubview(stack); stack.snp.makeConstraints { make in make.center.equalToSuperview() }
        }
        card.addSubview(start); start.snp.makeConstraints { make in make.top.equalTo(more.snp.bottom).offset(16); make.leading.trailing.equalToSuperview().inset(20); make.height.equalTo(56); make.bottom.equalToSuperview().offset(-24) }
        return card
    }
    
    private func createAIRecommendedSection() -> UIView {
        let container = UIView()
        let title = UILabel().then { $0.text = "✨ AI 추천 운동"; $0.font = .systemFont(ofSize: 22, weight: .bold); $0.textColor = .white }
        container.addSubview(title); title.snp.makeConstraints { make in make.top.leading.equalToSuperview() }
        
        let brandCyan = UIColor(named: "#00D3F3") ?? .cyan
        
        let sectionBox = UIView().then {
            $0.layer.cornerRadius = 24
            $0.layer.borderWidth = 1
            $0.layer.borderColor = brandCyan.withAlphaComponent(0.3).cgColor // Figma 30%
            $0.backgroundColor = brandCyan.withAlphaComponent(0.05) // Figma 5%
        }
        container.addSubview(sectionBox); sectionBox.snp.makeConstraints { make in make.top.equalTo(title.snp.bottom).offset(20); make.leading.trailing.bottom.equalToSuperview() }
        
        let cardStack = UIStackView().then { $0.axis = .vertical; $0.spacing = 20 }
        sectionBox.addSubview(cardStack); cardStack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(20) }
        
        cardStack.addArrangedSubview(createAICard(title: "초보자를 위한 상체 루틴", exercises: [("벤치 프레스", "3세트 x 10회"), ("인클라인 벤치 프레스", "3세트 x 12회"), ("풀업", "3세트 x 8회"), ("숄더 프레스", "3세트 x 10회")]))
        cardStack.addArrangedSubview(createAICard(title: "하체 근력 강화", exercises: [("스쿼트", "4세트 x 12회"), ("레그 프레스", "3세트 x 15회"), ("런지", "3세트 x 12회"), ("데드리프트", "3세트 x 10회")], isLeg: true))
        
        let refresh = UIButton().then {
            $0.backgroundColor = .black.withAlphaComponent(0.5); $0.layer.cornerRadius = 12; $0.layer.borderWidth = 1; $0.layer.borderColor = UIColor.darkGray.cgColor
            let stack = UIStackView().then { $0.axis = .horizontal; $0.spacing = 8; $0.isUserInteractionEnabled = false }
            let icon = UIImageView(image: UIImage(systemName: "arrow.clockwise")).then { $0.tintColor = .white }
            let lb = UILabel().then { $0.text = "다른 추천 보기"; $0.font = .systemFont(ofSize: 14, weight: .bold); $0.textColor = .white }
            stack.addArrangedSubview(icon); stack.addArrangedSubview(lb); $0.addSubview(stack); stack.snp.makeConstraints { make in make.center.equalToSuperview() }
        }
        cardStack.addArrangedSubview(refresh); refresh.snp.makeConstraints { make in make.height.equalTo(50) }
        
        return container
    }
    
    private func createAICard(title: String, exercises: [(String, String)], isLeg: Bool = false) -> UIView {
        let card = UIView().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Figma Black 50%
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        }
        let tLb = UILabel().then { $0.text = title; $0.font = .systemFont(ofSize: 18, weight: .bold); $0.textColor = .white }
        let badge = UILabel().then { $0.text = "추천"; $0.font = .systemFont(ofSize: 12, weight: .bold); $0.textColor = .black; $0.backgroundColor = UIColor(named: "#00D3F3"); $0.layer.cornerRadius = 11; $0.clipsToBounds = true; $0.textAlignment = .center }
        [tLb, badge].forEach { card.addSubview($0) }
        tLb.snp.makeConstraints { make in make.top.leading.equalToSuperview().offset(20) }
        badge.snp.makeConstraints { make in make.centerY.equalTo(tLb); make.trailing.equalToSuperview().offset(-20); make.width.equalTo(54); make.height.equalTo(22) }
        
        let info = UILabel().then { $0.text = "🕒 30분  🔥 250 kcal"; $0.font = .systemFont(ofSize: 13); $0.textColor = .gray }
        card.addSubview(info); info.snp.makeConstraints { make in make.top.equalTo(tLb.snp.bottom).offset(8); make.leading.equalTo(tLb) }
        
        let list = UIStackView().then { $0.axis = .vertical; $0.spacing = 12 }
        card.addSubview(list); list.snp.makeConstraints { make in make.top.equalTo(info.snp.bottom).offset(20); make.leading.trailing.equalToSuperview().inset(20) }
        exercises.forEach { data in
            let row = UIView()
            let icon = UILabel().then { $0.text = isLeg ? "🦵" : "💪"; $0.font = .systemFont(ofSize: 18); $0.textAlignment = .center }
            let name = UILabel().then { $0.text = data.0; $0.font = .systemFont(ofSize: 15, weight: .bold); $0.textColor = .white }
            let set = UILabel().then { $0.text = data.1; $0.font = .systemFont(ofSize: 13); $0.textColor = .gray }
            [icon, name, set].forEach { row.addSubview($0) }
            icon.snp.makeConstraints { make in make.leading.centerY.equalToSuperview(); make.size.equalTo(20) }
            name.snp.makeConstraints { make in make.leading.equalTo(icon.snp.trailing).offset(10); make.centerY.equalToSuperview() }
            set.snp.makeConstraints { make in make.trailing.centerY.equalToSuperview() }
            list.addArrangedSubview(row); row.snp.makeConstraints { make in make.height.equalTo(20) }
        }
        
        let btnStack = UIStackView().then { $0.axis = .horizontal; $0.spacing = 12; $0.distribution = .fillEqually }
        card.addSubview(btnStack); btnStack.snp.makeConstraints { make in make.top.equalTo(list.snp.bottom).offset(20); make.leading.trailing.bottom.equalToSuperview().inset(20); make.height.equalTo(48) }
        
        let save = UIButton().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.2) // Figma Black 20%
            $0.layer.cornerRadius = 12
            $0.setTitle("  저장됨", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            $0.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            $0.tintColor = .gray
        }
        let start = UIButton().then {
            $0.backgroundColor = UIColor(named: "#00D3F3")
            $0.layer.cornerRadius = 12
            $0.setTitle("  시작하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            $0.setImage(UIImage(systemName: "play.fill"), for: .normal)
            $0.tintColor = .black
        }
        btnStack.addArrangedSubview(save); btnStack.addArrangedSubview(start)
        return card
    }
    
    private func createAllExerciseList() -> UIView {
        let list = UIStackView().then { $0.axis = .vertical; $0.backgroundColor = UIColor(white: 0.1, alpha: 1.0); $0.layer.cornerRadius = 24; $0.clipsToBounds = true }
        [("벤치 프레스", "가슴"), ("인클라인 벤치 프레스", "가슴"), ("딥스", "가슴"), ("스쿼트", "하체"), ("레그 프레스", "하체")].forEach { name, part in
            let row = UIView()
            let iconBg = UIView().then { $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0); $0.layer.cornerRadius = 12 }
            let icon = UILabel().then { $0.text = part == "하체" ? "🦵" : "💪"; $0.font = .systemFont(ofSize: 24); $0.textAlignment = .center }
            let nLb = UILabel().then { $0.text = name; $0.font = .systemFont(ofSize: 16, weight: .bold); $0.textColor = .white }
            let pLb = UILabel().then { $0.text = part; $0.font = .systemFont(ofSize: 13); $0.textColor = .gray }
            let chevron = UIImageView(image: UIImage(systemName: "chevron.right")).then { $0.tintColor = .gray }
            [iconBg, nLb, pLb, chevron].forEach { row.addSubview($0) }; iconBg.addSubview(icon)
            iconBg.snp.makeConstraints { make in make.leading.equalToSuperview().offset(16); make.centerY.equalToSuperview(); make.size.equalTo(48) }
            icon.snp.makeConstraints { make in make.center.equalToSuperview() }
            nLb.snp.makeConstraints { make in make.leading.equalTo(iconBg.snp.trailing).offset(16); make.top.equalTo(iconBg).offset(4) }
            pLb.snp.makeConstraints { make in make.leading.equalTo(nLb); make.top.equalTo(nLb.snp.bottom).offset(2) }
            chevron.snp.makeConstraints { make in make.trailing.equalToSuperview().offset(-16); make.centerY.equalToSuperview(); make.size.equalTo(14) }
            list.addArrangedSubview(row); row.snp.makeConstraints { make in make.height.equalTo(72) }
            let line = UIView().then { $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0) }; row.addSubview(line); line.snp.makeConstraints { make in make.leading.trailing.bottom.equalToSuperview(); make.height.equalTo(1) }
        }
        return list
    }
    
    // MARK: - Helper Methods
    private func createEmojiInfoItem(emoji: String, text: String) -> UIView {
        let v = UIView()
        let lb1 = UILabel().then { $0.text = emoji; $0.font = .systemFont(ofSize: 16); $0.textAlignment = .center }
        let lb2 = UILabel().then { $0.text = text; $0.font = .systemFont(ofSize: 14); $0.textColor = .gray }
        [lb1, lb2].forEach { v.addSubview($0) }
        lb1.snp.makeConstraints { make in make.leading.centerY.equalToSuperview(); make.size.equalTo(18) }
        lb2.snp.makeConstraints { make in make.leading.equalTo(lb1.snp.trailing).offset(6); make.trailing.centerY.equalToSuperview() }
        return v
    }

    private func createInfoItem(icon: String, text: String, color: UIColor = .systemGray, isAsset: Bool = false) -> UIView {
        let v = UIView(); let iv = UIImageView().then { if isAsset { $0.image = UIImage(named: icon) } else { $0.image = UIImage(systemName: icon); $0.tintColor = color }; $0.contentMode = .scaleAspectFit }
        let lb = UILabel().then { $0.text = text; $0.font = .systemFont(ofSize: 14); $0.textColor = .gray }
        [iv, lb].forEach { v.addSubview($0) }
        iv.snp.makeConstraints { make in make.leading.centerY.equalToSuperview(); make.size.equalTo(16) }
        lb.snp.makeConstraints { make in make.leading.equalTo(iv.snp.trailing).offset(6); make.trailing.centerY.equalToSuperview() }
        return v
    }
    
    private func createRoutineRow(index: Int, name: String, detail: String) -> UIView {
        let row = UIView().then { $0.backgroundColor = UIColor(white: 0.15, alpha: 1.0); $0.layer.cornerRadius = 12 }
        let n = UILabel().then { $0.text = "\(index)."; $0.font = .systemFont(ofSize: 14); $0.textColor = .gray }
        let ic = UILabel().then { $0.text = "💪"; $0.font = .systemFont(ofSize: 18); $0.textAlignment = .center }
        let nLb = UILabel().then { $0.text = name; $0.font = .systemFont(ofSize: 15, weight: .bold); $0.textColor = .white }
        let dLb = UILabel().then { $0.text = detail; $0.font = .systemFont(ofSize: 12); $0.textColor = .gray }
        [n, ic, nLb, dLb].forEach { row.addSubview($0) }
        n.snp.makeConstraints { make in make.leading.equalToSuperview().offset(12); make.centerY.equalToSuperview() }
        ic.snp.makeConstraints { make in make.leading.equalTo(n.snp.trailing).offset(8); make.centerY.equalToSuperview(); make.size.equalTo(20) }
        nLb.snp.makeConstraints { make in make.leading.equalTo(ic.snp.trailing).offset(8); make.centerY.equalToSuperview() }
        dLb.snp.makeConstraints { make in make.trailing.equalToSuperview().offset(-12); make.centerY.equalToSuperview() }
        row.snp.makeConstraints { make in make.height.equalTo(48) }
        return row
    }
    
    private func createPageIndicator() -> UIView {
        let v = UIStackView().then { $0.axis = .horizontal; $0.spacing = 8; $0.alignment = .center }
        let dot1 = UIView().then { $0.backgroundColor = UIColor(named: "#00D3F3"); $0.layer.cornerRadius = 4 }
        let dot2 = UIView().then { $0.backgroundColor = .darkGray; $0.layer.cornerRadius = 4 }
        v.addArrangedSubview(dot1); v.addArrangedSubview(dot2)
        dot1.snp.makeConstraints { make in make.size.equalTo(CGSize(width: 20, height: 8)) }
        dot2.snp.makeConstraints { make in make.size.equalTo(8) }
        let container = UIView(); container.addSubview(v); v.snp.makeConstraints { make in make.center.equalToSuperview(); make.top.bottom.equalToSuperview() }
        return container
    }

    private func setupTabBarItems() {
        let stack = UIStackView().then { $0.axis = .horizontal; $0.distribution = .fillEqually }
        customTabBar.addSubview(stack); stack.snp.makeConstraints { make in make.top.equalToSuperview().offset(12); make.leading.trailing.equalToSuperview() }
        
        let items = [("dumbbell.fill", "운동", true), ("calendar", "캘린더", false), ("heart", "매칭", false), ("person", "프로필", false)]
        items.forEach { icon, title, isActive in
            let v = UIStackView().then { $0.axis = .vertical; $0.spacing = 4; $0.alignment = .center }
            let iv = UIImageView(image: UIImage(systemName: icon)).then { $0.tintColor = isActive ? UIColor(named: "#00D3F3") : .gray }
            let lb = UILabel().then { $0.text = title; $0.font = .systemFont(ofSize: 10, weight: .bold); $0.textColor = isActive ? UIColor(named: "#00D3F3") : .gray }
            v.addArrangedSubview(iv); v.addArrangedSubview(lb)
            stack.addArrangedSubview(v)
        }
    }
}
