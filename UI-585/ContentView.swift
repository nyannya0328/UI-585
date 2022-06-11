//
//  ContentView.swift
//  UI-585
//
//  Created by nyannyan0328 on 2022/06/11.
//

import SwiftUI

struct ContentView: View {
    @State var tags : [Tag] = rawTags.compactMap { tag -> Tag in
            .init(name: tag)
    }
    @State var currentValue : Int = 1
    
    @State var text : String = ""
    var body: some View {
        NavigationStack{
            
            VStack{

                Picker("", selection: $currentValue) {

                      Text("Leading")
                        .tag(0)

                    Text("Center")
                      .tag(1)
                    Text("Trailing")
                      .tag(2)


                }
                .pickerStyle(.segmented)
                .padding(.bottom,10)
                
                
                LayoutView(alignment:currentValue == 0 ? .leading : currentValue == 1 ? .center : .trailing, spacing: 10){
                    
                    
                    ForEach($tags){$tag in
                        
                        Toggle(tag.name, isOn: $tag.isSelected)
                            .toggleStyle(.button)
                            .buttonStyle(.bordered)
                            .tint(.red)
                        
                    }
                }
                .animation(.interactiveSpring(response: 0.5,dampingFraction: 0.5,blendDuration: 0.5), value: currentValue)
                
                
                HStack{
                    
                    TextField("Search", text: $text,axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...5)
                    
                    
                    Button("ADD"){
                        
                        tags.append(Tag(name: text))
                        text = ""
                        
                        
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 10))
                    .disabled(text == "")
                  
                    
                }
                
                
                
            }
            .navigationTitle("Layout")
            .padding(10)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LayoutView : Layout{
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return .init(width: proposal.width ?? 0, height: proposal.height ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        
        var orign = bounds.origin
        let maxWidht = bounds.width
        
        var row : ([LayoutSubviews.Element],Double) = ([],0.0)
        
        var rows : [([LayoutSubviews.Element],Double)] = []
        
        
        for view in subviews{
            
            let viewSize = view.sizeThatFits(proposal)
            
            if (orign.x + viewSize.width + spacing) > maxWidht{
                
                row.1 = (bounds.maxX - orign.x + bounds.minX + spacing)
                
                rows.append(row)
                row.0.removeAll()
                
                
                orign.x = bounds.origin.x
                
                
                row.0.append(view)
                orign.x += (viewSize.width + spacing)
                
                
                
            }
            
            else{
                
                row.0.append(view)
                orign.x += (viewSize.width + spacing)
            }
            
            
            
            
        }
        
        
        if !row.0.isEmpty{
            
            row.1 = (bounds.maxX - orign.x + bounds.minX + spacing)
            rows.append(row)
        }
        
        orign = bounds.origin
        
        for row in rows{
            
            orign.x = (alignment == .leading ? bounds.minX : (alignment == .trailing ? row.1 : row.1 / 2))
            
            for view in row.0{
                
                
                let viewSize = view.sizeThatFits(proposal)
                
                view.place(at: orign, proposal: proposal)
                orign.x += (viewSize.width + spacing)
            }
            
            let maxHeight = row.0.compactMap { view -> CGFloat? in
                
                return view.sizeThatFits(proposal).height
            }.max() ?? 0
            
            orign.y += (maxHeight + spacing)
            
            
            
        }
        
        
        
    }
    
  
    
    
    var alignment : Alignment
    var spacing: CGFloat
    
    init(alignment: Alignment, spacing: CGFloat) {
        self.alignment = alignment
        self.spacing = spacing
    }
    
    
}

var rawTags: [String] = [
    "SwiftUI","Xcode","Apple","WWDC 22","iOS 16","iPadOS 16","macOS 13","watchOS 9","Xcode 14","API's"
]

struct Tag : Identifiable{
    
    var id = UUID().uuidString
    var name : String
    var isSelected : Bool = false
}
