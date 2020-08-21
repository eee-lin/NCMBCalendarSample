//
//  ViewController.swift
//  CalendarSample
//
//  Created by 森川正崇 on 2020/05/07.
//  Copyright © 2020 morikawamasataka. All rights reserved.
//

import UIKit
//これ忘れずに!
import FSCalendar
import NCMB
//TODO: ネスト解消
class ViewController: UIViewController{
    // Q3: lodeData()する際に，どんなデータ構造にする?
    // Q4: カレンダーの日付/月を切り替える毎に下の表の値も変更して欲しい..→loadData()をどこで呼ぶ?
    //スケジュールモデルをインスタンス化(設計図を実体化)

    //タップした日付を入れる変数(初期値は今日)
    var selectedDate = Date()
    //予定が入っている日付を格納する配列
    var scheduledDates = [String]()
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var scheduleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FSCalendarの関数をViewControllerに委任する
        calendar.delegate = self
        //ViewControllerからFSCalendarに値を渡す
        calendar.dataSource = self
        //ViewControllerからTavleViewに値を渡す
        scheduleTableView.dataSource = self
        //TableViewの不要な線を消す
        scheduleTableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    //segueを用いた値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segueがtoAddScheduleだったら
        if segue.identifier == "toAddSchedule" {
            // 遷移先ViewCntrollerを取得
            let nextView = segue.destination as! AddScheduleViewController
            // 値渡し
            nextView.passedDate = selectedDate
        }
    }
}

//FSCalendarに関する処理
extension ViewController:FSCalendarDelegate,FSCalendarDataSource{
    //日付をタップした際に呼ばれる関数
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date

    }

    //日付の下にタイトルをつける関数
    func calendar(_ calendar: FSCalendar!, subtitleFor date: Date) -> String?  {
        let dateString = dateToString(date: date, format: DateFormatter.dateFormat(fromTemplate: "ydMMM(EEE)", options: 0, locale: Locale(identifier: "ja_JP"))!)
        if self.scheduledDates.contains(dateString) {
            return
        }
        return ""
    }
    //日付の下に点をつける関数
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = dateToString(date: date, format: DateFormatter.dateFormat(fromTemplate: "ydMMM(EEE)", options: 0, locale: Locale(identifier: "ja_JP"))!)
        if self.scheduledDates.contains(dateString) {
            return
        }
        return 0
    }
    //日付の下に画像を表示する関数(点と被ってしまうのでどちらかを用いる)
    func calendar(_ calendar: FSCalendar!, imageFor date: Date) -> UIImage? {
        let dateString = dateToString(date: date, format: DateFormatter.dateFormat(fromTemplate: "ydMMM(EEE)", options: 0, locale: Locale(identifier: "ja_JP"))!)
        if self.scheduledDates.contains(dateString) {
            return UIImage(systemName: "hare")
        }
        return UIImage()
    }
    
    //カレンダーの月が変更した時に呼ばれる関数
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        selectedDate =  calendar.currentPage
    }
    
}

extension ViewController{
    //date型→String型に変換する関数
    func dateToString(date:Date,format:String)->String{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    //String型→date型に変換する関数
    func StringToDate(string:String,format:String)->Date{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
        
    }
}

//TableViewに関する処理
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateString = dateToString(date: selectedDate, format: DateFormatter.dateFormat(fromTemplate: "ydMMM(EEE)", options: 0, locale: Locale(identifier: "ja_JP"))!)
        if self.scheduledDates.contains(dateString) {
            return
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let dateString = dateToString(date: selectedDate, format: DateFormatter.dateFormat(fromTemplate: "ydMMM(EEE)", options: 0, locale: Locale(identifier: "ja_JP"))!)
        if self.scheduledDates.contains(dateString) {
            cell.textLabel?.text =
            print(schedules[dateString]?.events[indexPath.row])
            return cell
        }
        return cell
    }
    
}

extension ViewController{
    func loadData(){
        // TODO: 一緒に実装していこう
        //NCMBから値を取得
        let query = NCMBQuery(className: "Schedules")
        query?.whereKey("userId", equalTo: UserDefaults.standard.object(forKey: "userId"))
        query?.findObjectsInBackground({ (results, error) in
            if error != nil {
                print(error)
            } else {
                
            }
        })
    }
}
