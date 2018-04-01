# Intro

- unsplash API with access key
- Swift 4 Codable and Alamofire for data fetching  (without SwiftyJson)
- API Router structure
- on main page, data fetch from '/photos?page=1', to Photo model array
- on scrolling to bottom, data fetch from '/photos?page=2'...., and reload collectionView. during data fetching, spinner shows on bottom.
- on click image thumbnail, it opens DetailCollectionViewController. only on willDisplayCell, will data fetching from '/photos/:id' happen, into PhotoDetail model, and update that detail cell with views and downloads (data from PhotoDetail, only to demonstrate more info)
- UI of Controller and CollectionViewCell is made by code, with snapKit
- UI of DetailCollectionViewCell is made with interface builder with the use of size class (different layout on horizontal and vertical)
- on dismiss gallery (no matter how many images browsed), the current image's thumbnail will always be visible, in the middle of main page
- transition animation on presenting and dismissing. from and to thumbnail's frame, even if presented image differs from dismissed image.

-----------------------------------------------------------------------------

# Mobile Developer Coding Challenge

This is a coding challenge for prospective mobile developer applicants applying through http://work.traderev.com/

## Goal:

#### Build simple app that allows viewing and interacting with a grid of curated photos from Unsplash

- [x] Fork this repo. Keep it public until we have been able to review it.
- [x] Android: _Java_ or _Kotlin_ | iOS: _Swift 3_
- [x] Unsplash API docs are here: https://unsplash.com/documentation.
- [x] Grid of photos should preserve the aspect ratio of the photos it's displaying, meaning you shouldn't crop the image in any way.
- [x] Grid should work in both portrait and landscape orientations of the device.
- [x] Grid should support pagination, i.e. you can scroll on grid of photos infinitely.
- [x] When user taps on a photo on the grid it should show the photo in full screen with more information about the photo.
- [x] When user swipes on a photo in full screen, it should show the the next photo and preserve current photos location on the grid, so when she dismisses the full screen, grid of photos should contain the last photo she saw.

### Evaluation:
- [ ] Solution compiles. If there are necessary steps required to get it to compile, those should be covered in README.md.
- [ ] No crashes, bugs, compiler warnings
- [ ] App operates as intended
- [ ] Conforms to SOLID principles
- [ ] Code is easily understood and communicative
- [ ] Commit history is consistent, easy to follow and understand
