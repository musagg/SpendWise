import SwiftUI

struct AddPersonView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TransactionListViewModel
    
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            .navigationTitle("Add Person")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    if !name.isEmpty && !email.isEmpty {
                        viewModel.addPerson(Person(name: name, email: email))
                        dismiss()
                    }
                }
            )
        }
    }
} 