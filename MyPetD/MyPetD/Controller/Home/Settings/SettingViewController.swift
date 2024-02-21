//
//  SettingViewController.swift
//  MyPetD
//
//  Created by heyji on 2022/09/14.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController {
    
    let notice: [[String]] = [["알림 설정"], ["2024 박람회 일정"], ["문의하기", "오픈소스", "버전 정보"]]
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        
        self.navigationItem.title = "설정"
        
        setupView()
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: { _ in
            let indexSet = IndexSet(arrayLiteral: 0)
            self.tableView.reloadSections(indexSet, with: .none)
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = .zero
        tableView.isScrollEnabled = false
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notice.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notice[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = notice[indexPath.section][indexPath.row]
            cell.contentConfiguration = contentConfiguration
            
            let alarmLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 16))
            UNUserNotificationCenter.current().requestAuthorization { didAllow, error in
                if didAllow {
                    DispatchQueue.main.async {
                        alarmLabel.text = "ON"
                        alarmLabel.textColor = .fiordColor
                    }
                } else {
                    DispatchQueue.main.async {
                        alarmLabel.text = "OFF"
                        alarmLabel.textColor = .systemGray
                    }
                }
            }
            alarmLabel.textAlignment = .right
            cell.accessoryView = alarmLabel
            
        } else if indexPath.section == 1 {
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = notice[indexPath.section][indexPath.row]
            cell.contentConfiguration = contentConfiguration
            cell.accessoryType = .disclosureIndicator
            
        } else {
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = notice[indexPath.section][indexPath.row]
            cell.contentConfiguration = contentConfiguration
            
            switch indexPath.row {
            case 0, 1:
                cell.accessoryType = .disclosureIndicator
            case 2:
                let detailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 16))
                detailLabel.text = getCurrentVersion()
                detailLabel.textColor = .fiordColor
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
            UNUserNotificationCenter.current().requestAuthorization { didAllow, error in
                if didAllow {
                    print("알림이 허용되었습니다.")
                    self.alert("알림 권한이 허용되어 있습니다.")
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "푸시 알림 권한 요청", message: "알림 권한을 허용하면 일정 알림을 받을 수 있습니다.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                        alert.addAction(cancelAction)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true)
                    }
                }
            }
        } else if indexPath.section == 1 {
            let viewController = ScheduleViewController()
            viewController.navigationBarTitle = notice[indexPath.section][indexPath.row]
            navigationItem.backButtonDisplayMode = .minimal
            self.navigationController?.pushViewController(viewController, animated: true)
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
                    composeViewController.setToRecipients(["khjji0502@gmail.com"])
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
                let viewController = OpenSourceTableViewController()
                navigationItem.backButtonDisplayMode = .minimal
                self.navigationController?.pushViewController(viewController, animated: true)
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
