//
//  CollectionContentView.swift
//  MyPetD
//
//  Created by heyji on 2022/10/15.
//

import UIKit

class CollectionContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var repeatCycle: String? = ""
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return CollectionContentView(self)
        }
    }
    
    var collectionView: UICollectionView!
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    let repeatArray: [String] = ["반복없음", "매일", "매주", "매월", "매년"]
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        initializeView()
        addPinnedSubview(collectionView, height: 44, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    private func initializeView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.collectionViewLayout = collectionViewLayout()
        collectionView.register(RepeatCell.self, forCellWithReuseIdentifier: RepeatCell.cellID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepeatCell.cellID, for: indexPath) as? RepeatCell else { return nil }
            if let configuration = self.configuration as? Configuration {
                if self.repeatArray[indexPath.item] == configuration.repeatCycle {
                    cell.isSelected.toggle()
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
                }
            }
            cell.configure(title: item)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(repeatArray, toSection: 0)
        dataSource.apply(snapshot)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        
    }
}

extension CollectionContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let configuration = configuration as? CollectionContentView.Configuration else { return }
        configuration.onChange(repeatArray[indexPath.item])
    }
}

extension UICollectionViewListCell {
    func collectionViewConfiguration() -> CollectionContentView.Configuration {
        CollectionContentView.Configuration()
    }
}
