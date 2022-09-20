//
//  PlayListItem.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/09/2022.
//

import Foundation

// MARK: - Welcome
struct ResponsePlayListItems: Codable {
    let pageInfo: PageInfo
    var items: [Item]
    let nextPageToken: String?
    let kind, etag: String?
}

// MARK: - Item
struct Item: Codable {
    let id, etag: String
    let kind: ItemKind
    let snippet: Snippet
}

enum ItemKind: String, Codable {
    case youtubePlaylistItem = "youtube#playlistItem"
}

// MARK: - Snippet
struct Snippet: Codable {
    let title: String
    let position: Int
    let channelTitle: String
    let thumbnails: Thumbnails
    let videoOwnerChannelID: String?
    let channelID: String
    let videoOwnerChannelTitle: String?
    let publishedAt: String
    let snippetDescription: String
    let resourceID: ResourceID
    let playlistID: String

    enum CodingKeys: String, CodingKey {
        case title, position, channelTitle, thumbnails
        case videoOwnerChannelID = "videoOwnerChannelId"
        case channelID = "channelId"
        case videoOwnerChannelTitle, publishedAt
        case snippetDescription = "description"
        case resourceID = "resourceId"
        case playlistID = "playlistId"
    }
}
// MARK: - ResourceID
struct ResourceID: Codable {
    let videoID: String
    let kind: String

    enum CodingKeys: String, CodingKey {
        case videoID = "videoId"
        case kind
    }
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let high, thumbnailsDefault, medium: Default?
    let maxres: Default?
    let standard: Default?

    enum CodingKeys: String, CodingKey {
        case high
        case thumbnailsDefault = "default"
        case medium, maxres, standard
    }
}

// MARK: - Default
struct Default: Codable {
    let url: String
    let height, width: Int
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
