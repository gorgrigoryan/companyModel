
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
            newTeam.add(member: member)
        }
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

