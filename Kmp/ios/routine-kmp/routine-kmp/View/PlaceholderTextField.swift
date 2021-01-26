import SwiftUI

struct PlaceholderTextField: View {
    var placeholder: Text
    @State var text: String = ""
    var editingChanged: (Bool) -> Void = { _ in }
    var commit: () -> Void = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .lineLimit(2)
        }
    }
}

struct PlaceholderTextField_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderTextField(placeholder: Text("Placeholder"))
    }
}
