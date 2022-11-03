//
//  HomeViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import UIKit
import SnapKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy var toggleTableView: Bool = false {
        didSet {
            if toggleTableView == false {
                tableView.separatorStyle = .none
            } else {
                tableView.separatorStyle = .singleLine
            }
        }
    }
    let selectProductView: UIView = {
        let view = UIView()
        view.backgroundColor = .fiordColor
        return view
    }()
    let productButton: UIButton = {
        let button = UIButton()
        button.setTitle("임박 제품", for: .normal)
        button.setTitleColor(.rumColor, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        return button
    }()
    let selectTodoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    let todoButton: UIButton = {
        let button = UIButton()
        button.setTitle("오늘 일정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        return button
    }()
    
    var collectionView: UICollectionView!
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.allowsContinuousInteraction = false
//        pageControl.pageIndicatorTintColor = .systemGray6
        pageControl.tintColor = .darkGray
        pageControl.currentPageIndicatorTintColor = .ebonyClayColor
        pageControl.numberOfPages = petInfos.count
        pageControl.currentPage = .zero
        return pageControl
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
//        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.color = .ebonyClayColor
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
    }()

    enum Section {
        case main
    }
        
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Item = PetInfo
    var dataSource: DataSource!
    
    let viewModel: HomeViewModel = HomeViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    var petInfos: [PetInfo] = []
    var productInfo: [ProductInfo] = []
    var reminders: [Reminder] = []
    var todayReminders: [Reminder] = []
    var todayIsCompletedReminders: [Reminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewModel.fetch()
        
        setupView()
        configureCollectionView()
//        bind()
        fetch()
        productFetch()
        reminderFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(" 화면이 다시 보일때 \(self.productInfo)")
        self.tableView.reloadData()
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = .zero
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 220))
        tableView.tableHeaderView = headerView
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(MainCardCell.self, forCellWithReuseIdentifier: MainCardCell.cellId)
        collectionView.delegate = self
        headerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(6)
        }
        
        self.view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.view.bringSubviewToFront(indicatorView)
        
    }
    
    private func configureCollectionView() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCardCell.cellId, for: indexPath) as? MainCardCell else { return nil }
            cell.configure(itemIdentifier)
            return cell
        })
        
        collectionView.collectionViewLayout = collectionViewLayout()
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { (item, offset, env) in
            let index = Int((offset.x / env.container.contentSize.width).rounded(.up))
            self.pageControl.currentPage = index
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func updateSnapshot(reloading petInfo: [PetInfo] = []) {
        print("updateSnapshot = \(petInfo)")
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(petInfo, toSection: .main)
        if !petInfo.isEmpty {
            snapshot.reloadItems(petInfo)
        }
        dataSource.apply(snapshot)
        self.pageControl.numberOfPages = petInfo.count
    }
    
    func showDetail(for petInfo: [PetInfo]) {
        print("Show productInfo: \(petInfo)")
        let petDetailViewController = PetDetailViewController(petInfo: petInfo) { petInfo in
            self.updateSnapshot(reloading: petInfo)
        }
        self.navigationController?.pushViewController(petDetailViewController, animated: true)
    }
    
    private func fetch() {
        self.indicatorView.startAnimating()
        NetworkService.shared.getDataList(classification: .petInfo) { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                    let decoder = JSONDecoder()
                    let petInfos: [PetInfo] = try decoder.decode([PetInfo].self, from: data)
                    // NOTE: 생성된 날짜순으로 정렬
                    self.petInfos = petInfos.sorted { $0.createdDate < $1.createdDate }
                    self.updateSnapshot(reloading: petInfos)
                    self.indicatorView.stopAnimating()
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                self.indicatorView.stopAnimating()
                self.collectionView.setEmptyView(title: "반려동물을 추가해보세요", message: "우측 상단의 + 버튼으로 추가할 수 있습니다.", backgroundColor: .fiordColor)
            }
        }
    }
    
//    private func applyItems(_ petInfos: [PetInfo]) {
//        var snapshot = dataSource.snapshot()
//        snapshot.appendItems(petInfos, toSection: .main)
//        self.dataSource.apply(snapshot)
//    }
//
//    private func bind() {
//        viewModel.$profileInfos
//            .receive(on: RunLoop.main)
//            .sink { profileInfos in
//                print("--> update collection view \(profileInfos)")
//                self.applyItems(profileInfos)
//                self.pageControl.numberOfPages = profileInfos.count
//            }.store(in: &subscriptions)
//    }
    
    @objc func productButtonTapped(_ sender: UIButton) {
        toggleTableView = false
        selectProductView.backgroundColor = .fiordColor
        selectTodoView.backgroundColor = .clear
        productButton.setTitleColor(.rumColor, for: .normal)
        todoButton.setTitleColor(.black, for: .normal)
        self.tableView.reloadData()
    }
    
    @objc func todoButtonTapped(_ sender: UIButton) {
        toggleTableView = true
        selectProductView.backgroundColor = .clear
        selectTodoView.backgroundColor = .fiordColor
        productButton.setTitleColor(.black, for: .normal)
        todoButton.setTitleColor(.rumColor, for: .normal)
        self.tableView.reloadData()
    }
    
    func productFetch() {
        NetworkService.shared.getDataList(classification: .productInfo) { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                    let decoder = JSONDecoder()
                    let productInfos: [ProductInfo] = try decoder.decode([ProductInfo].self, from: data)
                    var filterProduct: [ProductInfo] = []
                    productInfos.map { product in
                        let date = product.expirationDate.dateLong!
                        let dDay = Calendar.current.dateComponents([.day], from: Date(), to: date).day!
                        if dDay <= 60 {
                            filterProduct.append(product)
                        }
                    }
                    self.productInfo = filterProduct.sorted(by: { $0.expirationDate < $1.expirationDate })
                    self.tableView.reloadData()
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                self.productInfo = []
//                self.tableView.reloadData()
//                self.updateSnapshot()
            }
        }
    }
    
    func reminderFetch() {
        NetworkService.shared.getDataList(classification: .reminder) { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                    let decoder = JSONDecoder()
                    let reminders: [Reminder] = try decoder.decode([Reminder].self, from: data)
                    // NOTE: 오늘 일정인 것만 표시되도록 구현
                    self.todayReminders = []
                    reminders.map { reminder in
                        let date = Date.now.stringFormatShort
                        if date == reminder.dueDate.dateLong!.stringFormatShort {
                            self.todayReminders.append(reminder)
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                // 스냅샷이 존재하지 않을때
                self.todayReminders = []
            }
        }

        NetworkService.shared.getCompleteRemindersList(classification: .completeReminder) { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                    let decoder = JSONDecoder()
                    let completeReminders: [Reminder] = try decoder.decode([Reminder].self, from: data)
                    
                    // NOTE: 오늘 일정인 것만 표시되도록 구현
                    self.todayIsCompletedReminders = []
                    completeReminders.map { reminder in
                        let date = Date.now.stringFormatShort
                        if date == reminder.dueDate.dateLong!.stringFormatShort {
                            self.todayIsCompletedReminders.append(reminder)
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                self.todayIsCompletedReminders = []
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = petInfos
        showDetail(for: item)
    }
}
