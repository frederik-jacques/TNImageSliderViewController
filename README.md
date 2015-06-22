# TNImageSliderViewController

[![Version](https://img.shields.io/cocoapods/v/TNImageSliderViewController.svg?style=flat)](http://cocoapods.org/pods/TNImageSliderViewController)
[![License](https://img.shields.io/cocoapods/l/TNImageSliderViewController.svg?style=flat)](http://cocoapods.org/pods/TNImageSliderViewController)
[![Platform](https://img.shields.io/cocoapods/p/TNImageSliderViewController.svg?style=flat)](http://cocoapods.org/pods/TNImageSliderViewController)

## What
TNImageSliderViewController is an image slider component written in Swift. It creates a slideshow of images which can slide horizontal or vertical.
This component can deal with orientation changes.

## Demo
<video class="video-js vjs-default-skin" controls preload="auto" width="343" height="364">
<source src="http://cl.ly/bk4C/TNImageSliderViewController.mp4" type='video/mp4'>
</video>

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

TNImageSliderViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TNImageSliderViewController"
```

### Using storyboards
* Add a container view to your Storyboard.
* Set the class in the Identity Inspector to `TNImageSliderViewController`
* Give the embed segue a name e.g `seg_imageSlider`
* Go to the ViewController class in which you have embedded the TNImageSliderViewController class
* Create a property to hold the instance of `TNImageSliderViewController`
* Fill in this property in `prepareForSegue:identifier:`
* Set the `images` property of the `TNImageSliderViewController` to an array of UIImage objects

If you want, you can also set the `options` property (instance of `TNImageSliderViewOptions`)

| Option            | What does it do?  |
| ---------         | -----:|
| scrollDirection   | Set the collectionview to scroll horizontal or vertical  |
| backgroundColor   | A UIColor object to set the background color of the collectionview   |
| pageControlHidden | Hides the UIPageControl |  
| pageControlCurrentIndicatorTintColor | A UIColor object to set the indicator color |  


## Author

Frederik Jacques, frederik@the-nerd.be
* [Blog](http://www.the-nerd.be/blog)
* [Twitter](http://www.twitter.com/thenerd_be)

## License

TNImageSliderViewController is available under the MIT license. See the LICENSE file for more info.
