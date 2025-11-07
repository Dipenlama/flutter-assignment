// 1..
// Abstract base class
abstract class BankAccount {
  // --- Private fields (using underscore makes them private in Dart) ---
  String _accountNumber;
  String _accountHolderName;
  double _balance;

  // --- Constructor ---
  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // --- Getters --- setter --
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;

  set holderName(String name) => _accountHolderName = name;

  void updateBalance(double amount) {
    _balance = amount;
  }
 // -- Abstract Methods --
  void deposit(double amount);
  void withdraw(double amount);

  void displayInfo() {
    print("Account Number: $accountHolderName");
    print("Account Holder Name : $_accountHolderName");
    print("Balance : $_balance");
    print("\n-------------------------------\n");
  }
}

// Savings Account
class SavingsAccount extends BankAccount implements InterestBearing {
  int withdrawalCount = 0;

  SavingsAccount(super.accNo, super.name, super.balance);

  @override
  double calculateInterest() {
    return balance * 0.02;
  }

  @override
  void deposit(double amount) {
    updateBalance(balance + amount);
  }
   @override
  void withdraw(double amount) {
    if (withdrawalCount >= 3) {
      print("Withdrawal limit reached for Savings Account!");
      return;
    }
    if (balance - amount < 500) {
      print("Cannot withdraw! Minimum balance of \$500 required.");
      return;
    }

    withdrawalCount++;
    updateBalance(balance - amount);
  }
}

class InterestBearing {}

// Checking Account
class CheckingAccount extends BankAccount {
  CheckingAccount(super.accNo, super.name, super.balance);
@override
  void deposit(double amount) {
    updateBalance(balance + amount);
  }

  @override
  void withdraw(double amount) {
    updateBalance(balance - amount);
    if (balance < 0) {
      print("Overdraft! \$35 fee applied.");
      updateBalance(balance - 35);
    }
  }
}

// Premium Account
class PremiumAccount extends BankAccount implements InterestBearing {
  PremiumAccount(super.accNo, super.name, super.balance);

  @override
  double calculateInterest() {
    return balance * 0.05;
  }
 @override
  void deposit(double amount) {
    updateBalance(balance + amount);
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 10000) {
      print(
        "Cannot withdraw! Premium account must maintain \$10,000 minimum balance.",
      );
      return;
    }
    updateBalance(balance - amount);
  }
}

// Bank class
class Bank {
  List<BankAccount> accounts = [];

  void addAccount(BankAccount account) {
    accounts.add(account);
    print("Account created successfully: ${account.accountNumber}");
  }
  BankAccount? findAccount(String accNo) {
    for (var a in accounts) {
      if (a.accountNumber == accNo) {
        return a;
      }
    }
    print("Account not found!");
    return null;
  }

  void transfer(String fromAcc, String toAcc, double amount) {
    var sender = findAccount(fromAcc);
    var receiver = findAccount(toAcc);

    if (sender == null || receiver == null) return;

    sender.withdraw(amount);
    receiver.deposit(amount);

    print("Transfer of \$${amount} from $fromAcc to $toAcc completed.\n");
  }

  void report() {
    print("\n=== All Bank Accounts Report ===");
    for (var acc in accounts) {
      acc.displayInfo();
    }
  }
}
// Example main()
void main() {
  Bank bank = Bank();

  var acc1 = SavingsAccount("SA001", "John Doe", 1200);
  var acc2 = CheckingAccount("CA001", "Mike Smith", 200);
  var acc3 = PremiumAccount("PA001", "Sarah Lee", 15000);

  bank.addAccount(acc1);
  bank.addAccount(acc2);
  bank.addAccount(acc3);

  acc1.withdraw(300);
  acc1.withdraw(200);
  acc1.withdraw(100); // limit

  acc2.withdraw(300);

  bank.transfer("PA001", "SA001", 1000);

  bank.report();
}