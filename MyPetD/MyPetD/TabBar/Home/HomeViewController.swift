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
    
    let dummyData = ["츄르", "건조간식", "사료", "캔", "츄르", "건조간식", "사료", "캔", "츄르", "건조간식", "사료", "캔", "츄르", "건조간식", "사료", "캔"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.cellId)
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
//        tableView.sectionHeaderTopPadding = .zero
        setupView()
    }
    
    private func setupView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        tableView.tableHeaderView = headerView
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.cellId)
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
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cellId, for: indexPath)
//        cell.textLabel?.text = dummyData[indexPath.row]
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray2
        headerView.layer.cornerRadius = 10
        headerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)

        
        let productButton = UIButton()
        productButton.setTitle("제품", for: .normal)
        headerView.addSubview(productButton)
        productButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(headerView.snp.width).dividedBy(2)
            make.height.equalTo(44)
        }
        
        let todoButton = UIButton()
        todoButton.setTitle("할일", for: .normal)
        headerView.addSubview(todoButton)
        todoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(headerView.snp.width).dividedBy(2)
            make.height.equalTo(44)
        }
        
        let seperatedView = UIView()
        seperatedView.backgroundColor = .black
        headerView.addSubview(seperatedView)
        seperatedView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        let productView = UIView()
        productView.backgroundColor = .systemBlue
        headerView.addSubview(productView)
        productView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
//            make.left.equalToSuperview().inset(50)
            make.centerX.equalToSuperview().dividedBy(2)
            make.height.equalTo(3)
            make.width.equalTo(productButton.snp.width).dividedBy(2)
        }
        
        let todoView = UIView()
//        todoView.backgroundColor = .systemBlue
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
