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
            register(employee: member, team: newTeam)
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
        print("Employee \(name) deinitialized")
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
    
    init(name: String) {
        Team.count += 1
        self.name = name
        
        for teamMember in EmployeeType.allCases {
            members[teamMember] = []
        }
    }
    
    func add(member: Employee) {
        switch member {
        case is Developer:
            members[.developer]!.append(member)
            member.team = self
        case is Designer:
            members[.designer]!.append(member)
            member.team = self
        case is ProductManager:
            members[.productManager]!.append(member)
            member.team = self
        default:
            break
        }
    }
    
    deinit {
        print("Team \(name) deinitialized")
        Team.count -= 1
    }
}
var company: Company? = Company(name: "Monster Inc.")

company!.createTeam(name: "Dream Profile", members: [
    ProductManager(name: "Roz", gender: .woman, project: "Profile photo"),
    Designer(name: "Boo", gender: .other),
    Developer(name: "James", gender: .man, platform: .iOS),
    Developer(name: "Mike", gender: .man, platform: .Android)
])

company!.createTeam(name: "Dream Settings", members: [
    ProductManager(name: "Randall", gender: .man, project: "Profile settings"),
    ProductManager(name: "Steve", gender: .man, project: "Account settings"),
    Designer(name: "Jony", gender: .man),
    Designer(name: "Celia", gender: .woman),
    Developer(name: "Fungus", gender: .other, platform: .Web),
    Developer(name: "Rex", gender: .other, platform: .iOS),
    Developer(name: "Woodie", gender: .man, platform: .Android)
])

company!.createTeam(name: "Dream Feed", members: [
    ProductManager(name: "Pete", gender: .man, project: "Feedbacks classification"),
    ProductManager(name: "Henry", gender: .man, project: "Feedbacks"),
    Designer(name: "Bile", gender: .man),
    Developer(name: "Flint", gender: .man),
    Developer(name: "Needleman", gender: .other),
    Developer(name: "Buzz", gender: .man)
])

print("Employees of company \(company!.name):")
var counter = 1
for employee in company!.employees {
    print("Employee \(counter):", employee.name, ", Team: ", employee.team!.name)
    counter += 1
}

print("\nTeams of company \(company!.name):")
for team in company!.teams {
    print(team.name, "Team")
    for teamMember in Team.EmployeeType.allCases {
        switch teamMember {
        case .designer:
            print("Designers:", team.members[teamMember]!.count)
        case .developer:
            print("Developers:", team.members[teamMember]!.count)
        case .productManager:
            print("Product Managers:", team.members[teamMember]!.count)
        }
    }
}

company = nil

print(Company.count)
print(Employee.count)
print(Team.count)
