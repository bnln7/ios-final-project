
//
//  ItemCreationView.swift
//  Final Project
//
//  Created by Tran Nguyen on 4/21/25.
//

import SwiftUI

struct ItemCreationView: View {
    @Binding var task: String
    var onDone: () -> Void
    
    var body: some View {
        NavigationStack{
            VStack{
                
                HStack{
                    TextField("Task Name", text: $task)
                        .padding()
                }
                Spacer()
                
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onDone()
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    ItemCreationView(task: .constant("stuff"), onDone: {})
}
