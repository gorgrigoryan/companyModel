
class Company {
    var name: String
    var employees = [Employee]()
    var teams = [Team]()
    
    func register(employee: Employee, team: Team) {
        team.add(member: employee)
    }
    
    func createTeam(name: String, members: [Employee]) {
        let newTeam = Team(name: name)
        for member in members {
            employees.append(member)
            newTeam.add(member: member)
        }
        teams.append(newTeam)
    }
    
    init(name: String) {
        self.name = name
    }
}

class Employee {
    enum Gender {
        case man
        case woman
        case other
    }
    var name: String
    var gender: Gender
    var team: Team?
    var description : CustomStringConvertible {
        return ""
    }
    
    init(name: String, gender: Gender) {
        self.name = name
        self.gender = gender
    }
}

class Developer: Employee {
    enum Platform {
        case iOS
        case Android
        case Web
        case Windows
    }
    var platform: Platform?
    
    func develop() {
        
    }
    
    convenience init(name: String, gender: Gender, platform: Platform) {
        self.init(name: name, gender: gender)
        self.platform = platform
    }
}

class Designer: Employee {
    func design() {
        
    }
}

class ProductManager: Employee {
    var project: String?
    
    convenience init(name: String, gender: Gender, project: String) {
        self.init(name: name, gender: gender)
        self.project = project
    }
    
    func manage(project: String) {
        
    }
}

class Team {
    enum TeamMemberType : Hashable, CaseIterable {
        case productManager
        case designer
        case developer
    }
    var name: String
    var members: [TeamMemberType:[Employee]] = [:]
    
    func add(member: Employee) {
        switch member {
        case is Developer:
            members[.developer]?.append(member)
            member.team = self
        case is Designer:
            members[.designer]?.append(member)
            member.team = self
        case is ProductManager:
            members[.productManager]?.append(member)
            member.team = self
        default:
            break
        }
    }
    
    init(name: String) {
        self.name = name
        
        for teamMember in TeamMemberType.allCases {
            members[teamMember] = []
        }
    }
}
var company: Company? = Company(name: "Monster Inc.")

var roz = ProductManager(name: "Roz", gender: .woman, project: "Profile photo")
var boo = Designer(name: "Boo", gender: .other)
var james = Developer(name: "James", gender: .man, platform: .iOS)
var mike = Developer(name: "Mike", gender: .man, platform: .Android)
company!.createTeam(name: "Dream Profile", members: [roz, boo, james, mike])

var randall = ProductManager(name: "Randall", gender: .man, project: "Profile settings")
var steve = ProductManager(name: "Steve", gender: .man, project: "Account settings")
var jony = Designer(name: "Jony", gender: .man)
var celia = Designer(name: "Celia", gender: .woman)
var fungus = Developer(name: "Fungus", gender: .other, platform: .Web)
var rex = Developer(name: "Rex", gender: .other, platform: .iOS)
var woodie = Developer(name: "Woodie", gender: .man, platform: .Android)
company!.createTeam(name: "Dream Settings", members: [randall, steve, jony, celia, fungus, rex, woodie])

var pete = ProductManager(name: "Pete", gender: .man, project: "Feedbacks classification")
var henry = ProductManager(name: "Henry", gender: .man, project: "Feedbacks")
var bile = Designer(name: "Bile", gender: .man)
var flint = Developer(name: "Flint", gender: .man)
var needleman = Developer(name: "Needleman", gender: .other)
var buzz = Developer(name: "Buzz", gender: .man)
company!.createTeam(name: "Dream Feed", members: [pete, henry, bile, flint, needleman, buzz])

print("Employees: ")
for employee in company!.employees {
    print(employee.name)
}
print("\nTeams: ")
for team in company!.teams {
    print(team.name)
}
