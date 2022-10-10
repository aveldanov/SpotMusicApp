//
//  NewReleasesResponse.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 10/9/22.
//

import Foundation


struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {

}

/*

 {
     href = "https://api.spotify.com/v1/browse/new-releases?country=US&locale=en-US%2Cen%3Bq%3D0.9&offset=0&limit=1";
     items =         (
                     {
             "album_type" = album;
             artists =                 (
                                     {
                     "external_urls" =                         {
                         spotify = "https://open.spotify.com/artist/6VuMaDnrHyPL1p4EHjYLi7";
                     };
                     href = "https://api.spotify.com/v1/artists/6VuMaDnrHyPL1p4EHjYLi7";
                     id = 6VuMaDnrHyPL1p4EHjYLi7;
                     name = "Charlie Puth";
                     type = artist;
                     uri = "spotify:artist:6VuMaDnrHyPL1p4EHjYLi7";
                 }
             );
             "available_markets" =                 (
                 AD,

                 ZM,
                 ZW
             );
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/album/2LTqBgZUH4EkDcj8hdkNjK";
             };
             href = "https://api.spotify.com/v1/albums/2LTqBgZUH4EkDcj8hdkNjK";
             id = 2LTqBgZUH4EkDcj8hdkNjK;
             images =                 (
                                     {
                     height = 640;
                     url = "https://i.scdn.co/image/ab67616d0000b273a3b39c1651a617bb09800fd8";
                     width = 640;
                 },
                                     {
                     height = 300;
                     url = "https://i.scdn.co/image/ab67616d00001e02a3b39c1651a617bb09800fd8";
                     width = 300;
                 },
                                     {
                     height = 64;
                     url = "https://i.scdn.co/image/ab67616d00004851a3b39c1651a617bb09800fd8";
                     width = 64;
                 }
             );
             name = CHARLIE;
             "release_date" = "2022-10-07";
             "release_date_precision" = day;
             "total_tracks" = 12;
             type = album;
             uri = "spotify:album:2LTqBgZUH4EkDcj8hdkNjK";
         }
     );
     limit = 1;
     next = "https://api.spotify.com/v1/browse/new-releases?country=US&locale=en-US%2Cen%3Bq%3D0.9&offset=1&limit=1";
     offset = 0;
     previous = "<null>";
     total = 100;
 };
}

 */
