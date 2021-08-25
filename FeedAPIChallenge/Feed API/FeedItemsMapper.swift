//
//  FeedItemsMapper.swift
//  FeedAPIChallenge
//
//  Created by Frank Carnevale on 8/23/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final class FeedItemsMapper {
	private static let OK_200 = 200

	private struct Root: Decodable {
		let items: [Item]

		var imageFeed: [FeedImage] {
			return items.map {
				.init(id: $0.imageID,
				      description: $0.imageDescription,
				      location: $0.imageLocation,
				      url: $0.imageURL)
			}
		}
	}

	private struct Item: Decodable {
		let imageID: UUID
		let imageDescription: String?
		let imageLocation: String?
		let imageURL: URL

		enum CodingKeys: String, CodingKey {
			case imageID = "image_id"
			case imageDescription = "image_desc"
			case imageLocation = "image_loc"
			case imageURL = "image_url"
		}
	}

	static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		guard response.statusCode == Self.OK_200,
		      let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}

		return .success(root.imageFeed)
	}
}
