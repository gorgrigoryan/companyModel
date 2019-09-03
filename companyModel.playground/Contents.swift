
class Company {
    var name: String
    var employees = [Employee]()
    var teams = [Team]()
    static var count = 0
    
    init(name: String) {
        Company.count += 1
        self.name = name
    }
    
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
    
    deinit {
        Company.count -= 1
    }
}

class Employee {
    enum Gender: String {
        case man = "Man"
        case woman = "Woman"
        case other = "Other"
    }
    static var count = 0
    var name: String
    var gender: Gender
    weak var team: Team?
    
    var description: CustomStringConvertible {
        var description = "Name: " + name + ", Gender: "
        
        if let team = team {
            description += ", Team: " + team.name
        }
        
        return description
    }
    
    init(name: String, gender: Gender) {
        Employee.count += 1
        self.name = name
        self.gender = gender
    }
    
    deinit {
        Employee.count -= 1
    }
}

class Developer: Employee {
    enum Platform: String {
        case iOS = "iOS"
        case Android = "Android"
        case Web = "Web"
        case Windows = "Windows?"
    }
    var platform: Platform?
    
    override var description: CustomStringConvertible {
        var description = "Name: " + name + ", Gender: " + gender.rawValue + ", Profession: "
            + platform!.rawValue + " Developer"

        if let team = team {
            description += ", Team: " + team.name
        }

        return description
    }
    
    convenience init(name: String, gender: Gender, platform: Platform) {
        self.init(name: name, gender: gender)
        self.platform = platform
    }
    
    func develop() {
        print("Developing", platform!.rawValue)
    }
}

class Designer: Employee {
    override var description: CustomStringConvertible {
        var description = "Name: " + name + ", Gender: " + gender.rawValue + ", Profession: Designer"
        
        if let team = team {
            description += ", Team: " + team.name
        }
        
        return description
    }
    
    func design() {
        print("I am designer")
    }
}

class ProductManager: Employee {
    var project: String?
    
    override var description: CustomStringConvertible {
        var description = "Name: " + name + ", Gender: " + gender.rawValue + ", Profession: Product manager"
        
        if let team = team {
            description += ", Team: " + team.name
        }
        
        return description
    }
    
    convenience init(name: String, gender: Gender, project: String) {
        self.init(name: name, gender: gender)
        self.project = project
    }
    
    func manage(project: String) {
        print("Managing", project)
    }
}

class Team {
    enum EmployeeType : Hashable, CaseIterable {
        case productManager
        case designer
        case developer
    }
    static var count = 0
    var name: String
    var members: [EmployeeType:[Employee]] = [:]
    
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
        Team.count += 1
        self.name = name
        
        for teamMember in EmployeeType.allCases {
            members[teamMember] = []
        }
    }
    
    deinit {
        
        Team.count -= 1
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
    print(employee.name, ", Team: ", employee.team!.name)
}
print("\nTeams: ")
for team in company!.teams {
    print(team.name)
    for teamMember in Team.EmployeeType.allCases {
        print(team.members[teamMember]!.count)
    }
}

company = nil

print(Company.count)
print(Employee.count)
print(Team.count)
