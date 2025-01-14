//
//  AlarmSnoozeView.swift
//  OneMoreMinute
//
//  Created by 권승용 on 1/14/25.
//

import SwiftUI

struct AlarmSnoozeView: View {
    let alarmTime: String
    let alarmTitle: String
    let snoozeTapped: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Image(.bell)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.top, 30)
                
                Text(alarmTime)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.timeLabel)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                
                VStack(spacing: 32) {
                    Text(alarmTitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.titleLabel)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.titleBackground)
                        }
                    
                    Text("알람 끄기")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 22)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.snoozeButtonBackground)
                        }
                        .onTapGesture {
                            snoozeTapped()
                        }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(.wrapperBackground)
                    .shadow(color: .wrapperStroke, radius: 1)
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    AlarmSnoozeView(
        alarmTime: "07:30",
        alarmTitle: "아침 운동하기",
        snoozeTapped: {
            print("Tapped")
        }
    )
}
