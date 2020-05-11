//
//  TaskRowView.swift
//  SwipeableView
//
//  Created by Vadzim Karonchyk on 5/7/20.
//  Copyright © 2020 koronchik. All rights reserved.
//

import Foundation
import SwiftUI

private extension UIColor {
    static let activeStateColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    static let inactiveStateColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
}

struct SwipableView<Content: View>: View {

    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0.0
    @State private var leftPadding: CGFloat = 0.0
    @State private var rightPadding: CGFloat = 0.0
    
    @State private var leftViewColor: UIColor = .inactiveStateColor
    @State private var rightViewColor: UIColor = .inactiveStateColor

    var contentView: Content
    
    var onLeftAction: EmptyAction
    var onRightAction: EmptyAction
    var onStartAction: EmptyAction

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    self.onLeftAction()
                    self.hideSwipe()
                }) {
                    Color(self.leftViewColor)
                        .cornerRadius(10)
                        .padding(.vertical, 14)
                        .frame(width: 100)
                        .overlay(
                            Text("Reset")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                .offset(x: self.leftPadding)
                
                self.contentView
                    .frame(width: geometry.size.width)
                    .offset(x: self.offset)
                    .gesture(
                        DragGesture()
                            .onChanged { self.onChanged($0, geometry: geometry) }
                            .onEnded { self.onEnded($0, geometry: geometry) }
                    )
                
                Button(action: {
                    self.onRightAction()
                    self.hideSwipe()
                }) {
                    Color(self.rightViewColor)
                        .cornerRadius(10)
                        .padding(.vertical, 14)
                        .frame(width: 100)
                        .overlay(
                            Text("Delete")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                .offset(x: self.rightPadding)
            }
        }
    }
    
    func hideSwipe() {
        withAnimation {
            self.offset = 0
            self.leftPadding = 0
            self.rightPadding = 0
        }
    }
    
    enum DragDirection {
        case toRight
        case toLeft
    }
    
    private func onChanged(_ value: DragGesture.Value, geometry: GeometryProxy) {
        onStartAction()
        let oldOffset = self.offset
        self.offset = self.lastOffset + value.translation.width
        let direction: DragDirection = oldOffset < self.offset ? .toRight : .toLeft
                
        switch direction {
        case .toLeft:
            if ((-80)...0).contains(self.offset) {
                self.leftPadding = self.offset
                self.rightPadding = self.offset
                self.rightViewColor = .inactiveStateColor
//                self.leftViewColor = .inactiveStateColor
            } else if self.offset < -geometry.size.width / 2 {
                self.leftPadding = self.offset
                withAnimation {
                    self.rightPadding = self.offset
                    self.rightViewColor = .activeStateColor
                }
            } else if (80..<(geometry.size.width / 2)).contains(self.offset) {
                withAnimation {
                    self.leftPadding = 80
                    self.leftViewColor = .inactiveStateColor
                }
            } else {
                self.leftPadding = self.offset
            }
            
//            if self.offset - self.leftPadding > 2 {
//                withAnimation {
//                    self.leftPadding = self.offset
//                }
//            } else {
//                self.leftPadding = self.offset
//            }
            
        case .toRight:
            if (0...80).contains(self.offset) {
                self.leftPadding = self.offset
                self.rightPadding = self.offset
                self.leftViewColor = .inactiveStateColor
//                self.rightViewColor = .inactiveStateColor
            } else if self.offset > geometry.size.width / 2 {
                self.rightPadding = self.offset
                withAnimation {
                    self.leftPadding = self.offset
                    self.leftViewColor = .activeStateColor
//                    self.rightViewColor = .inactiveStateColor
                }
            } else if ((-geometry.size.width / 2)...(-80)).contains(self.offset) {
                withAnimation {
                    self.rightPadding = -80
                    self.rightViewColor = .inactiveStateColor
                }
            } else {
                self.rightPadding = self.offset
            }
        }
        
    }
    
    private func onEnded(_ value: DragGesture.Value, geometry: GeometryProxy) {
        withAnimation {
            if self.offset < -geometry.size.width / 2 {
                self.offset = 0
                self.rightPadding = 0
                self.leftPadding = 0
                self.onRightAction()
            } else if (40...geometry.size.width / 2).contains(self.offset) {
                self.offset = 80
                self.leftPadding = self.offset
                self.rightPadding = 0
            } else if self.offset > geometry.size.width / 2 {
                self.offset = 0
                self.leftPadding = 0
                self.rightPadding = 0
                self.onLeftAction()
            } else if ((-geometry.size.width / 2)...(-40)).contains(self.offset) {
                self.offset = -80
                self.rightPadding = self.offset
                self.leftPadding = 0
            } else {
                self.offset = 0
                self.leftPadding = 0
                self.rightPadding = 0
            }
            self.lastOffset = self.offset
            self.leftViewColor = .inactiveStateColor
            self.rightViewColor = .inactiveStateColor
        }
    }
}

struct TaskView: View, Identifiable {
    
    var id: String {
        return viewModel.task.id
    }
    
    var viewModel: TaskViewModel
    
    var body: some View {
            VStack {
                HStack {
                    Text(self.viewModel.title)
                        .font(Font.system(size: 19, weight: .semibold))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .padding(.bottom, 8)

                HStack {
                    Text(self.viewModel.period)
                        .font(Font.system(size: 14, weight: .medium))
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(self.viewModel.timeLeft)
                        .font(Font.system(size: 14, weight: .medium))
                        .foregroundColor(Color.white)
                }
            }
            .padding(.all, 14)
            .background(Color(self.viewModel.color))
            .cornerRadius(12)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
    }
}

struct TaskRowView: View {
    
    var viewModel: TaskViewModel
    var onLeftAction: EmptyAction
    var onRightAction: EmptyAction
    var onStartAction: EmptyAction
    
    var body: some View {
        swipableView.frame(height: 90)
    }
    
    private var swipableView: SwipableView<TaskView> {
        SwipableView(
            contentView: TaskView(viewModel: viewModel),
            onLeftAction: onLeftAction,
            onRightAction: onRightAction,
            onStartAction: onStartAction
        )
    }
    
    func hideSwipe() {
        swipableView.hideSwipe()
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(viewModel: .init(task: .mock, color: .red),
                    onLeftAction: {},
                    onRightAction:  {},
                    onStartAction: {}).frame(height: 92)
    }
}
