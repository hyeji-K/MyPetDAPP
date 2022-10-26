//
//  Extension+EmptyView.swift
//  MyPetD
//
//  Created by heyji on 2022/10/26.
//

import UIKit

extension UICollectionView {
    
    func setEmptyView(title: String, message: String) {
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.width, height: self.bounds.height))
            return view
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = title
            label.textColor = .systemGray
            label.font = UIFont.preferredFont(forTextStyle: .title2)
            return label
        }()
        
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(emptyView.snp.centerY)
            make.centerX.equalTo(emptyView.snp.centerX)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
 
