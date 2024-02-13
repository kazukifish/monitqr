//
//  GraphCViewController.swift
//  MONITQR3
//
//  Created by 出田和毅 on 2023/11/04.
//

import UIKit
import Foundation
import DGCharts // Chartsというライブラリは2023.6.8にDGChartsに移行した模様

class GraphCViewController: UIViewController {
    
    // func calc()用の変数を定義
    var lines: [String] = [] // テキストファイルのデータを一旦格納するための変数
    let timeStandard = 25 // 読み取り時間間隔
    let qrLength = 41 // QRコードデータのデータ長
    var newDataCompare: Int = 0 // 空データ検出用時刻データ格納変数（new）
    var oldDataCompare: Int = 0 // 空データ検出用時刻データ格納変数（old）ここに関しては名称の変更を後で検討する
    var newList: [Double] = [] // 初期値はnil、グラフ作成に使用する最終的なリスト
    var xMax: Double? // x軸作成用Double型変数
    var xMax2: Double?
    var yMax: Double? // 左y軸作成用Double型変数
    var yMax2: Double?
    // var listCntId: Double = 0 // for文の中で使用
    // var xList: [Double] = []

    // 応答値用変数
    var new1Double: Double?
    var new2Double: Double?
    var new3Double: Double?
    var new4Double: Double?
    var new5Double: Double?
    var lostQrCount: Int = 0 // 読み取り損ねたQRコードデータの個数をカウント（初期値は0）
    
    // calc button
    let calcButton = UIButton()
    
    // グラフ描画用のプロパティ
    var chartView: ScatterChartView!
    var chartDataSet: ScatterChartDataSet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // データ前処理メソッドの実行ボタン
        calcButton.setTitle("Graph Creation", for: .normal)
        calcButton.backgroundColor = UIColor.white
        calcButton.setTitleColor(.white, for: .normal)
        calcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        calcButton.layer.borderColor = UIColor.black.cgColor
        calcButton.layer.borderWidth = 2
        calcButton.layer.opacity = 0.8
        calcButton.backgroundColor = .darkGray
        calcButton.addTarget(self, action: #selector(calc), for: .touchUpInside)
        self.view.addSubview(calcButton)
        calcButton.translatesAutoresizingMaskIntoConstraints = false
        calcButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        calcButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        calcButton.widthAnchor.constraint(equalToConstant: 320).isActive = true // iPhone8の最大値に設定
        calcButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
}
// データ前処理用メソッドcalc()を記述
extension GraphCViewController {
    @objc func calc() {
        // 指定したテキストファイル（このプロジェクトでは"projectB.txt"のcontentsを任意のリスト型変数に書き出す）
        let fileName = "projectC.txt"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
            lines = fileContents.components(separatedBy: "\n")
            // 改行に付随して何かしら処理を行うならここで記述する
        } catch {
            print("エラー: \(error)")
        }
        // データファイルを読み込み、グラフ化しやすい形に整形する
        for data in lines {
            // 空データが存在した場合fatel errorが起こるので文字列の長さで処理分けをする
            if data.count == qrLength {
                // QRコードデータのスライス
                let sepId = data.startIndex
                // 時刻データ
                let sep0 = data.index(sepId, offsetBy: 10) // 時刻データ
//                let sepMonth = data.index(sepId, offsetBy: 1)
//                let sepMonth2 = data.index(sepId, offsetBy: 2)
//                let month = Int(data[sepMonth...sepMonth2]) // 月データ
//                let sepDay = data.index(sepId, offsetBy: 3)
//                let sepDay2 = data.index(sepId, offsetBy: 4)
//                let day = Int(data[sepDay...sepDay2]) // 日データ
                let sepTime = data.index(sepId, offsetBy: 5)
                let sepTime2 = data.index(sepId, offsetBy: 6)
                let time = Int(data[sepTime...sepTime2]) // 時データ
                let sepMin = data.index(sepId, offsetBy: 7)
                let sepMin2 = data.index(sepId, offsetBy: 8)
                let min = Int(data[sepMin...sepMin2]) // 分データ
                let sepSec = data.index(sepId, offsetBy: 9)
                let sepSec2 = data.index(sepId, offsetBy: 10)
                let sec = Int(data[sepSec...sepSec2]) // 秒データ
                
                // 応答値部分の切り出し（冗長化しているのは否めないが、これでうまくできているのでしばらくは様子見）
                let sep1 = data.index(sep0, offsetBy: 1) // （2023.11.1：0→1に変更）
                let sep2 = data.index(sepId, offsetBy: 16) // 数値データ1
                let sep3 = data.index(sep2, offsetBy: 1)
                let sep4 = data.index(sepId, offsetBy: 22) // 数値データ2
                let sep5 = data.index(sep4, offsetBy: 1)
                let sep6 = data.index(sepId, offsetBy: 28) // 数値データ3
                let sep7 = data.index(sep6, offsetBy: 1)
                let sep8 = data.index(sepId, offsetBy: 34) // 数値データ4
                let sep9 = data.index(sep8, offsetBy: 1)
                let sep10 = data.index(sepId, offsetBy: 40) // 数値データ5
                
                // 単一応答値（正負の比較）
                let negativePoint = "100000"
                let new1 = String(data[sep1...sep2])
                if new1 < negativePoint {
                    new1Double = Double(new1)
                } else {
                    new1Double = ((Double(new1) ?? 0)-100000)*(-1) // 現状、負の値が現れることは想定していないが、今後のため
                }
                let new2 = String(data[sep3...sep4])
                if new2 < negativePoint {
                    new2Double = Double(new2)
                } else {
                    new2Double = ((Double(new2) ?? 0)-100000)*(-1)
                }
                let new3 = String(data[sep5...sep6])
                if new3 < negativePoint {
                    new3Double = Double(new3)
                } else {
                    new3Double = ((Double(new3) ?? 0)-100000)*(-1)
                }
                let new4 = String(data[sep7...sep8])
                if new4 < negativePoint {
                    new4Double = Double(new4)
                } else {
                    new4Double = ((Double(new4) ?? 0)-100000)*(-1)
                }
                let new5 = String(data[sep9...sep10])
                if new5 < negativePoint {
                    new5Double = Double(new5)
                } else {
                    new5Double = ((Double(new5) ?? 0)-100000)*(-1)
                }
                
                // 時刻データの比較による欠損データの推定
                newDataCompare = (time ?? 0)*3600 + (min ?? 0)*60 + (sec ?? 0) // Int型
                
                // 新しいデータファイルが空ならそのままデータを書き込む（newList）
                if newList.isEmpty {
                    // 初期値の追加
                    newList.append(new1Double!/100)
                    newList.append(new2Double!/100)
                    newList.append(new3Double!/100)
                    newList.append(new4Double!/100)
                    newList.append(new5Double!/100)
                    // new→oldへ
                    oldDataCompare = newDataCompare
                // データファイルに既にデータが存在する場合
                } else {
                    // QRコードが認識でき、かつ一つ前のQRコードも認識できている場合
                    if newDataCompare - oldDataCompare <= 30 { //ここの30は後で定数化して置き換える
                        // 時刻差が30秒以下なら、そのままデータを追加
                        newList.append(new1Double!/100)
                        newList.append(new2Double!/100)
                        newList.append(new3Double!/100)
                        newList.append(new4Double!/100)
                        newList.append(new5Double!/100)
                        // new→oldへ
                        oldDataCompare = newDataCompare
                    // 少なくとも一つ目のQRコードが認識できていない場合
                    } else {
                        let lostQr = (newDataCompare - oldDataCompare) / timeStandard
                        // new→oldへ
                        oldDataCompare = newDataCompare
                        for _ in 0 ..< lostQr {
                            for _ in 0 ..< 5 {
                                newList.append(-1) // 空データ部分は-1に置き換える
                                lostQrCount += 1
                            }
                        }
                    }
                }
            // 空データを発見した場合、スキップしてループを続行
            } else {
                continue
            }
        }
        // x軸の最大値を動的に設定
        xMax = Double(newList.count + 10)
        xMax2 = xMax!/12 // xMax/12は(x/60)*5で5秒に1回データを取得していることを示す。
        // y軸の最大値を動的に決定（現状では最大値の1.5倍をy軸の最大値としている）
        yMax = newList.max() ?? 0
        yMax2 = yMax!*1.5 // yMax!*1.5はInt型だとできないのでやや面倒な方法にしている
        
