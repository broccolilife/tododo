//
//  OnboardingView.swift
//  Tododo
//
//  Created by Eva (OpenClaw Agent)
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    private let pages: [(icon: String, title: String, subtitle: String)] = [
        ("checkmark.circle.fill", "Welcome to Tododo", "A calming, healing approach to getting things done"),
        ("tray.full.fill", "Organize with Buckets", "Group your tasks into gentle categories that match your life"),
        ("flame.fill", "Build Your Streak", "Stay motivated with daily streaks and gentle reminders"),
        ("sparkles", "Ready to Begin", "Take a breath, and let's start organizing your world"),
    ]

    var body: some View {
        ZStack {
            AuroraBackground()

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 24) {
                            Spacer()
                            Image(systemName: pages[index].icon)
                                .font(.system(size: 72))
                                .foregroundStyle(.indigo)
                                .symbolEffect(.pulse, options: .repeating)
                            Text(pages[index].title)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                            Text(pages[index].subtitle)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        hasSeenOnboarding = true
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}
