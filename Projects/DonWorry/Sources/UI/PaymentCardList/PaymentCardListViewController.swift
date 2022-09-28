//
//  PaymentCardListViewController.swift
//  App
//
//  Created by Woody on 2022/08/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import UIKit
import BaseArchitecture
import ReactorKit
import RxCocoa
import RxSwift
import DesignSystem
import DonWorryExtensions
import RxDataSources
import FirebaseDynamicLinks
import SkeletonView

final class PaymentCardListViewController: BaseViewController, View {

    typealias Reactor = PaymentCardListReactor
    typealias DataSource = PaymentCardDiffableDataSource
    typealias Section = PaymentCardSection
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Section.Item>

    lazy var dataSource = DataSource(collectionView: collectionView)
    lazy var navigationBar: DWNavigationBar = DWNavigationBar(title: "", type: .image, rightButtonImageName: "ellipsis")
    lazy var spaceStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 4
        v.alignment = .center
        v.distribution = .fill
        return v
    }()
    lazy var spaceIDLabel: UILabel = {
        let v = UILabel()
        v.text = "정산방 ID : "
        v.font = .designSystem(weight: .regular, size: ._13)
        v.textColor = .designSystem(.grayC5C5C5)
        return v
    }()
    lazy var spaceIDCopyButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(.init(.btn_copy), for: .normal)
        return v
    }()
    lazy var startPaymentAlgorithmButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("정산 시작", for: .normal)
        v.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
        v.setTitleColor(.designSystem(.mainBlue), for: .normal)
        v.setBackgroundColor(.designSystem(.grayC5C5C5)!, for: .disabled)
        v.setTitleColor(.designSystem(.white), for: .disabled)
        v.backgroundColor = .designSystem(.lightBlue)
        return v
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.contentInset = UIEdgeInsets(top: 13, left: 0, bottom: 58 + 6 + 20, right: 0)
        v.register(PaymentCardCollectionViewCell.self)
        v.register(AddPaymentCardCollectionViewCell.self)
        v.register(ParticipantListCollectionViewCell.self)
        v.showsVerticalScrollIndicator = false
        return v
    }()
    lazy var floatingStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 10
        v.distribution = .equalSpacing
        v.alignment = .center
        return v
    }()
    lazy var shareLinkButton: DWButton = {
        let v = DWButton.create(.halfMainBlue)
        v.setTitle("링크 공유", for: .normal)
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15, weight: .bold))
        v.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration), for: .normal)
        v.semanticContentAttribute = .forceRightToLeft
        let imagePadding: CGFloat = 12
        v.titleEdgeInsets = .init(top: 0, left: -imagePadding, bottom: 0, right: imagePadding)
        v.contentEdgeInsets = .init(top: 0, left: imagePadding, bottom: 0, right: 0)
        v.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        v.addTarget(self, action: #selector(shareSpace), for: .touchUpInside)
        return v
    }()
    lazy var checkParticipatedButton: DWButton = {
        let v = DWButton.create(.halfLightBlue)
        v.setTitle("참석 확인", for: .normal)
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15, weight: .bold))
        v.setImage(UIImage(systemName: "checkmark", withConfiguration: configuration), for: .normal)
        v.semanticContentAttribute = .forceRightToLeft
        let imagePadding: CGFloat = 12
        v.titleEdgeInsets = .init(top: 0, left: -imagePadding, bottom: 0, right: imagePadding)
        v.contentEdgeInsets = .init(top: 0, left: imagePadding, bottom: 0, right: 0)
        v.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        v.tintColor = .designSystem(.white)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(popToSelf), name: .init("popToPaymentCardList"), object: nil)
    }
    
    // MARK: ShareSheet

    func showShareSheet(url: URL) {
        let promoText = "돈워리에서 정산할래요?" // 🔀 TEXT 변경필요
        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    // MARK: 공유하기
    @objc
    private func shareSpace() {
        
        // 1. URL Link 생성하기
        let spaceID = reactor?.currentState.space.shareID
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.don-worry.com"
        components.path =  "/space"
        
        let spaceShareQueryItem = URLQueryItem(name: "id", value: spaceID)
        components.queryItems = [spaceShareQueryItem]
        
        guard let linkParmater = components.url else { return }
        
        // 2. Full DynamicLink 생성하기
        guard let shareLink = DynamicLinkComponents.init(link: linkParmater, domainURIPrefix: "https://donworry.page.link") else {
            print("Full Dynamic Link Components 를 생성할 수 없습니다.")
            return
        }
        
        // iOS 관련설정
        // - App Bundle ID 설정
        if let myBundleId = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        // - App Store ID
        shareLink.iOSParameters?.appStoreID = "1643097323"
        // - 공유 개선을 위한 소셜 메타 태그
        let spaceTitle = reactor?.currentState.space.title
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "돈.워리에서 정산해요" // 🔀 변경필요
        shareLink.socialMetaTagParameters?.descriptionText = "💸\(spaceTitle!)에 참가해서 정산을 완료해보세요 " // 🔀 변경필요
        shareLink.socialMetaTagParameters?.imageURL = URL(string: "https://user-images.githubusercontent.com/63157395/190110193-0d6f49b9-b163-4fe4-845f-d650dd088d9f.png") // 🔀 변경필요
        //        guard let fullDynamicLink = shareLink.url else { return }
        
        // 3. 공유용 URL로 줄이기
        shareLink.shorten { [weak self] (url, warnings, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let warnings = warnings {
                for warning in warnings {
                    print(warning)
                }
            }
            guard let url = url else { return }
            self?.showShareSheet(url: url)
        }
    }
    
    @objc
    private func popToSelf() {
        self.navigationController?.popToViewController(self, animated: true)

    }

    func bind(reactor: Reactor) {
        self.render(reactor: reactor)
        self.dispatch(to: reactor)
    }

    private func dispatch(to reactor: Reactor) {
        self.rx.viewWillAppear.map { _ in .viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.rx.viewDidDisappear.map { _ in .viewDidDisappear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.navigationBar.leftItem.rx.tap.map { .didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.navigationBar.rightItem?.rx.tap.map { .didTapOptionButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.spaceIDCopyButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                UIPasteboard.general.string = String((reactor.currentState.space.shareID))
                DWToastFactory.show(message: "복사되었어요!")
            })
            .disposed(by: disposeBag)

        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        self.checkParticipatedButton.rx.tap.map { .didTapParticipatedButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected
            .compactMap { [weak self] in self?.collectionView.cellForItem(at: $0) as? PaymentCardCollectionViewCell }
            .map { .didTapPaymentCard($0.viewModel!) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected
            .compactMap { [weak self] in
                return self?.collectionView.cellForItem(at: $0) as? AddPaymentCardCollectionViewCell
            }.map { _ in .didTapAddPaymentCard }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.startPaymentAlgorithmButton.rx.tap
            .map { .didTapStartPaymentAlgorithmButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.collectionView.rx.itemSelected
            .compactMap { [weak self] in
                return self?.collectionView.cellForItem(at: $0) as? AddPaymentCardCollectionViewCell
            }.map { _ in .didTapAddPaymentCard }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func render(reactor: Reactor) {
        
        reactor.state.map { ($0.space, $0.isUserAdmin) }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (space, isUserAdmin) in
                self?.navigationBar.titleLabel?.text = space.title
                self?.startPaymentAlgorithmButton.isEnabled = space.status == "OPEN" && isUserAdmin
                self?.shareLinkButton.isHidden = !(space.status == "OPEN")
                self?.checkParticipatedButton.isHidden = !(space.status == "OPEN")
            }).disposed(by: disposeBag)

        reactor.state.map { $0.space.shareID }
            .map { "정산방 ID : \($0)" }
            .bind(to: spaceIDLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.sections }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] sections in
                print("업데이트합니당")
                self?.apply(sections: sections)
            }).disposed(by: disposeBag)

        // MARK: Pulse

        reactor.pulse(\.$step)
            .asDriver(onErrorJustReturn: PaymentCardListStep.none)
            .compactMap { $0 }
            .drive(onNext: { [weak self] step in
                self?.move(to: step)
            }).disposed(by: disposeBag)

        reactor.pulse(\.$error)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 as? PaymentCardListViewError }
            .subscribe(onNext: { [weak self] error in
                self?.showErrorToast(error)
            }).disposed(by: disposeBag)
    }

    private func showErrorToast(_ error: PaymentCardListViewError) {
        DWToastFactory.show(message: error.message, type: .error, duration: 3, completion: nil)
    }
}

extension PaymentCardListViewController {

    func apply(sections: [Section]) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            switch section {
            case .ParticipantCard(item: let models):
                snapshot.appendItems(models, toSection: section)
            case .PaymentCard(itmes: let models):
                snapshot.appendItems(models, toSection: section)
            case .AddPaymentCard:
                break
            }
        }
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: setUI

extension PaymentCardListViewController {

    private func setUI() {
        self.view.backgroundColor = .designSystem(.white)
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.spaceStackView)
        self.view.addSubview(self.startPaymentAlgorithmButton)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.floatingStackView)
        self.floatingStackView.addArrangedSubviews(self.shareLinkButton, self.checkParticipatedButton)
        self.spaceStackView.addArrangedSubviews(self.spaceIDLabel, self.spaceIDCopyButton)

        self.navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.spaceStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
        }
        self.spaceIDCopyButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.startPaymentAlgorithmButton.snp.leading).offset(-16)
            make.width.equalTo(47)
            make.height.equalTo(19)
        }
        self.startPaymentAlgorithmButton.snp.makeConstraints { make in
            make.width.equalTo(98)
            make.height.equalTo(34)
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalTo(self.spaceStackView)
        }
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.spaceIDLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.floatingStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(UIDevice.current.hasNotch ?  0 : 30)
            make.leading.trailing.equalToSuperview().inset(25)
        }

        self.startPaymentAlgorithmButton.roundCorners(14)
        self.collectionView.dataSource = dataSource
    }
}

