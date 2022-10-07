//
//  TaskViewModel.swift
//  CalendarTask
//
//  Created by Leng Mouyngech on 21/5/22.
//

import SwiftUI

class TaskViewModel: ObservableObject{
    
    // Sample Tasks
    
    @Published var storedTasks: [Task] = [
        
        Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1654483340)),
        Task(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week", taskDate: .init(timeIntervalSince1970: 1654483340)),
        Task(taskTitle: "Prototype", taskDescription: "Make and send prototype", taskDate: .init(timeIntervalSince1970: 1654501340)),
        Task(taskTitle: "Check asset", taskDescription: "Start checking the assets", taskDate: .init(timeIntervalSince1970: 1654501340)),
        Task(taskTitle: "Team Party", taskDescription: "Make fun with team mates", taskDate: .init(timeIntervalSince1970: 1654490540)),
        Task(taskTitle: "Client Meeting", taskDescription: "Explain Project to clinet", taskDate: .init(timeIntervalSince1970: 1654490540)),
        Task(taskTitle: "New Project", taskDescription: "Discuss next project with team", taskDate: .init(timeIntervalSince1970: 1654458140)),
        Task(taskTitle: "App Proposal", taskDescription: "Meet client for next App Proposal", taskDate: .init(timeIntervalSince1970: 1654458140)),
    ]
    
    // MARK: Current Week Days
    
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    
    @Published var currentDay: Date = Date()
    
    // MARK: Filtering Today Tasks
    
    @Published var filteredTasks: [Task]?
    
    // MARK: Intializing
    
    init(){
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
//     MARK: Filter Today Tasks
    func filterTodayTasks(){
    
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
            
            .sorted{ task1, task2 in
                return task2.taskDate < task1.taskDate
            }
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
    }

    func fetchCurrentWeek(){
        
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeek.append(weekday)
            }
        }
    }
    
    // MARK: Extraction Date
    func extractDate(date: Date, format: String)->String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // MARK: Checking id current Date is T
    func isToday(date: Date)->Bool{
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: Checking if the currentHour is task hour
    func isCurrentHour(date: Date)-> Bool{
        
        let calendar = Calendar.current
        
        let hour =  calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date() )
        
        return hour == currentHour
    }
}


