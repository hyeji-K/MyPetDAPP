//
//  BoxViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/25.
//

import UIKit

final class BoxViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Item = ProductInfo
    
    enum Section {
        case main
    }
    
    private var dataSource: DataSource!
    private var productManager = ProductManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        fetch()
    }
    
    private func setupNavigationBar() {
        let titleConfig = CustomBarItemConfiguration(title: "간식 창고", action: { print("title tapped") })
        let titleItem = UIBarButtonItem.generate(with: titleConfig)
        navigationItem.leftBarButtonItem = titleItem
        
        let addConfig = CustomBarItemConfiguration(image: UIImage(systemName: "plus")) {
            let productInfo = self.productManager.createProduct()
            let viewController = ProductViewController(product: productInfo) { [weak self] productInfo in
                self?.productManager.addProduct(productInfo)
            }
            viewController.isAddingNewProduct = true
            viewController.setEditing(true, animated: false)
            viewController.navigationItem.title = NSLocalizedString("상품 추가하기", comment: "Add Product view controller title")
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.tintColor = .black
            self.present(navigationController, animated: true)
        }
        let addItem = UIBarButtonItem.generate(with: addConfig, width: 30)
        
        navigationItem.rightBarButtonItems = [addItem]
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupView() {
        collectionView.delegate = self
        self.collectionView.register(BoxCell.self, forCellWithReuseIdentifier: BoxCell.identifier)
        self.dataSource = DataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxCell.identifier, for: indexPath) as? BoxCell else { return nil }
            cell.configuration(itemIdentifier)
            return cell
        })
        
        collectionView.collectionViewLayout = collectionViewLayout()
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
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
    
    private func updateSnapshot(reloading product: [ProductInfo] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(product, toSection: .main)
        if !product.isEmpty {
            snapshot.reloadItems(product)
        }
        if snapshot.itemIdentifiers.isEmpty {
            collectionView.setEmptyView(title: "간식 창고가 비어있습니다", message: "우측 상단의 + 버튼으로 추가할 수 있습니다.")
        } else {
            collectionView.restore()
        }
        dataSource.apply(snapshot)
    }
    
    private func showDetail(for productInfo: ProductInfo) {
        let viewController = ItemDetailViewController(productInfo: productInfo) { [weak self] productInfo in
            self?.productManager.updateProduct(productInfo)
            self?.updateSnapshot(reloading: [productInfo])
        }
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func fetch() {
        NetworkService.shared.getDataList(classification: .productInfo) { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                    let decoder = JSONDecoder()
                    let productInfo: [ProductInfo] = try decoder.decode([ProductInfo].self, from: data)
                    self.productManager.products = productInfo.sorted(by: { $0.expirationDate < $1.expirationDate })
                    self.updateSnapshot(reloading: self.productManager.products)
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                self.updateSnapshot()
            }
        }
    }
}

extension BoxViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = productManager.products[indexPath.item]
        showDetail(for: item)
    }
}
