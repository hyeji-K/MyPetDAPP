//
//  SettingViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/09/14.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController {
    
    // 버전 정보, 문의하기, 오픈소스, 언어, 알림 설정
    let notification: [String] = ["알림 설정"]
    let settingArray: [String] = ["문의하기", "오픈소스", "버전 정보"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        
        self.navigationItem.title = "설정"
        
        setupView()
    }
    
    @objc private func notiSwitchTapped(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "notiSwitch")
    }
    
    private func setupView() {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = .zero
        tableView.isScrollEnabled = false
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return notification.count
        } else {
            return settingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.cellId, for: indexPath) as? SettingCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            let notiSwitch = UISwitch()
            notiSwitch.isOn = UserDefaults.standard.bool(forKey: "notiSwitch")
            notiSwitch.addTarget(self, action: #selector(notiSwitchTapped), for: .touchUpInside)
            cell.accessoryView = notiSwitch
            cell.configure(title: notification[indexPath.row])
        } else {
            cell.configure(title: settingArray[indexPath.row])
            switch indexPath.row {
            case 0, 1:
                cell.accessoryType = .disclosureIndicator
            case 2:
                let detailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 16))
                detailLabel.text = "1.0.0"
                detailLabel.textColor = .systemGray
                detailLabel.textAlignment = .right
                cell.accessoryView = detailLabel
            default:
                ()
            }
        }
        return cell
    }
    
    
    
}

extension SettingViewController: UITableViewDelegate, MFMailComposeViewControllerDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            if indexPath.row == 0 {
                if MFMailComposeViewController.canSendMail() {
                    let composeViewController = MFMailComposeViewController()
                    composeViewController.mailComposeDelegate = self
                    
                    let bodyString = """
                                     -------------------
                                     
                                     Device Model : \(self.getDeviceIdentifier())
                                     Device OS : \(UIDevice.current.systemVersion)
                                     App Version : \(self.getCurrentVersion())
                                     
                                     -------------------
                                        이곳에 내용을 작성해주세요.
                                    
                                    
                                    """
                    composeViewController.setToRecipients(["@gmail.com"])
                    composeViewController.setSubject("<MyPetD> 문의 및 의견")
                    composeViewController.setMessageBody(bodyString, isHTML: false)
                    
                    self.present(composeViewController, animated: true, completion: nil)
                } else {
                    print("메일 보내기 실패")
                    let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
                    let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                        // 앱스토어로 이동하기(Mail)
                        if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }
                    let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                    
                    sendMailErrorAlert.addAction(goAppStoreAction)
                    sendMailErrorAlert.addAction(cancleAction)
                    self.present(sendMailErrorAlert, animated: true, completion: nil)
                }
            } else if indexPath.row == 1 {
                print(indexPath.row)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }

    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
}

class SettingCell: UITableViewCell {
    static let cellId: String = "SettingCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func setupCell() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
    }
}
