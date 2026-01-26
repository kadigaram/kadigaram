//
//  ClockDialView.swift
//  Kadigaram
//
//  Created for Feature 006: Clock UI Improvements
//  Task: T016 - ClockDialView Implementation
//

import SwiftUI
import SixPartsLib
import KadigaramCore // Needed for AppConfig

/// Main view for the clock dial, integrating shapes, hands, and animations
struct ClockDialView: View {
    @ObservedObject var viewModel: ClockDialViewModel
    @EnvironmentObject var appConfig: AppConfig // Access global app settings
    
    // Computed property for localized label
    private var localizedNazhigaiLabel: String {
        switch appConfig.language {
        case .english:
            return "Nazhigai : Vinazhigai"
        case .tamil:
            return "நாழிகை : விநாழிகை"
        case .sanskrit:
            return "घटिका : विघटिका"
        case .telugu:
            return "గడియ : విగడియ"
        case .kannada:
            return "ಘಳಿಗೆ : ವಿಘಳಿಗೆ"
        case .malayalam:
            return "നാഴിക : വിനാഴിക"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let radius = width / 2
            
            ZStack {
                // 0. Static Background (Optimized)
                ClockDialBackground(design: viewModel.design)
                    .equatable() // CRITICAL: This allows SwiftUI to diff 'design' and skip body evaluation if unchanged
                
                // 3. Hour Markers
                // ...
                
                // 3. Hour Markers
                // ...
                
                // 4. Time Labels (24h clock starting from Sunrise)
                ForEach(viewModel.timeLabels) { label in
                    Text(label.text)
                        .font(.system(size: width * 0.05, weight: .bold, design: .rounded))
                        .foregroundColor(viewModel.design.colorPalette.accentBronze)
                        .fixedSize()
                        .offset(y: -radius * 1.08)
                        .rotationEffect(.degrees(label.angle))
                }
                
                // 5. Position Indicator Sphere
                let isDaytime = viewModel.vedicTime?.isDaytime ?? true
                
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                .white, 
                                isDaytime ? viewModel.design.colorPalette.indicatorColor : Color.gray
                            ]),
                            center: .topLeading,
                            startRadius: width * 0.01,
                            endRadius: width * 0.05
                        )
                    )
                    .frame(width: width * 0.08, height: width * 0.08)
                    .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                    .offset(y: -radius * 0.95)
                    .rotationEffect(.degrees(viewModel.nazhigaiAngle()))
                    .animation(viewModel.design.animationConfig.smoothHandMovement ? .linear : .spring(), value: viewModel.nazhigaiAngle())
                
                // 6. Center Digital Display
                VStack(spacing: width * 0.02) {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(viewModel.design.colorPalette.primaryGold)
                        .font(.system(size: width * 0.08))
                        .shadow(color: viewModel.design.colorPalette.primaryGold.opacity(0.5), radius: 5)
                    
                    if let time = viewModel.vedicTime {
                        Text("\(String(format: "%02d", time.nazhigai)) : \(String(format: "%02d", time.vinazhigai))")
                            .font(.system(size: width * 0.16, weight: .bold, design: .rounded))
                            .foregroundColor(viewModel.design.colorPalette.primaryGold)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                            .contentTransition(.numericText(countsDown: false))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Text(localizedNazhigaiLabel)
                            .font(.system(size: width * 0.05, weight: .medium, design: .rounded))
                            .foregroundColor(viewModel.design.colorPalette.accentBronze)
                        
                        Text(viewModel.timeSinceSunriseText)
                            .font(.system(size: width * 0.05, weight: .semibold, design: .monospaced))
                            .foregroundColor(viewModel.design.colorPalette.accentBronze)
                            .padding(.top, 4)
                    } else {
                        Text("-- : --")
                            .font(.system(size: width * 0.16, weight: .bold, design: .rounded))
                            .foregroundColor(viewModel.design.colorPalette.primaryGold.opacity(0.5))
                    }
                }
            }
            .frame(width: width, height: width) // Force container size to match dial, not Chakra
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY) // Explicit center alignment
        }
        .aspectRatio(1.0, contentMode: .fit)
        .onAppear {
            viewModel.startUpdating()
        }
        .onDisappear {
            viewModel.stopUpdating()
        }
    }
}

// MARK: - Previews

#Preview("Clock Dial View - Live") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ClockDialView(viewModel: ClockDialViewModel())
            .environmentObject(AppConfig()) // Inject AppConfig
            .padding()
    }
}

#Preview("Clock Dial View - Static 10:10") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ClockDialView(viewModel: ClockDialViewModel.preview(hour: 10, minute: 10))
            .environmentObject(AppConfig()) // Inject AppConfig
            .padding()
    }
}
