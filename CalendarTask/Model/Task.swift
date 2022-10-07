//
//  Task.swift
//  CalendarTask
//
//  Created by Leng Mouyngech on 21/5/22.
//

import SwiftUI

// Task Model
struct Task: Identifiable{
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
