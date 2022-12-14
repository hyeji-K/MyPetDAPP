//
//  HomeViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import UIKit
import SnapKit

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
        pageControl.tintColor = .darkGray
        pageControl.currentPageIndicatorTintColor = .ebonyClayColor
        pageControl.numberOfPages = self.petManager.petInfos.count
        pageControl.currentPage = .zero
        return pageControl
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .fiordColor
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
    
//    var petInfos: [PetInfo] = []
    var petManager = PetManager()
//    var productInfo: [ProductInfo] = []
    var productManager = ProductManager()
//    var reminders: [Reminder] = []
    var reminderMamager = ReminderManager()
    var todayReminders: [Reminder] = []
    var todayIsCompletedReminders: [Reminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        configureCollectionView()
        fetch()
        productFetch()
        reminderFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        let titleConfig = CustomBarItemConfiguration(title: "MyPetBox", action: { print("title tapped") })
        let titleItem = UIBarButtonItem.generate(with: titleConfig)
        navigationItem.leftBarButtonItem = titleItem
        
        let settingsConfig = CustomBarItemConfiguration(image: UIImage(systemName: "gearshape")) {
            let settingViewController = SettingViewController()
            settingViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(settingViewController, animated: true)
        }
        let settingsItem = UIBarButtonItem.generate(with: settingsConfig, width: 30)
        let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
            let today = Date.now.stringFormat
            let petInfo = PetInfo(image: "", name: "", birthDate: today, withDate: today, createdDate: Date.now.stringFormat)
            let viewController = PetViewController(petInfo) { [weak self] petInfo in
                
            }
            viewController.navigationItem.title = NSLocalizedString("반려동물 추가하기", comment: "Add Pet view controller title")
            
            viewController.isAddingNewPetInfo = true
            let navigationContoller = UINavigationController(rootViewController: viewController)
            navigationContoller.navigationBar.tintColor = .black
            
            self.present(navigationContoller, animated: true, completion: nil)
        }
        let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
        
        navigationItem.rightBarButtonItems = [settingsItem, addItem]
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationController?.navigationBar.tintColor = .black
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
        let petDetailViewController = PetDetailViewController(petInfo: petInfo) { petInfo in
            self.updateSnapshot(reloading: petInfo)
        }
        petDetailViewController.hidesBottomBarWhenPushed = true
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
                    self.petManager.petInfos = petInfos.sorted { $0.createdDate < $1.createdDate }
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
                    self.productManager.products = filterProduct.sorted(by: { $0.expirationDate < $1.expirationDate })
                    self.tableView.reloadData()
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                self.productManager.products = []
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
        let item = self.petManager.petInfos
        showDetail(for: item)
    }
}
