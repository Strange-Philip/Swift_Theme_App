//
//  ThemeChangeView.swift
//  ThemeApp
//
//  Created by Philip Abakah on 25/12/2023.
//

import SwiftUI

struct ThemeChangeView: View {
    var scheme : ColorScheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @Namespace private var animation
    @State private var cirecleOffset: CGSize
    init(scheme: ColorScheme) {
        self.scheme = scheme
        let isDark = scheme == .dark
        self._cirecleOffset = .init(initialValue: CGSize(width: isDark ? 30: 105, height: isDark ? -25: -150))
    }
    var body: some View {
        VStack(spacing: 15){
            Circle().fill(userTheme.color(scheme).gradient)
                .frame(width: 150,height: 150)
                .mask{
                    Rectangle()
                        .overlay{
                            Circle()
                                .offset(cirecleOffset)
                                .blendMode(.destinationOut)
                        }
                }
            Text("Choose a style")
                .font(.title2.bold())
                .padding(.top , 25)
            
            Text("Pop or subtle, Day or Night.\nCustomize your interface")
                .multilineTextAlignment(.center)
            
            HStack(spacing : 0){
                ForEach(Theme.allCases, id: \.rawValue){
                    theme in Text(theme.rawValue)
                        .padding(.vertical, 10)
                        .frame(width: 100)
                        .background{
                            ZStack{
                                if userTheme == theme{
                                    Capsule().fill(Color("ThemeBG")).matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        
                                }
                            }
                            .animation(.linear, value : userTheme)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture{
                            userTheme = theme
                        }
                }
            }
            .padding(3)
            .background(.primary.opacity(0.06), in : Capsule())
            .padding(.top , 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height : 410)
        .background(Color("ThemeBG"))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal , 15)
        .environment(\.colorScheme, scheme)
        .onChange(of: scheme, perform: { value in
            let isDark = value == .dark
            withAnimation(.spring()){
                cirecleOffset = CGSize(width: isDark ? 30: 105, height: isDark ? -25: -150)
            }
        })
        
        
    }
}

struct ThemeChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
enum Theme: String , CaseIterable{
    case systemDefault = "System"
    case light = "Light"
    case dark = "Dark"
    
    
    
    func color(_ scheme: ColorScheme )-> Color{
        switch self {
        case .systemDefault :
            return scheme == .dark ? Color("Moon") : Color("Sun")
            
        case .light :
            return Color("Sun")
        case  .dark :
            return Color("Moon")
        }
    }
    
    var colorScheme : ColorScheme? {
        switch self {
        case .systemDefault :
            return nil
        case .light:
            return .light
        case .dark :
            return .dark
        }
    }
}
