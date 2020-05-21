import SwiftUI

struct LabelledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 12, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line.frame(width: 24)
            Text(label).padding(.all, 10).foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }
    }
}

struct LabelledDivider_Previews: PreviewProvider {
    static var previews: some View {
        LabelledDivider(label: "Label")
    }
}
