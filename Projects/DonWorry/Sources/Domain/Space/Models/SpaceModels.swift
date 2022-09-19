//
//  Space.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum SpaceModels {

    struct Space {
        let id: Int
        let adminID: Int
        let title, status, shareID: String
        let isTaker: Bool
        let isAllPaymentCompleted: Bool
        let payments: [SpacePayment]
    }

    struct SpacePayment {
        let id: Int
        let amount: Int
        let isCompleted: Bool
        let user: SpaceUser

        init(
            id: Int,
            amount: Int,
            isCompleted: Bool,
            user: SpaceUser
        ) {
            self.id = id
            self.amount = amount
            self.isCompleted = isCompleted
            self.user = user
        }
    }

    struct SpaceUser {
        let id: Int
        let nickname: String
        let imgURL: String?

        init(
            id: Int,
            nickname: String,
            imgURL: String?
        ) {
            self.id = id
            self.nickname = nickname
            self.imgURL = imgURL
        }
    }

    // MARK: 정산방 리스트 조회

    enum FetchSpaceList {
        typealias Response = [Space]

    }

    // MARK: 정산방 가져오기
    enum FetchSpace {
        struct Request {
            let spaceID: Int
        }
        typealias Response = Space
    }
    // MARK: 정산방 생성하기

    enum CreateSpace {
        struct Request {
            var title: String
        }

        struct Response {
            let id: Int
            let adminID: Int
            let status: String
            let title, shareID: String
        }
    }

    // MARK: 정산방 코드로 입장하기

    enum JoinSpace {
        struct Request {
            var shareID: String
        }

        struct Response {
            let id: Int
            let adminID: Int
            let status: String
            let title, shareID: String
        }
    }

    // MARK: 정산방 이름 수정하기

    enum EditSpaceTitle {
        struct Request {
            let title: String
        }

        struct Response {
            let id: Int
            let adminID: Int
            let status: String
            let title, shareID: String
        }
    }

    // MARK: 정산방 나가기 & 삭제하기

    enum LeaveSpace {
        struct Request {
            let isStatusOpen: Bool
            let isAdmin: Int
            let spaceID: Int
        }
    }

    enum LeaveSpaceInProgress {
        struct Request {
            let spaceID: Int
        }
    }

    // MARK: 정산 알고리즘 시작

    enum StartPaymentAlogrithm {
        struct Request {
            let id: Int
            let status: Status

            enum Status: String {
                case open
                case progress
                case close

                var uppercase: String {
                    return self.rawValue.uppercased()
                }

                static func getSelf(_ status: String) -> Status {
                    if status == "OPEN" {
                        return .open
                    } else if status == "CLOSE" {
                        return .close
                    } else {
                        return .progress
                    }
                }
            }


        }
    }

    // MARK: 성공했는데 응답이 없어도 되는 경우

    enum Empty {
        struct Response {}
    }
}
