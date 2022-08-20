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
    var toggle: Bool?
    let productView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        return view
    }()
    let todoView: UIView = {
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
        pageControl.numberOfPages = profileInfos.count
        pageControl.currentPage = .zero
        return pageControl
    }()

    enum Section {
        case main
    }
    let profileInfos: [ProfileInfo] = ProfileInfo.list
    typealias Item = ProfileInfo
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    let dummyData = ["츄르", "건조간식", "사료", "캔", "츄르", "건조간식"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        self.toggle = false
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.cellId)
        tableView.register(TodayTodoCell.self, forCellReuseIdentifier: TodayTodoCell.cellId)
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = .zero
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        tableView.tableHeaderView = headerView
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.cellId)
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
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.cellId, for: indexPath) as? ProfileCell else { return nil }
            cell.configure(item)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(profileInfos, toSection: .main)
        dataSource.apply(snapshot)
        
        collectionView.collectionViewLayout = collectionViewLayout()
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
    
    @objc func productButtonTapped(_ sender: UIButton) {
        toggle = false
        productView.backgroundColor = .systemYellow
        todoView.backgroundColor = .clear
        self.tableView.reloadData()
    }
    
    @objc func todoButtonTapped(_ sender: UIButton) {
        toggle = true
        productView.backgroundColor = .clear
        todoView.backgroundColor = .systemYellow
        self.tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if toggle == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cellId, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TodayTodoCell.cellId, for: indexPath)
            return cell
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if toggle == false {
            return 95
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
//        headerView.layer.cornerRadius = 10
//        headerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
//        headerView.layer.borderWidth = 1
//        headerView.layer.borderColor = UIColor.systemGray3.cgColor

        let productButton = UIButton()
        productButton.setTitle("임박 제품", for: .normal)
        productButton.setTitleColor(.black, for: .normal)
        productButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        headerView.addSubview(productButton)
        productButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(headerView.snp.width).dividedBy(2)
            make.height.equalTo(34)
        }
        productButton.addTarget(self, action: #selector(productButtonTapped), for: .touchUpInside)
        
        let todoButton = UIButton()
        todoButton.setTitle("오늘 일정", for: .normal)
        todoButton.setTitleColor(.black, for: .normal)
        todoButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        headerView.addSubview(todoButton)
        todoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(headerView.snp.width).dividedBy(2)
            make.height.equalTo(34)
        }
        todoButton.addTarget(self, action: #selector(todoButtonTapped), for: .touchUpInside)
        
        let seperatedView = UIView()
        seperatedView.backgroundColor = .lightGray
        headerView.addSubview(seperatedView)
        seperatedView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.8)
            make.width.equalToSuperview()
        }
        
        headerView.addSubview(productView)
        productView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
//            make.left.equalToSuperview().inset(50)
            make.centerX.equalToSuperview().dividedBy(2)
            make.height.equalTo(3)
            make.width.equalTo(productButton.snp.width).dividedBy(2)
        }
        
        headerView.addSubview(todoView)
        todoView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(50)
//            make.centerX.equalTo(todoButton.snp.view.widthAnchor)
            make.height.equalTo(3)
            make.width.equalTo(todoButton.snp.width).dividedBy(2)
        }
        
        return headerView
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = profileInfos[indexPath.item]
        print("item -> \(item)")
        
        let petDetailViewController = PetDetailViewController()
        self.navigationController?.pushViewController(petDetailViewController, animated: true)
    }
}
