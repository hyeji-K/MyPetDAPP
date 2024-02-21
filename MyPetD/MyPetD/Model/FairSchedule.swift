//
//  FairSchedule.swift
//  MyPetD
//
//  Created by heyji on 2024/02/16.
//

import Foundation
 
struct FairSchedule {
    let month: String
    let title: String
    let date: String
    let location: String
    let tagName: String
}

extension FairSchedule {
    static var scheduleList = [
        FairSchedule(month: "1월", title: "케이캣페어 (가낳지모 캣페어)", date: "1월 19일 (금) ~ 1월 21일 (일)", location: "코엑스 Hall D", tagName: "#고양이"),
        FairSchedule(month: "2월", title: "케이펫페어 대전", date: "2월 2일 (금) ~ 2월 4일 (일)", location: "DCC 대전컨벤션센터", tagName: "#강아지"),
        FairSchedule(month: "2월", title: "케이펫페어 수원", date: "2월 23일 (금) ~ 2월 25일 (일)", location: "수원메쎄", tagName: "#강아지"),
        FairSchedule(month: "3월", title: "케이펫페어 세텍", date: "3월 15일 (금) ~ 3월 17일 (일)", location: "서울 SETEC", tagName: "#강아지"),
        FairSchedule(month: "4월", title: "제 28회 궁디팡팡 캣페스타", date: "4월 5일 (금) ~ 4월 7일 (일)", location: "부산 BEXCO", tagName: "#고양이"),
        FairSchedule(month: "4월", title: "마이펫페어 송도", date: "4월 12일 (금) ~ 4월 14일 (일)", location: "송도컨벤시아 3&4홀", tagName: "#강아지"),
        FairSchedule(month: "4월", title: "서울캣쇼", date: "4월 12일 (금) ~ 4월 14일 (일)", location: "일산 KINTEX 7홀", tagName: "#고양이"),
        FairSchedule(month: "4월", title: "케이펫페어 부산", date: "4월 26일 (금) ~ 4월 28일 (일)", location: "부산 BEXCO", tagName: "#강아지"),
        FairSchedule(month: "5월", title: "메가주 일산", date: "5월 17일 (금) ~ 5월 19일 (일)", location: "일산 KINTEX 2전시장", tagName: "#강아지"),
        FairSchedule(month: "5월", title: "제 29회 궁디팡팡 캣페스타", date: "5월 31일 (금) ~ 6월 2일 (일)", location: "서울 aT센터", tagName: "#고양이"),
        FairSchedule(month: "7월", title: "케이캣페어 (가낳지모 캣페어)", date: "7월 12일 (금) ~ 7월 14일 (일)", location: "학여울 SETEC", tagName: "#고양이"),
        FairSchedule(month: "9월", title: "제 30회 궁디팡팡 캣페스타", date: "9월 6일 (금) ~ 9월 8일 (일)", location: "일산 KINTEX", tagName: "#고양이"),
        FairSchedule(month: "10월", title: "부산펫쇼", date: "10월 18일 (금) ~ 10월 20일 (일)", location: "부산 BEXCO", tagName: "#강아지"),
        FairSchedule(month: "12월", title: "제 31회 궁디팡팡 캣페스타", date: "12월 6일 (금) ~ 12월 8일 (일)", location: "서울 SETEC", tagName: "#고양이")
    ]
}