// MARK: Routing

extension PaymentCardListViewController {
    private func move(to step: PaymentCardListStep) {
        switch step {
        case .pop:
            self.navigationController?.popToRootViewController(animated: true)
        case .paymentCardDetail(let card, let isCardAdmin, let status):
            let detailViewController = PaymentCardDetailViewController()
            detailViewController.reactor = PaymentCardDetailViewReactor(
                cardID: card.id,
                cardName: card.name,
                isCardAdmin: isCardAdmin,
                spaceStatus: status,
                participatedUsers: card.participatedUserList.map {
                    .init(id: $0.id, name: $0.nickName, imgURL: $0.imageURL)
                }
            )
            self.navigationController?.pushViewController(detailViewController, animated: true)
        case .actionSheet(let isAdmin):
            self.present(optionAlertController(isAdmin), animated: true)
        case .nameEdit:
            let editRoomNameViewController = SpaceNameViewController()
            editRoomNameViewController.reactor = SpaceNameReactor(type: .rename(reactor!.currentState.space.id))
            self.navigationController?.pushViewController(editRoomNameViewController, animated: true)
        case .addPaymentCard:
            self.navigationController?.pushViewController(createPaymentCard(), animated: true)
        case .participate:
            guard let currentState = reactor?.currentState else { return }
            let participateViewController = ParticipatePaymentCardViewController()

            var cards: [ParticipateCellViewModel] = []
            for section in currentState.sections {
                guard case .PaymentCard(let items) = section else { continue }
                for item in items {
                    guard case .PaymentCard(let model) = item else { continue }
                    cards.append(converToParticipatedCards(model))
                }
            }
            participateViewController.reactor = ParticipatePaymentCardViewReactor(participatedCards: cards)
            participateViewController.modalPresentationStyle = .fullScreen
            self.present(participateViewController, animated: true)
        case .none:
            break
        }
    }

