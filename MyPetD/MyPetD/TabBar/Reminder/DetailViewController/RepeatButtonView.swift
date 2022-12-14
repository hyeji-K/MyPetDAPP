//
//  RepeatButtonView.swift
//  MyPetD
//
//  Created by heyji on 2022/09/14.
//

import UIKit

final class RepeatButtonView: UIView {
    
    var collectionView: UICollectionView!
    let repeatArray: [String] = [RepectCycle.none.name, RepectCycle.everyDay.name, RepectCycle.everyWeek.name, RepectCycle.everyMonth.name, RepectCycle.everyYear.name]
    enum Section {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }
    
    private func initializeView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.collectionViewLayout = collectionViewLayout()
        collectionView.register(RepeatCell.self, forCellWithReuseIdentifier: RepeatCell.cellID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepeatCell.cellID, for: indexPath) as? RepeatCell else { return nil }
            cell.configure(title: item)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repeatArray, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
