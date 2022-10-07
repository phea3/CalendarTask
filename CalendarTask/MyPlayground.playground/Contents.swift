import UIKit
var currentWeek: [Date] = []
var currentDay: Date = Date()
let format = "EEEE"
let formatter = DateFormatter()
formatter.dateFormat = format
var Day = formatter.string(from: currentDay)
if Day == "Monday" || Day == "ចន្ទ" {
    Day = "Monday"
} else if Day == "Tuesday" || Day == "អង្គារ"{
    Day = "Tuesday"
}
else if Day == "Wednesday" || Day == "ពុធ"{
    Day = "Wednesday"
}
else if Day == "Thursday" || Day == "ព្រហស្បតិ៍"{
    Day = "Thursday"
}
else if Day == "Friday" || Day == "សុក្រ"{
    Day = "Friday"
}
else if Day == "Saturday" || Day == "សៅរ៍"{
    Day = "Saturday"
}
else if Day == "Sunday" || Day == "អាទិត្យ"{
    Day = "Sunday"
}
else {
    Day = "Sunday"
}
