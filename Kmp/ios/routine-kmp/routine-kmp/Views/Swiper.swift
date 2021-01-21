import SwiftUI

struct Swiper: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct RowContent<Content: View> : View {
    
    let width : CGFloat
    
    @State var offset: CGSize
    @State var scale : CGFloat = 0.5
    
    let startButtons: [SwipeButton]
    let endButtons: [SwipeButton]
    let content: () -> Content
    
    let maxStartOffset: CGFloat
    let maxEndOffset: CGFloat
    
    init(
        width: CGFloat = 60,
        startButtons: [SwipeButton] = [],
        endButtons: [SwipeButton] = [],
        content: @escaping () -> Content
    ) {
        self.width = width
        self.startButtons = startButtons
        self.endButtons = endButtons
        self.content = content
        
        maxStartOffset = CGFloat(startButtons.count) * width
        maxEndOffset = CGFloat(endButtons.count) * width
        _offset = State<CGSize>.init(initialValue: CGSize(width: -60, height: 0))
    }
    
    var body : some View {
        GeometryReader { geo in
            Text("Offset = \(self.offset.width)")
            HStack (spacing : 0){
                ForEach (startButtons, id: \.title) { button in
                    SwipeButtonView(
                        button: button,
                        scale: scale,
                        width: width,
                        height: geo.size.height
                    )
                }
                
                self.content()
                    .frame(width : geo.size.width, alignment: .leading)
                
                ForEach (endButtons, id: \.title) { button in
                    SwipeButtonView(
                        button: button,
                        scale: scale,
                        width: width,
                        height: geo.size.height
                    )
                }
            }
            .border(Color.black)
            .offset(self.offset)
            .animation(.spring())
            .gesture(DragGesture()
                        .onChanged { gesture in
                            print("offset is \(gesture.translation.width)")
                            self.offset.width = gesture.translation.width
                        }
                        .onEnded { _ in
                            if self.offset.width < -50 {
                                self.scale = 1
                                self.offset.width = -maxEndOffset
                            } else if self.offset.width > 50 {
                                self.scale = 1
                                self.offset.width = maxStartOffset
                            } else {
                                self.scale = 0.5
                                self.offset = .zero
                            }
                        }
            )
        }
    }
}

struct SwipeButtonView: View {
    
    let button: SwipeButton
    let scale: CGFloat
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack {
            Text(button.title)
                .font(.caption)
                .scaleEffect(scale)
            Image(button.iconName)
                .scaleEffect(scale)
        }
        .frame(width: width, height: height)
        .background(button.background)
        .onTapGesture {
            self.button.action()
        }
    }
}

struct SwipeButton {
    let title: String
    let iconName: String
    let background: Color
    let action: () -> Void
}

struct RowContentView_Previews: PreviewProvider {
    static var previews: some View {
        RowContent(
            startButtons: [
                SwipeButton(
                    title: "Reset",
                    iconName: "Reset Task",
                    background: .purple,
                    action: {}
                )
            ],
            endButtons: [
                SwipeButton(
                    title: "Delete",
                    iconName: "Delete Task",
                    background: .orange,
                    action: {}
                )
            ]
        ){
            Text("test row content")
        }
        .previewLayout(.fixed(width: 400, height: 60))
    }
}
