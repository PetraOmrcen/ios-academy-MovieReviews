//
//  Shows.swift
//  TV Shows
//
//  Created by Infinum on 25.07.2021..
//

import Foundation


struct Show: Decodable {
    let id: String
    let averageRating: Double
    let description: String?
    let imageUrl: String?
    let noOfReviews: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case averageRating = "average_rating"
        case imageUrl = "image_url"
        case noOfReviews = "no_of_reviews"
        case description
        case title
    }
}

struct ShowsResponse: Decodable {
   let shows: [Show]
   
}

struct Review: Decodable{
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
        }
}

struct ReviewsResponse: Decodable{
    let reviews: [Review]
}

struct NewReviewResponse: Decodable {
    let review: Review
}

