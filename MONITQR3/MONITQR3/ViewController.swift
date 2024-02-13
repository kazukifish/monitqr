//
//  ViewController.swift
//  MONITQR3
//
//  Created by 出田和毅 on 2023/10/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let label = UILabel()
    let fileNameList: [String] = ["Monitoring 1", "Monitoring 2", "Monitoring 3"] // データファイルの数は3個に固定する
    var fileTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景色の設定
        view.backgroundColor = .white
        
        label.text = "projectを選択してください"
        label.textColor = .black
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        // fileTableViewの設定（styleも追加したい）
        fileTableView.delegate = self // UITableViewDelegate
        fileTableView.dataSource = self // UITableViewDataSource
        self.view.addSubview(fileTableView)
        fileTableView.translatesAutoresizingMaskIntoConstraints = false
        fileTableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 100).isActive = true
        fileTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        fileTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        
        // リストの編集に関するボタン
        navigationItem.rightBarButtonItem = editButtonItem

    }
    // メモリ警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // リストの編集に関するメソッドの継承
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        fileTableView.isEditing = editing
    }
}

extension ViewController {
    // UITableViewDataSourceメソッド: セルの作成とデータの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        // リストのデータからセルにテキストを設定
        cell.textLabel?.text = fileNameList[indexPath.row]
        return cell
    }
    // リストの表示に必要なメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNameList.count
    }
    //　編集モード中だけ削除を可能に
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    // tableのcellをタップで任意のviewに遷移できるかの実験
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let projectA = ProjectAViewController()
            // let selectedDataA = fileNameList[indexPath.row]
            navigationController?.pushViewController(projectA, animated: true)
        case 1:
            let projectB = ProjectBViewController()
            navigationController?.pushViewController(projectB, animated: true)
        case 2:
            let projectC = ProjectCViewController()
            navigationController?.pushViewController(projectC, animated: true)
        default:
            print("その他のセルが指定されました")
        }
    }
}


