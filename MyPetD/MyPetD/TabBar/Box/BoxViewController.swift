//
//  BoxViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/25.
//

import UIKit

class BoxViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dummyData = ["츄르", "건조간식", "사료", "캔"]
    
    enum Section {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.backgroundColor = .systemMint
        self.collectionView.register(BoxCell.self, forCellWithReuseIdentifier: BoxCell.identifier)
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxCell.identifier, for: indexPath) as? BoxCell else { return nil }
            cell.configuration(title: item)
            return cell
        })
        
        collectionView.collectionViewLayout = collectionViewLayout()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dummyData, toSection: .main)
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
}
// 

extension BoxViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        print(item)
//        let productDetailViewController = ProductDetailViewController()
//        self.navigationController?.pushViewController(productDetailViewController, animated: true)
        
        let itemDetailViewController = ItemDetailViewController()
        itemDetailViewController.modalTransitionStyle = .crossDissolve
        itemDetailViewController.modalPresentationStyle = .overFullScreen
        self.present(itemDetailViewController, animated: true, completion: nil)
    }
}
