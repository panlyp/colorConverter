//
//  ContentView.swift
//  ColorConverter
//
//  Created by user on 29/10/2020.
//

import SwiftUI
//import Introspect

class ConvertableColor: ObservableObject {
    
    enum Field { case none, rgb, hex }
    
    @Published var isUpdating: Field = .none
    
    @Published var rgbString: String = "" {
        didSet {
            guard isUpdating != .hex else { return }
            isUpdating = .rgb
            let rgbValues = rgbString.components(separatedBy: " ")
            let range: ClosedRange<Double> = 0...255
            guard rgbValues.count == 3 else { return }
            if let r = Double(rgbValues[0]), range ~= r,
               let g = Double(rgbValues[1]), range ~= g,
               let b = Double(rgbValues[2]), range ~= b {
                color = Color.init(red: r/255, green: g/255, blue: b/255)
            }
        }
    }
    
    @Published var hexString: String = "" {
        didSet {
            guard isUpdating != .rgb else { return }
            isUpdating = .hex
            if hexString.count == 6 {
                color = Color.init(hex: hexString)
            }
        }
    }
    
    @Published var color: Color = Color.clear {
        didSet {
            switch isUpdating {
            case .rgb:
                hexString = String(color.description.trimmingCharacters(in: ["#"]).prefix(6))
                isUpdating = .none
            case .hex:
                let defaultValue = -1
                let r = color.redComponent ?? defaultValue
                let g = color.greenComponent ?? defaultValue
                let b = color.blueComponent ?? defaultValue
                rgbString = "\(r) \(g) \(b)"
                isUpdating = .none
            default:
                break
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var convertableColor = ConvertableColor()
    @State var shouldShowBackground: Bool = false
    
    let radius: CGFloat = 8

    var body: some View {
        VStack {
            Spacer()
            ZStack {
//                if shouldShowBackground {
//                    HStack(spacing: 0.0) {
//                        Rectangle().fill(Color.black)
//                        Rectangle().fill(Color.white)
//                    }
//                }
                RoundedRectangle(cornerRadius: radius)
                    .fill($convertableColor.color.wrappedValue)
                    .padding()
            }
            HStack {
                TextField("RGB", text: $convertableColor.rgbString)
                TextField("HEX", text: $convertableColor.hexString)
            }
            Spacer()
//            Button("Toggle Background") {
//                shouldShowBackground.toggle()
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
