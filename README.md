Using the following api:
https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/50/non-explicit.json

Build an app that will display a tableview of the top 30 albums on Apple music that are returned under the "results" object inside the top level "feed" object

Conditions:

* Use MVVM design pattern

* Implement Core Data for offline capabilities.  Results should be loaded from core data and refreshed from the network

* The apps main view controller title will be the "title" object of the top level "feed" object
* The tableview cell will consist of:
  * the artist name
  * the name of the album
  * thumbnail view of the album artwork

* Tapping on a tableview cell will show a detail view controller of each result and will display the following:
  * * the artist name
  * the name of the album
  * 200px by 200px view of the album artwork centered on the view
  * album release date
  * copyright information
  * url link to the App Store

* Layouts must look good on all device sizes

* The application must be fully unit tested
