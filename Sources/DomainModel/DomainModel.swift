struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount:  Int
    var currency: String
    
    init(amount : Int, currency : String)  {
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ secondCurrency: String) -> Money{
        let amountinUSD = convertUSD();
        
        if(secondCurrency == "GBP"){
            return  Money(amount: Int((Double(amountinUSD)/2.0).rounded()), currency: secondCurrency)
        }
        else if (secondCurrency == "EUR"){
            return  Money(amount: Int((Double(amountinUSD)*1.5).rounded()), currency: secondCurrency)
        }
        else if (secondCurrency == "CAN"){
            return  Money(amount: Int((Double(amountinUSD)*1.25).rounded()), currency: secondCurrency)
        }
        else {
            return  Money(amount: amountinUSD, currency: secondCurrency);
        }
    }
    
    func convertUSD() -> Int {
        var amountinUSD = self.amount
        
        if(self.currency == "GBP"){
            amountinUSD = Int((Double(amountinUSD)*2.0).rounded());
        }
        if(self.currency == "EUR"){
            amountinUSD = Int((Double(amountinUSD)/1.5).rounded());
        }
        if(self.currency == "CAN"){
            amountinUSD = Int((Double(amountinUSD)/1.25).rounded());
        }
        return amountinUSD
    }
    
    func add (_ secondCurrency: Money) -> Money{
        var convertedCurrency = self;
        if(convertedCurrency.currency != secondCurrency.currency){
            convertedCurrency =  convertedCurrency.convert(secondCurrency.currency)
        }
        return Money(amount: (secondCurrency.amount + convertedCurrency.amount), currency: secondCurrency.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String;
    var type: JobType;
    
    init (title inputTitle: String, type inputType: JobType){
        self.title = inputTitle;
        self.type = inputType;
    }
    
    func calculateIncome(_ hoursWorked: Int) -> Int{
        switch self.type {
        case .Hourly(let hourlyWage):
            return Int((hourlyWage*Double(hoursWorked)).rounded());
        case .Salary(let yearlyWage):
            return Int(yearlyWage);
        }
    }
    
    func raise(byAmount: Int){
        switch self.type {
        case .Hourly(let hourlyWage):
            self.type = JobType.Hourly(hourlyWage + Double(byAmount));
        case .Salary(let yearlyWage):
            self.type = JobType.Salary(yearlyWage + UInt(byAmount));
        }
    }
    
    func raise(byAmount: Double){
        switch self.type {
        case .Hourly(let hourlyWage):
            self.type = JobType.Hourly(hourlyWage + byAmount);
        case .Salary(let yearlyWage):
            self.type = JobType.Salary(yearlyWage + UInt(byAmount));
        }
    }
    
    func raise(byPercent: Double){
        switch self.type {
        case .Hourly(let hourlyWage):
            self.type = JobType.Hourly(hourlyWage * (1.0 + byPercent));
        case .Salary(let yearlyWage):
            self.type = JobType.Salary(UInt((Double(yearlyWage) * (1.0 + byPercent)).rounded()));
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String;
    var lastName: String;
    var age: Int;
    private var myJob: Job?
    var job: Job?{
        get { return myJob }
        set {
            if(age >= 18){
                myJob = newValue;
            }
        }
    };
    private var mySpouse: Person?
    var spouse: Person? {
        get { return mySpouse }
        set {
            if(age >= 18){
                mySpouse = newValue;
            }
        }
    };
    
    init (firstName inputFirst: String, lastName inputLast: String,
          age inputAge: Int) {
        firstName = inputFirst;
        lastName = inputLast;
        age = inputAge;
    }
    
    func toString() -> String{
        let firstNameComp = "firstName:" + firstName + " "
        let lastNameComp = "lastName:" + lastName + " "
        let ageComp = "age:" + String(age) + " "
        var jobComp = "job:nil "
        if(job != nil){
            jobComp = "job:" + (job!.title) + " "
        }
        var spouseComp = "spouse:nil"
        if(spouse != nil){
            spouseComp = "spouse:" + spouse!.firstName
        }
        return "[Person: " + firstNameComp + lastNameComp + ageComp + jobComp + spouseComp + "]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    init(spouse1: Person, spouse2: Person){
        if(spouse1.spouse == nil && spouse2.spouse == nil){
            members = [spouse1, spouse2]
        }
        else {
            members = []
        }
    }
    
    
    func haveChild(_ newChild: Person) -> Bool{
        let spouses = [members[0], members[1]]
        for parent in spouses{
            if(parent.age >= 21){
                members.append(newChild)
                return true;
            }
        }
        return false;
    }
    
    func householdIncome() -> Int {
        
        var returnVal = 0;
        for person in members {
            let currJob = person.job
            if(currJob != nil){
                returnVal = returnVal + currJob!.calculateIncome(2000)
            }
        }
        return returnVal;
    }
}
