import SwiftUI

struct SplitExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TransactionListViewModel
    
    @State private var title = ""
    @State private var amount = ""
    @State private var category = Category.food
    @State private var selectedPeople: Set<UUID> = []
    @State private var paidByPersonID: UUID?
    @State private var splitType: SplitTransaction.SplitType = .equal
    @State private var customSplits: [UUID: Double] = [:]
    @State private var showingAddPerson = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title", text: $title)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text("\(category.icon) \(category.rawValue)")
                        }
                    }
                }
                
                Section(header: Text("Paid By")) {
                    Picker("Paid By", selection: $paidByPersonID) {
                        Text("Select a person").tag(nil as UUID?)
                        ForEach(viewModel.people) { person in
                            Text(person.name).tag(person.id as UUID?)
                        }
                    }
                }
                
                Section(header: Text("Split Between")) {
                    ForEach(viewModel.people) { person in
                        Toggle(person.name, isOn: Binding(
                            get: { selectedPeople.contains(person.id) },
                            set: { isSelected in
                                if isSelected {
                                    selectedPeople.insert(person.id)
                                } else {
                                    selectedPeople.remove(person.id)
                                }
                            }
                        ))
                    }
                }
                
                Section(header: Text("Split Type")) {
                    Picker("Split Type", selection: $splitType) {
                        Text("Equal").tag(SplitTransaction.SplitType.equal)
                        Text("Percentage").tag(SplitTransaction.SplitType.percentage)
                        Text("Custom").tag(SplitTransaction.SplitType.custom)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if splitType != .equal {
                        ForEach(viewModel.people.filter { selectedPeople.contains($0.id) }) { person in
                            HStack {
                                Text(person.name)
                                Spacer()
                                TextField(splitType == .percentage ? "%" : "$", 
                                        value: Binding(
                                            get: { customSplits[person.id] ?? 0 },
                                            set: { customSplits[person.id] = $0 }
                                        ),
                                        format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 80)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Split Expense")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: HStack {
                    Button("Add Person") {
                        showingAddPerson = true
                    }
                    Button("Save") {
                        saveExpense()
                    }
                }
            )
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView(viewModel: viewModel)
            }
        }
    }
    
    private func saveExpense() {
        guard let amount = Double(amount),
              !title.isEmpty,
              let paidByPerson = viewModel.people.first(where: { $0.id == paidByPersonID }),
              !selectedPeople.isEmpty else { return }
        
        let transaction = Transaction(
            title: title,
            amount: amount,
            category: category
        )
        
        let splitBetween = viewModel.people.filter { selectedPeople.contains($0.id) }
        
        let splitTransaction = SplitTransaction(
            transaction: transaction,
            splitBetween: splitBetween,
            paidBy: paidByPerson,
            splitType: splitType,
            customSplits: splitType != .equal ? customSplits : nil
        )
        
        viewModel.addSplitTransaction(splitTransaction)
        dismiss()
    }
} 