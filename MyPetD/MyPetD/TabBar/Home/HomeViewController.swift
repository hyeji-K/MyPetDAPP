//
//  HomeViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/19.
//

import UIKit
import SnapKit
import Combine
import FirebaseDatabase

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
        view.backgroundColor = .systemYellow
        return view
    }()
    let selectTodoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    var collectionView: UICollectionView!
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.allowsContinuousInteraction = false
        pageControl.pageIndicatorTintColor = .systemGray6
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = petInfos.count
        pageControl.currentPage = .zero
        return pageControl
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
    
    var ref: DatabaseReference!
    var petInfos: [PetInfo] = []
    var productInfo: [ProductInfo] = []
    var reminders: [Reminder] = Reminder.sampleData
    
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
        
        self.tableView.reloadData()
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = .zero
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
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
    }
    
    func showDetail(for petInfo: [PetInfo]) {
        print("Show productInfo: \(petInfo)")
        let petDetailViewController = PetDetailViewController(petInfo: petInfo) { petInfo in
        }
        self.navigationController?.pushViewController(petDetailViewController, animated: true)
    }
    
    func fetch() {
        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
        self.ref = Database.database().reference(withPath: uid)
        self.ref.child("PetInfo").queryOrdered(byChild: "id").observe(.value) { snapshot in
            guard let snapshot = snapshot.value as? [String: Any] else { return }
            do {
                let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                let decoder = JSONDecoder()
                let petInfos: [PetInfo] = try decoder.decode([PetInfo].self, from: data)
                self.petInfos = petInfos
                self.updateSnapshot(reloading: petInfos)
                self.pageControl.numberOfPages = petInfos.count
            } catch let error {
                print(error.localizedDescription)
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
        print(toggleTableView)
        selectProductView.backgroundColor = .systemYellow
        selectTodoView.backgroundColor = .clear
        self.tableView.reloadData()
    }
    
    @objc func todoButtonTapped(_ sender: UIButton) {
        toggleTableView = true
        print(toggleTableView)
        selectProductView.backgroundColor = .clear
        selectTodoView.backgroundColor = .systemYellow
        self.tableView.reloadData()
    }
    
    func productFetch() {
        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
        self.ref = Database.database().reference(withPath: uid)
        self.ref.child("ProductInfo").queryOrdered(byChild: "id").observe(.value) { snapshot in
            guard let snapshot = snapshot.value as? [String: Any] else { return }
            do {
                let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                let decoder = JSONDecoder()
                let productInfos: [ProductInfo] = try decoder.decode([ProductInfo].self, from: data)
                self.productInfo = productInfos
                self.tableView.reloadData()
                print(" -->> \(productInfos)")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func reminderFetch() {
        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
        self.ref = Database.database().reference(withPath: uid)
        self.ref.child("Reminder").queryOrdered(byChild: "isComplete").observe(.value) { snapshot in
            guard let snapshot = snapshot.value as? [String: Any] else { return }
            do {
                let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                let decoder = JSONDecoder()
                let reminders: [Reminder] = try decoder.decode([Reminder].self, from: data)
                self.reminders = reminders
                self.tableView.reloadData()
            } catch let error {
                print(error.localizedDescription)
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
