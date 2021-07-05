//
//  AddView.swift
//  Bookworm
//
//  Created by bytedance on 2021/7/4.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var showingSheet
    @State private var name = ""
    
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var rating: Int16 = 3
    @State private var review = ""
    
    func addBook() {
        let newBook = Book(context: viewContext)
        newBook.name = name
        newBook.author = author
        newBook.genre = genre
        newBook.rating = rating
        newBook.review = review
        do {
            try viewContext.save()
            showingSheet.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Author", text: $author)
                Picker("Genre", selection: $genre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                
                Section {
                    HStack {
                        Text("Rating")
                        Spacer()
                        RatingView(rating: $rating, noTap: false)
                    }
                    TextField("Review", text: $review)
                }
            }
            .navigationTitle("Add Book")
            .navigationBarItems(trailing: Button(action: addBook) {
                Text("Save")
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