        // 以下display()だったコード
        chartView = ScatterChartView(frame: CGRect(x: 30, y: 200, width: 250, height: 250))
        
        // x軸ラベル
        let xLabel = UILabel()
        xLabel.text = "time(min)"
        xLabel.font = .systemFont(ofSize: 10.5)
        xLabel.textAlignment = .center
        xLabel.frame = CGRect(x: 75, y: 250, width: 100, height: 30)
        chartView.addSubview(xLabel)
        
        // y軸ラベル
        let yLabel = UILabel()
        yLabel.text = "output current(nA)"
        yLabel.font = .systemFont(ofSize: 10.5)
        yLabel.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi)/(-2))) // yLabelの回転
        yLabel.textAlignment = .center
        yLabel.frame = CGRect(x: -20, y: 80, width: 20, height: 100)
        chartView.addSubview(yLabel)
        
        // QRコードデータの回収率を表示
        let recoveryRate = UILabel()
        let rate: Float = (Float(newList.count) - Float(lostQrCount))/Float(newList.count)*100 // 回収率
        recoveryRate.text = "Recovery Rate : " + String(rate) + "%"
        recoveryRate.font = .systemFont(ofSize: 10.5)
        recoveryRate.textColor = .black
        recoveryRate.backgroundColor = .white
        recoveryRate.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        recoveryRate.layer.borderWidth = 1.5
        recoveryRate.textAlignment = .center
        recoveryRate.frame = CGRect(x: 0, y: -30, width: 150, height: 30)
        chartView.addSubview(recoveryRate)
        

        var dataEntries = [ChartDataEntry]()
        
        for (xValue, yValue) in newList.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(xValue)/12, y: yValue) // Double(xValue)/12は(x/60)*5で5秒に1回データを取得していることを示す。
            dataEntries.append(dataEntry)
//            debug
//            print(xValue)
//            print(yValue)
        }
//        print(dataEntries)
        chartDataSet = ScatterChartDataSet(entries: dataEntries, label: "output current")
        chartDataSet.scatterShapeSize =  1.0
        chartDataSet.colors = [NSUIColor.black]
        chartDataSet.drawValuesEnabled = false // グラフ上への値の非表示
        // 反映
        chartView.data = ScatterChartData(dataSets: [chartDataSet])
        // 軸の設定
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .bottom //x軸を下側とする
        chartView.xAxis.axisMaximum = xMax2! // x軸の最大値
        chartView.xAxis.axisMinimum = 0 // x軸の最小値
        chartView.leftAxis.axisMaximum = yMax2!// 左y軸の最大値
        chartView.leftAxis.axisMinimum = 0 // 左y軸の最小値
        chartView.rightAxis.enabled = false // 右軸は非表示
//        chartView.backgroundColor = .gray //どこまでがchartViewなのか調べやすい
        view.addSubview(chartView)
    }
}

