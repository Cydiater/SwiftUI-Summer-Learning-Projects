//
//  BookView.swift
//  Bookworm
//
//  Created by bytedance on 2021/7/4.
//

import SwiftUI

let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

struct BookView: View {
    var book: Book
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var showingView
    
    func deleteThisBook() {
        viewContext.delete(book)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        showingView.wrappedValue.dismiss()
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        Image(book.genre ?? "Fantasy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width)
                        Text(book.genre?.uppercased() ?? "FANTASY")
                            .foregroundColor(.white)
                            .font(.caption)
                            .bold()
                            .padding(5)
                            .background(Color.black)
                            .clipShape(Capsule())
                            .shadow(radius: 10)
                            .offset(x: -5, y: -5)
                    }
                    Text(book.name ?? "Unknown Book")
                        .font(.largeTitle)
                    Text(book.author ?? "Unknown Author")
                        .font(.subheadline)
                    RatingView(rating: .constant(book.rating), font: .title)
                        .padding()
                    Text(book.review ?? "No review")
                        .padding()
                }
            }
        }
        .navigationTitle("Book Detail")
        .navigationBarItems(trailing: Button(action: deleteThisBook) {
            Image(systemName: "trash")
        })
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        let book = Book(context: PersistenceController.preview.container.viewContext)
        book.author = "John Appleseed"
        book.name = "Steve Jobs"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Sample review"
        return NavigationView {
            BookView(book: book)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
