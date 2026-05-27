import SwiftUI

@main
struct BrentSchedulerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 980, minHeight: 680)
        }
    }
}

struct Course: Identifiable {
    let id = UUID()
    let period: Int
    let course: String
    let teacher: String
    let grade: Int
    let room: String
}

struct Student: Identifiable {
    let id = UUID()
    let name: String
    let grade: Int
    let credits: Double
}

struct ContentView: View {
    @State private var developers = 200.0
    @State private var monthlyPerDev = 60.0
    @State private var lostMinutes = 30.0
    @State private var loadedRate = 100.0
    @State private var packet = "Click Generate Source-Truth Packet."

    let blue = Color(red: 0, green: 47.0/255.0, blue: 167.0/255.0)

    let courses = [
        Course(period: 1, course: "Algebra II", teacher: "Ms. Rivera", grade: 10, room: "A101"),
        Course(period: 1, course: "English Literature", teacher: "Mr. Grant", grade: 11, room: "B204"),
        Course(period: 2, course: "Biology", teacher: "Dr. Chen", grade: 9, room: "Lab 1"),
        Course(period: 3, course: "Computer Science", teacher: "Ms. Swift", grade: 12, room: "Mac Lab")
    ]

    let students = [
        Student(name: "Student A", grade: 12, credits: 23.5),
        Student(name: "Student B", grade: 12, credits: 21.0),
        Student(name: "Student C", grade: 11, credits: 17.5)
    ]

    var annualToolSpend: Double { developers * monthlyPerDev * 12.0 }
    var annualLostTime: Double { developers * (lostMinutes / 60.0) * loadedRate * 260.0 }
    var combined: Double { annualToolSpend + annualLostTime }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("School Scheduler Workflow-Cost Demo")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(blue)

            Text("Native macOS proof: classrooms, teachers, grades, transcripts, scheduling constraints, and hidden workflow cost.")
                .foregroundStyle(.secondary)

            Text("The workflow is the evidence.")
                .font(.headline)

            HStack(spacing: 14) {
                metricCard("AI Tool Spend", money(annualToolSpend), "developers × monthly cost × 12")
                metricCard("Lost Workflow Time", money(annualLostTime), "lost minutes/day × loaded rate")
                metricCard("Combined Exposure", money(combined), "subscription + workflow drag")
            }

            GroupBox("Cost Model") {
                HStack {
                    labeledField("Developers", value: $developers)
                    labeledField("Monthly $/dev", value: $monthlyPerDev)
                    labeledField("Lost min/day", value: $lostMinutes)
                    labeledField("Loaded $/hr", value: $loadedRate)
                    Button("Generate Source-Truth Packet") { generatePacket() }
                }
                .padding(8)
            }

            HStack(alignment: .top, spacing: 18) {
                GroupBox("Generated Schedule") {
                    Table(courses) {
                        TableColumn("Period") { Text("\($0.period)") }
                        TableColumn("Course") { Text($0.course) }
                        TableColumn("Teacher") { Text($0.teacher) }
                        TableColumn("Grade") { Text("\($0.grade)") }
                        TableColumn("Room") { Text($0.room) }
                    }
                    .frame(height: 190)
                }

                GroupBox("Transcript / Graduation Check") {
                    Table(students) {
                        TableColumn("Student") { Text($0.name) }
                        TableColumn("Grade") { Text("\($0.grade)") }
                        TableColumn("Credits") { Text(String(format: "%.1f", $0.credits)) }
                        TableColumn("Status") {
                            Text(($0.grade < 12 || $0.credits >= 22.0) ? "On Track" : "Needs Review")
                                .foregroundStyle(($0.grade < 12 || $0.credits >= 22.0) ? .green : .red)
                        }
                    }
                    .frame(height: 190)
                }
            }

            GroupBox("Source-Truth Packet") {
                ScrollView {
                    Text(packet)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                }
                .frame(height: 150)
            }
        }
        .padding(24)
    }

    func metricCard(_ title: String, _ value: String, _ subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(blue)
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 4, y: 2)
    }

    func labeledField(_ label: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            TextField(label, value: value, format: .number)
                .textFieldStyle(.roundedBorder)
                .frame(width: 115)
        }
    }

    func money(_ value: Double) -> String {
        if value >= 1_000_000 {
            return String(format: "$%.2fM/yr", value / 1_000_000)
        }
        if value >= 1_000 {
            return String(format: "$%.0fk/yr", value / 1_000)
        }
        return String(format: "$%.0f/yr", value)
    }

    func generatePacket() {
        packet = """
        {
          "project": "Brent School Scheduler Workflow-Cost Demo",
          "cost_model": {
            "developers": \(Int(developers)),
            "monthly_per_developer": \(Int(monthlyPerDev)),
            "annual_tool_spend": \(Int(annualToolSpend)),
            "lost_minutes_per_day": \(Int(lostMinutes)),
            "loaded_hourly_rate": \(Int(loadedRate)),
            "annual_lost_workflow_time": \(Int(annualLostTime)),
            "combined_exposure": \(Int(combined))
          },
          "scheduler_scope": [
            "classrooms",
            "teachers",
            "grades",
            "courses",
            "transcripts",
            "room conflicts",
            "graduation checks"
          ],
          "principle": "The workflow is the evidence."
        }
        """
    }
}
