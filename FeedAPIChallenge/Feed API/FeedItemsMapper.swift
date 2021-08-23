//
//  FeedItemsMapper.swift
//  FeedAPIChallenge
//
//  Created by Frank Carnevale on 8/23/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

internal final class FeedItemsMapper {
	private static let OK_200 = 200

	private struct Root: Decodable {
		let items: [Item]

		var imageFeed: [FeedImage] { [] }
	}

	private struct Item: Decodable {
		let imageID: UUID
		let imageDescription: String?
		let imageLocation: String?
		let image: URL

		enum CodingKeys: String, CodingKey {
			case imageID = "image_id"
			case imageDescription = "image_desc"
			case imageLocation = "image_loc"
			case image = "image_URL"
		}
	}

	internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		guard response.statusCode == Self.OK_200,
		      let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}

		return .success(root.imageFeed)
	}
}
