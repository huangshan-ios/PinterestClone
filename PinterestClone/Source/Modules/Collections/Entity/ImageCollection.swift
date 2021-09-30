//
//  ImageCollection.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import Foundation

struct ImageCollection: Codable {
    let id: String
    let title: String
    let imageCollectionDescription: String?
    let publishedAt, lastCollectedAt, updatedAt: String
    let totalPhotos: Int
    let imageCollectionPrivate: Bool
    let shareKey: String?
    let coverPhoto: CoverPhoto
    let user: User
    let links: ImageCollectionLinks

    enum CodingKeys: String, CodingKey {
        case id, title
        case imageCollectionDescription = "description"
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case totalPhotos = "total_photos"
        case imageCollectionPrivate = "private"
        case shareKey = "share_key"
        case coverPhoto = "cover_photo"
        case user, links
    }
}

// MARK: - CoverPhoto
struct CoverPhoto: Codable {
    let id: String
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let coverPhotoDescription: String?
    let user: User
    let urls: Urls
    let links: CoverPhotoLinks

    enum CodingKeys: String, CodingKey {
        case id, width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case coverPhotoDescription = "description"
        case user, urls, links
    }
}

// MARK: - CoverPhotoLinks
struct CoverPhotoLinks: Codable {
    let linksSelf, html, download: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

// MARK: - User
struct User: Codable {
    let id, username, name: String
    let portfolioURL: String?
    let bio, location: String?
    let totalLikes, totalPhotos, totalCollections: Int
    let profileImage: ProfileImage
    let links: UserLinks
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case portfolioURL = "portfolio_url"
        case bio, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case profileImage = "profile_image"
        case links
        case updatedAt = "updated_at"
    }
}

// MARK: - UserLinks
struct UserLinks: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}

// MARK: - ImageCollectionLinks
struct ImageCollectionLinks: Codable {
    let linksSelf, html, photos, related: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, related
    }
}
