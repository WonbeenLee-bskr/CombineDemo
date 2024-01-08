//
//  MethodsExample.swift
//  CombineDemo
//
//  Created by 이원빈 on 2024/01/08.
//

import SwiftUI
import Combine

struct MethodsExample: View {
    
    @State private var firstAgree = false
    @State private var secondAgree = false
    @State private var thirdAgree = false
    @State private var buttonDisabled = true
    @State private var cancelBag = Set<AnyCancellable>()
    
    let firstAgreeSubject = PassthroughSubject<Bool, Never>()
    let secondAgreeSubject = PassthroughSubject<Bool, Never>()
    let thirdAgreeSubject = PassthroughSubject<Bool, Never>()
    
    let consentList = ["첫 번째 동의사항", "두 번째 동의사항", "세 번째 동의사항"]
    
    var body: some View {
        
        VStack {
            List {
                HStack {
                    Text(consentList[0])
                    Spacer()
                    if firstAgree {
                        Image(systemName: "circle")
                    }
                }
                .background(Color.white)
                .onTapGesture {
                    firstAgree.toggle()
                    firstAgreeSubject.send(firstAgree)
                }
                
                HStack {
                    Text(consentList[1])
                    Spacer()
                    if secondAgree {
                        Image(systemName: "circle")
                    }
                }
                .background(Color.white)
                .onTapGesture {
                    secondAgree.toggle()
                    secondAgreeSubject.send(secondAgree)
                }
                
                HStack {
                    Text(consentList[2])
                    Spacer()
                    if thirdAgree {
                        Image(systemName: "circle")
                    }
                }
                .background(Color.white)
                .onTapGesture {
                    thirdAgree.toggle()
                    thirdAgreeSubject.send(thirdAgree)
                }
            }
            
            Button {
                print("버튼 활성화")
            } label: {
                Text("Continue")
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .disabled(buttonDisabled)
            
        }
        
        .onAppear {
            firstAgreeSubject
//                .zip(secondAgreeSubject, thirdAgreeSubject)
//                .prefix(3)
            /// .zip 메서드
            /// 결합된 3개의 publisher 모두 발행이 일어났을 경우에만 sink 내부 스코프가 실행된다.
            /// 실행 후에는 이전 값을 기억하지 않고 3개의 publisher 모두 reset 한다.
            ///
            /// .prefix(n) 메서드
            /// 최초 n 회의 sink 스코프를 실행한 후 , 구독을 종료한다.
            ///
            /// .combineLatest 메서드
            /// 결합된 3개의 publisher 모두 발행이 일어났을 때 sink 내부 스코프가 시작되고,
            /// 실행 후에는 이전 값들이 남아있어 새로운 값이 들어오면 이전값들과 같이 계산되는 형태이다.
                .combineLatest(secondAgreeSubject, thirdAgreeSubject)
                .sink { (first, second, third) in
                    buttonDisabled = !(first && second && third)
                }
                .store(in: &cancelBag)
        }
    }
}

///  위처럼 combine을 이용하여 3가지 경우를 헤아리는 것이 @State 변수의 bool 값을 이용해 조건을 만들어주는 간단한 방법
///  ".disabled(!(firstAgree && secondAgree && thirdAgree))" 보다 어떤 장점을 가지기는 하는지 헤아려볼 필요가 있음.

#Preview {
    MethodsExample()
}
