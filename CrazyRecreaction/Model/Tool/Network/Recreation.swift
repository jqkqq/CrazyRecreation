//
//  Recreation.swift
//  CrazyRecreaction

import Foundation

// MARK: - Empty
struct Recreation: Codable {
    let total: Int?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int?
    let name, nameZh: String?
    let openStatus: Int?
    let introduction, openTime, zipcode, distric: String?
    let address, tel, fax: String?
    let email: String?
    let months: String?
    let nlat, elong: Double?
    let officialSite: String?
    let facebook: String?
    let ticket, remind, staytime, modified: String?
    let url: String?
    let category, target, service: [Category]?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameZh = "name_zh"
        case openStatus = "open_status"
        case introduction
        case openTime = "open_time"
        case zipcode, distric, address, tel, fax, email, months, nlat, elong
        case officialSite = "official_site"
        case facebook, ticket, remind, staytime, modified, url, category, target, service, images
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?    
}

// MARK: - Image
struct Image: Codable {
    let src: String?
    let subject: String?
    let ext: String?
}



