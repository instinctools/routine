import SwiftUI

struct PlaceholderTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    
    var textChangedAction: (String) -> Void
        
    var body: some View {
        ZStack(alignment: .leading) {
            let isTextEmpty = text.isEmpty
            if isTextEmpty { placeholder }
            TextEditor(text: $text)
                .lineLimit(2)
                .opacity(isTextEmpty ? 0.2 : 1)
        }
        .onChange(of: text, perform: { value in
            textChangedAction(value)
        })
    }
}

//struct PlaceholderTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceholderTextField(placeholder: Text("Placeholder"), text: "", textChangedAction: {newText in })
//    }
//}
