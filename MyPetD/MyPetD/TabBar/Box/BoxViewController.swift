//
//  BoxViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/25.
//

import UIKit
import Combine

class BoxViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel: BoxViewModel = BoxViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    enum Section {
        case main
    }
    typealias Item = ProductInfo
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        viewModel.fetch()
    }
    
    private func setupView() {
        collectionView.delegate = self
//        collectionView.backgroundColor = .systemMint
        self.collectionView.register(BoxCell.self, forCellWithReuseIdentifier: BoxCell.identifier)
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxCell.identifier, for: indexPath) as? BoxCell else { return nil }
            cell.configuration(item)
            return cell
        })
        
        collectionView.collectionViewLayout = collectionViewLayout()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        dataSource.apply(snapshot)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func applyItems(_ productInfos: [ProductInfo]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(productInfos, toSection: .main)
        self.dataSource.apply(snapshot)
    }
    
    private func bind() {
        viewModel.$productInfos
            .receive(on: RunLoop.main)
            .sink { productInfo in
                print("--> update collection view \(productInfo)")
                print("--> 업데이트! \(productInfo.count)")
                self.applyItems(productInfo)
            }.store(in: &subscriptions)
    }
}
// 

extension BoxViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.productInfos[indexPath.item]
        
        let itemDetailViewController = ItemDetailViewController()
        itemDetailViewController.productInfo = item
        itemDetailViewController.modalTransitionStyle = .crossDissolve
        itemDetailViewController.modalPresentationStyle = .overFullScreen
        self.present(itemDetailViewController, animated: true, completion: nil)
    }
}
