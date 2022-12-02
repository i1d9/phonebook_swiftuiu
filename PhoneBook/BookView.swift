//
//  BookView.swift
//  PhoneBook
//
//  Created by Ian Nalyanya on 01/12/2022.
//

import SwiftUI
import CoreData

struct BookView: View {
    
    let persistenceController = ContactController.shared
    
    @State var firstname: String = ""
    @State var secondname: String = ""
    @State var phone: String = ""
    @State var email: String = ""
    @State var favourite: Bool = false
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode
        
    
    @FetchRequest(
        sortDescriptors: [])
    private var people: FetchedResults<Person>
    
    @State private var presented  = false
    
    var body: some View {
        NavigationView {
            Group {
                
                List {
                    ForEach(Array(people.enumerated()), id: \.element) {index,  person in
                        NavigationLink {
                            Text(person.first_name ?? "First Name")
                        } label: {
                            HStack {
                                Image(systemName: person.favourite ? "heart.fill" : "heart").foregroundColor(.red).onTapGesture {
                                    
                                }
                                Text(person.first_name ?? "Person Name")
                                Text(person.second_name ?? "Person Name")
                            }
                     
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                
                                people[index].first_name = "Haha"
                                
                                do {
                                    try viewContext.save()
                                } catch {
                                    
                                    let nsError = error as NSError
                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                                
                            } label: {
                                Label("Edit", systemImage: "square.and.pencil")
                            }
                            .tint(.indigo)
                        }
                        
                    }.onDelete(perform: deleteBooks)
                    
                }.sheet(isPresented: $presented, content: {
                    VStack(alignment: .leading,spacing: 16){
                        
                        TextField("First Name", text: $firstname).padding(16).background(Color(hue: 1.0, saturation: 0.0, brightness: 0.93)).cornerRadius(8)
                        TextField("Second Name", text: $secondname).padding(16).background(Color(hue: 1.0, saturation: 0.0, brightness: 0.93)).cornerRadius(8)
                        TextField("Email Address", text: $email).padding(16).background(Color(hue: 1.0, saturation: 0.0, brightness: 0.93)).cornerRadius(8)
                        TextField("Phone Number", text: $phone).padding(16).background(Color(hue: 1.0, saturation: 0.0, brightness: 0.93)).cornerRadius(8)
                        
                        Button(action: {
                            
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save").frame(maxWidth: .infinity).foregroundColor(.white)
                            
                        }).padding(16).background(Color(hue: 0.739, saturation: 0.741, brightness: 0.8)).cornerRadius(16)
                        
                        
                    }.padding(8)
                })
                .toolbar{
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            
                            
                            presented = true
//                            let person = Person(context: viewContext)
//
//                            person.first_name = ""
//                            person.second_name = ""
//                            person.email = "johndoe@example.com"
//                            person.phone = ""
//                            person.favourite = true
//
//
//
//                            do {
//                                try viewContext.save()
//                            } catch {
//
//                                let nsError = error as NSError
//                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                            }
                            
                            
                        }) {
                            Text("New")
                        }
                    }
                    
                    
                    
                    
                }

            }.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let person = people[offset]

            // delete it from the context
            viewContext.delete(person)
        }

        // save the context
        try? viewContext.save()
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView().environment(\.managedObjectContext, ContactController.preview.container.viewContext)
    }
}
