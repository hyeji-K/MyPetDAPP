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
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Item = ProductInfo
    
    enum Section {
        case main
    }
    
    var dataSource: DataSource!
    
    let viewModel: BoxViewModel = BoxViewModel()
    var subscriptions = Set<AnyCancellable>()
    var products: [ProductInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        bind()
//        viewModel.fetch()
        fetch()
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
    
    func add(_ product: ProductInfo) {
        products.append(product)
    }
    
    func deleteProduct(with id: ProductInfo.ID) {
        let index = products.indexOfProduct(with: id)
        products.remove(at: index)
    }
    
    func productInfo(for id: ProductInfo.ID) -> ProductInfo {
        let index = products.indexOfProduct(with: id)
        return products[index]
    }
    
    func update(_ product: ProductInfo, with id: ProductInfo.ID) {
        let index = products.indexOfProduct(with: id)
        products[index] = product
    }
    
    func updateSnapshot(reloading product: [ProductInfo] = []) {
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
    
    func showDetail(for productInfo: ProductInfo) {
        print("Show productInfo: \(productInfo)")
        let viewController = ItemDetailViewController(productInfo: productInfo) { [weak self] productInfo in
            self?.update(productInfo, with: productInfo.id)
            self?.updateSnapshot(reloading: [productInfo])
        }
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    func fetch() {
        NetworkService.shared.getDataList(classification: .productInfo) { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
                    let decoder = JSONDecoder()
                    let productInfo: [ProductInfo] = try decoder.decode([ProductInfo].self, from: data)
                    self.products = productInfo.sorted(by: { $0.expirationDate < $1.expirationDate })
                    self.updateSnapshot(reloading: self.products)
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                self.updateSnapshot()
            }
        }
//
//        let uid = UserDefaults.standard.string(forKey: "firebaseUid")!
//        self.ref = Database.database().reference(withPath: uid)
//
//        self.ref.child("ProductInfo").observe(.value) { snapshot in
//            if snapshot.exists() {
//                guard let snapshot = snapshot.value as? [String: Any] else { return }
//                do {
//                    let data = try JSONSerialization.data(withJSONObject: Array(snapshot.values), options: [])
//                    let decoder = JSONDecoder()
//                    let productInfo: [ProductInfo] = try decoder.decode([ProductInfo].self, from: data)
//                    self.products = productInfo.sorted(by: { $0.expirationDate < $1.expirationDate })
//                    self.updateSnapshot(reloading: self.products)
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//            } else {
//                self.updateSnapshot()
//            }
//        }
    }
    
//    private func applyItems(_ productInfos: [ProductInfo]) {
//        var snapshot = dataSource.snapshot()
//        snapshot.appendItems(productInfos, toSection: .main)
//        self.dataSource.apply(snapshot)
//    }
//
//    private func bind() {
//        viewModel.$productInfos
//            .receive(on: RunLoop.main)
//            .sink { productInfo in
//                print("--> update collection view \(productInfo)")
//                print("--> 업데이트! \(productInfo.count)")
//                self.applyItems(productInfo)
//            }.store(in: &subscriptions)
//    }
}
// 

extension BoxViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = viewModel.productInfos[indexPath.item]
        let item = products[indexPath.item]
        showDetail(for: item)
    }
}
