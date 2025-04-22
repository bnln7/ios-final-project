//
//  Task.swift
//  Final Project
//
//  Created by Tran Nguyen on 4/21/25.
//

import SwiftUI

struct Task: Identifiable {
    var id = UUID()
    var item: String
    var isDone: Bool
    
}

struct TaskView: View {
    @Binding var isDone:Bool
    var taskItem : String

    var body: some View {
        Button {
            isDone.toggle()
        } label: {
            HStack {
                Text(taskItem)
                    .foregroundColor(.white)
                Spacer()
                if isDone {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                isDone ? Color.blue : Color.blue.opacity(0.5)
            )
            .cornerRadius(10)
            .frame(width: 370)
        }
        
    }
}

struct StatefulPreviewWrapper<Value>: View where Value: Equatable {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> some View) {
        self._value = State(initialValue: initialValue)
        self.content = { AnyView(content($0)) }
    }

    var body: some View {
        content($value)
    }
}

#Preview {
    StatefulPreviewWrapper(false) { $isDone in
        TaskView(isDone: $isDone, taskItem: "poot")
    }
}
