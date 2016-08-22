
# MMProgress

[![CI Status](http://img.shields.io/travis/Alex Larson/MMProgress.svg?style=flat)](https://travis-ci.org/Alex Larson/MMProgress)
[![Version](https://img.shields.io/cocoapods/v/MMProgress.svg?style=flat)](http://cocoapods.org/pods/MMProgress)
[![License](https://img.shields.io/cocoapods/l/MMProgress.svg?style=flat)](http://cocoapods.org/pods/MMProgress)
[![Platform](https://img.shields.io/cocoapods/p/MMProgress.svg?style=flat)](http://cocoapods.org/pods/MMProgress)

`MMProgress` is a customizable progress HUD with a simple API.

## Installation

### Cocoapods

1. Add `pod 'MMProgressProgress'` to your *Podfile*.
2. Install the pod by running `pod install`.
3. Include MMProgress wherever with
	* Objective-C: `#import <MMProgress/MMProgress.h>`
	* Swift: `import MMProgress`

## Usage

### Demo

Download the project from GitHub and check out example. A better demo is coming soon!

### Show

You can show the HUD using any of the following methods:

```objective-c
//Show using default HUD settings.
+ (void) show;

//Show using default HUD settings and a custom message.
+ (void) showWithStatus:(NSString *) status;

//Show on a specific view using the default HUD settings and a custom message.
+ (void) showWithStatus:(NSString *) status onView:(UIView *) superview;

//Show on a specific view using custom HUD settings and a custom message.
+ (void) showWithStatus:(NSString *) status onView:(UIView *) superview temporaryConfig:(MMProgressConfiguration *) tempConfig;
```

There is currently no native support for progressive loading. If you would like to use a progressive loading indicator, I would suggest providing a custom loading indicator (via ) that shows your progress. For more information, look in the customization section.

### Dismiss

You can dismiss the HUD using any of the following methods:

```objective-c
//Dismiss using the current HUD settings (default or temporary).
+ (void) dismiss;

//TODO: Add dismissWithTemporaryConfig:(MMProgressConfiguration *) tempConfig;

//Dismiss using the current HUD settings (default or temporary). Call completion upon dismiss.
+ (void) dismissAnimatedWithCompletion:(MMPCompletionBlock) completion;
```

## Customization

### Customization Types

With MMProgress, you can assign a configuration to be the new default or you can supply configurations per show. 

To assign a new default, create a `MMProgressConfiguration` object with your desired settings and call:
```objective-c
[MMProgress setConfiguration:myConfiguration];
```

To use a temporary configuration, which lasts only until the next `show` is called, create a `MMProgressConfiguration` object with your desired settings and call:
```objective-c
//Providing superview is optional. If it is nil, the HUD will default to the entire screen
+ (void) showWithStatus:(NSString *) status onView:(UIView *) superview temporaryConfig:(MMProgressConfiguration *) tempConfig;
```

### Customization Settings

There are many settings you can adjust in the `MMProgressConfiguration` object.

```objective-c
//TODO: Document default values

#pragma mark - Background
@property (nonatomic) MMProgressBackgroundType backgroundType;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIVisualEffect *backgroundEffect;
@property (nonatomic, getter = isFullScreen) BOOL fullScreen;

#pragma mark - Edges
@property (nonatomic) BOOL shadowEnabled;
@property (nonatomic) CGFloat shadowOpacity;
@property (nonatomic) BOOL borderEnabled;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;

#pragma mark - Custom Animation
@property (nonatomic, strong) UIView *loadingIndicator;

#pragma mark - Presentation
@property (nonatomic, getter = presentWithAnimation) BOOL presentAnimated;

#pragma mark - Status
@property (nonatomic, strong) UIColor *statusColor;
@property (nonatomic, strong) UIFont *statusFont;

#pragma mark - Interaction
@property (nonatomic, getter = tapBlock) BOOL tapBlock;
```

Most of the settings should be fairly intuitive, but the following are powerful settings that may not be immediately apparent.
* `backgroundType` This is an enum specifiying what background style the hud uses.
	* `MMProgressBackgroundTypeBlurred` Visual Effect View to apply live blurring effect.
	* `MMProgressBackgroundTypeSolid` No blur.
* `backgroundColor` This is a UIColor that is laid over the top of the HUD background. You can use a color alpha of 1.0 for a solid background (thus making the background type moot). If you use less than 1.0, it will be as if you are *tinting* the HUD
* `fullScreen` If fullscreen, the HUD isn't a box floating over the center of the screen, but a layer over the entirety of the screen. Visual effects and background color are applied.
* `loadingIndicator` You can provide any loading indicator you would like. This means that you can provide indeterminate indicators or you can have an instance of a progress indicator and provide that to the view.


## Notifications

Coming soon.

## Requirements

* iOS 8
* ARC

## License

MMProgress is available under the MIT license. See the LICENSE file for more info.

## Credits

MMProgress was inspired by [KVNProgress](https://github.com/AssistoLab/KVNProgress) and [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD). I am using [SpinKit](https://github.com/raymondjavaxx/SpinKit-ObjC) for the default loading animations.

I wanted to extend and refine a functionality of both HUDs. I will do my best to keep MMProgress up to date and bug free. I also have plans on creating a Swift version in the future.

I work at [Myriad Mobile](https://myriadmobile.com/).