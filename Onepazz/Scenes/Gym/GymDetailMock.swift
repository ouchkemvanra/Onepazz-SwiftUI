//
//  GymDetailMock.swift
//  Onepazz
//
//  Created by Claude on 10/26/25.
//

import Foundation

extension GymDetail {
    static let mock = GymDetail(
        id: "1",
        name: "Gym Fitness",
        ownerName: "Boeng Keng Kang",
        about: "Established in 2015, FitLife Community Gym has become a cornerstone of health and wellness in our neighborhood. Our mission is to empower individuals of all ages and fitness levels to lead healthier, more active lives.",
        images: ["gym1", "gym2", "gym3"],
        facilities: [
            Facility(name: "Gym", iconName: "figure.strengthtraining.traditional"),
            Facility(name: "Pool", iconName: "figure.pool.swim"),
            Facility(name: "Steam", iconName: "wind"),
            Facility(name: "Sauna", iconName: "humidity")
        ],
        classSchedules: [
            ClassSchedule(
                className: "Yoga class",
                days: "Every Thursday and Friday",
                time: "5:30 pm - 7:00 pm"
            ),
            ClassSchedule(
                className: "Jumping Class",
                days: "Every Monday, Wednesday and Friday",
                time: "5:30 pm - 7:00 pm"
            )
        ],
        openingHours: OpeningHours(
            status: "Gym is open today",
            openTime: "6:00 am",
            closeTime: "10:00 pm",
            note: "On public holiday such as Khmer New Year and Pchum Ben this place might be close so please check the availability before you go."
        ),
        address: "#12 street 310 Boeng Keng Kang Phnom Penh",
        reviews: [
            Review(
                userName: "Tommy",
                userAvatar: "avatar1",
                rating: 5.0,
                comment: "I don't have to buy more subscription to go to gym, swimming and tennis"
            ),
            Review(
                userName: "Sarah",
                userAvatar: "avatar2",
                rating: 4.5,
                comment: "Great facilities and friendly staff. The pool is always clean and well-maintained."
            ),
            Review(
                userName: "David",
                userAvatar: "avatar3",
                rating: 5.0,
                comment: "Best gym in the area! Love the yoga classes and the sauna after workout."
            )
        ]
    )
}
