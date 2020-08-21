//
//  Schedule.swift
//  CalendarSample
//
//  Created by 森川正崇 on 2020/05/10.
//  Copyright © 2020 morikawamasataka. All rights reserved.
//

import Foundation
class Schedule{
    var date: String
    var events:[String]
    var howmanyEvents:Int
    init(date:String,events:[String],howmanyEvents:Int) {
        self.date = date
        self.events = events
        self.howmanyEvents = howmanyEvents
    }
}
