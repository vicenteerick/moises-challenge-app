//
//  Artwork.swift
//  MoisesChallengeApp
//
//  Created by Erick Vicente on 01/04/26.
//

import Foundation

struct Artwork: Hashable {
    let url30: URL?
    let url60: URL?
    let url100: URL?
    let url300: URL?
    let url1024: URL?

    init(url30: URL?, url60: URL?, url100: URL?) {
        self.url30 = url30
        self.url60 = url60
        self.url100 = url100
        let base = url100 ?? url60 ?? url30
        self.url300 = Self.mzstaticResizedURL(from: base, pixelSize: 300)
        self.url1024 = Self.mzstaticResizedURL(from: base, pixelSize: 1024)
    }

    /// iTunes / `mzstatic.com` pattern: `…/{n}x{n}bb.jpg`.
    private static func mzstaticResizedURL(from base: URL?, pixelSize: Int) -> URL? {
        guard let base else { return nil }
        let fileName = "\(pixelSize)x\(pixelSize)bb.jpg"
        return base.deletingLastPathComponent().appendingPathComponent(fileName)
    }
}
