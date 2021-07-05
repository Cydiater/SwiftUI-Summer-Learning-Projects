//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/7/4.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Book.name, ascending: true),
            NSSortDescriptor(keyPath: \Book.author, ascending: true),
        ],
        animation: .default)
    private var books: FetchedResults<Book>
    
    @State private var showingAddView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.id) { book in
                    NavigationLink(destination: BookView(book: book)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(book.name ?? "Unknown Book")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .font(.subheadline)
                            }
                            Spacer()
                            RatingView(rating: .constant(book.rating), font: .caption)
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationBarItems(trailing: Button(action: { showingAddView.toggle() }) {
                    Image(systemName: "plus")
                }
            )
            .navigationTitle("Bookworm")
            .sheet(isPresented: $showingAddView) {
                AddView()
            }
        }
    }

    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            offsets.map { books[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
