//
//  Home.swift
//  CalendarTask
//
//  Created by Leng Mouyngech on 21/5/22.
//

import SwiftUI

struct Home: View {
    
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: lazy Stack With Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                
                Section {
                    // MARK: Current Week View
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10) {
                            
                            ForEach(taskModel.currentWeek,id: \.self){day in
                                
                                VStack(spacing: 10) {
                                    
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    
                                    //EEE will return day as MON, TUE, ... etc
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .fill()
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                // MARK: Foreground Style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                // MARK: Capsule Shape
                                .frame(width: 45, height: 90)
                                .background(
                                    
                                    ZStack{
                                        
                                        // MARK: Matched Geometry Effect
                                        if taskModel.isToday(date: day){
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                            
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation{
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TasksView()
                    
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: Tasks View
    func TasksView()-> some View{

        LazyVStack(spacing: 20 ) {

            if let tasks = taskModel.filteredTasks{

                if tasks.isEmpty{
                    Text("No tasks found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y:100)
                }
                else {
                    ForEach(tasks){task in
                        TaskCardView(task: task)
                    }
                }

            }
            else{
                // MARK: Progress View
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        // MARK: Updating Tasks
        .onChange(of: taskModel.currentDay) { newValue in
            taskModel.filterTodayTasks()
        }
    }
    
    // MARK: Task Card View
    
    func TaskCardView(task: Task) -> some View {
        
        HStack(alignment: .top, spacing: 30){
            VStack(spacing: 10){
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        
                        Circle()
                            .stroke(.black,lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate) ? 0.8 : 1)
                    Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            VStack{
                HStack(alignment: .top, spacing: 10){
                    VStack(alignment: .leading, spacing: 12){
                        
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                    .hLeading()
                    
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
                if taskModel.isCurrentHour(date: task.taskDate){
                    // Mark: Team Members
                    HStack(spacing: 0){
                        
                        HStack(spacing: -10){
                            ForEach(["user1", "user2", "user3"],id: \.self){user in
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                        Circle()
                                            .stroke(.black, lineWidth: 5)
                                    )
                            }
                        }
                    .hLeading()
                        
                        // MARK : Check Button
                        Button {
                            
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }

                    }
                    .padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate) ? 15 : 0 )
            .padding(.bottom,taskModel.isCurrentHour(date: task.taskDate) ? 0 : 10 )
            .hLeading()
            .background(
                Color("Black")
                .cornerRadius(25)
                .opacity(taskModel.isCurrentHour(date: task.taskDate) ? 1 : 0)
                )
        }
        .hLeading()
    }

    
    // MARK: Header
    func HeaderView() -> some View {
        
        HStack(spacing: 10){
            
            VStack(alignment: .leading, spacing: 10){
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                              .foregroundColor(Color.gray)
                               
                          Text("Today")
                              .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image("user1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }

        }
        .padding()
        .padding(.top, getSefeArea().top)
        .background(Color.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//MARK: UI Design Helper functions
extension View{
    
    func hLeading()-> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func hTrailing()-> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func hCenter()-> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: Safe Area
    func getSefeArea() -> UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        guard let safeArea =  screen.windows.first?.safeAreaInsets else{
            return .zero
        }
return safeArea
    }

}