    private func converToParticipatedCards(_ cardModel: PaymentCardCellViewModel) -> ParticipateCellViewModel {
        return .init(id: cardModel.id,
                     isSelected: cardModel.isUserParticipated,
                     name: cardModel.name,
                     categoryName: cardModel.categoryImageName,
                     amount: cardModel.totalAmount,
                     payer: .init(id: cardModel.payer.id, imgURL: cardModel.payer.imageURL, name: cardModel.payer.nickName),
                     date: cardModel.dateString,
                     bgColor: cardModel.backgroundColor
        )

    }
    private func createPaymentCard() -> UIViewController {
        let createCard = PaymentCardNameEditViewController()
        let space = reactor!.currentState.space
        var newPaymentCard = PaymentCardModels.CreateCard.Request.initialValue
        newPaymentCard.spaceID = space.id
        newPaymentCard.viewModel.spaceName = space.title
        createCard.reactor = PaymentCardNameEditViewReactor(
            type: .create, paymentCard: newPaymentCard
        )
        return createCard
    }
    
    private func optionAlertController(_ isAdmin: Bool) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if isAdmin {
            let item1 = UIAlertAction(title: "정산방 이름 변경", style: .default) { _ in
                self.dismiss(animated: true) { [weak self] in
                    self?.reactor?.action.onNext(.routeToNameEdit)
                }
            }
            actionSheet.addAction(item1)
        }
        
        let item2 = UIAlertAction(title: "정산방 나가기", style: .default) { _ in
            self.dismiss(animated: true) { [weak self] in
                self?.reactor?.action.onNext(.didTapLeaveButton)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)

        actionSheet.addAction(item2)
        actionSheet.addAction(cancel)
        return actionSheet
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension PaymentCardListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch indexPath.section {
        case 0:
            return .init(width: 340, height: 150)
        case 1:
            return .init(width: 340, height: 216)
        case 2:
            return .init(width: 340, height: 127)
        default:
            return .zero
        }
    }
}
