//
//  PetDetailViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/08/20.
//

import UIKit

class PetDetailViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    var collectionView: UICollectionView!
    var petInfo: [PetInfo] {
        didSet {
            onChange(petInfo)
        }
    }
    var onChange: ([PetInfo]) -> Void
    
    enum Section {
        case main
    }
    typealias Item = PetInfo
    var dataSource: DataSource!
    
    init(petInfo: [PetInfo], onChange: @escaping ([PetInfo]) -> Void) {
        self.petInfo = petInfo
        self.onChange = onChange
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateSnapshot(reloading: petInfo)
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = NSLocalizedString("앨범", comment: "Pet Detail view controller title")
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        self.collectionView.register(PetInfoCell.self, forCellWithReuseIdentifier: PetInfoCell.cellId)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.left.right.equalToSuperview()
        }
        self.collectionView.backgroundColor = .shadyLadyColor.withAlphaComponent(0.2)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetInfoCell.cellId, for: indexPath) as? PetInfoCell else { return nil }
            cell.configure(itemIdentifier)
            cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped), for: .touchUpInside)
            cell.deleteButton.id = itemIdentifier.id
            cell.editButton.addTarget(self, action: #selector(self.editButtonTapped), for: .touchUpInside)
            cell.editButton.id = itemIdentifier.id
            return cell
        })
        
        collectionView.collectionViewLayout = collectionViewLayout()
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    @objc func deleteButtonTapped(_ sender: PetEditButton) {
        guard let id = sender.id else { return }
        deletePetInfo(with: id)
    }
    
    func deletePetInfo(with id: PetInfo.ID) {
        let index = petInfo.indexOfPet(with: id)
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "삭제하면 되돌릴 수 없습니다.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            NetworkService.shared.deleteImageAndData(with: id, storageName: .petImage, classification: .petInfo)
            
            self.petInfo.remove(at: index)
            self.updateSnapshot(reloading: self.petInfo)
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editButtonTapped(_ sender: PetEditButton) {
        guard let id = sender.id else { return }
        let index = petInfo.indexOfPet(with: id)
        let item = petInfo[index]
        
        let addPetViewController = PetViewController(item) { petInfo in
            self.petInfo[index] = petInfo
            self.updateSnapshot(reloading: self.petInfo)
        }
        let navigationCotorller = UINavigationController(rootViewController: addPetViewController)
        self.present(navigationCotorller, animated: true, completion: nil)
    }
    
    func updateSnapshot(reloading petInfo: [PetInfo] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(petInfo, toSection: .main)
        if !petInfo.isEmpty {
            snapshot.reloadItems(petInfo)
        }
        dataSource.apply(snapshot)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(4/3))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
