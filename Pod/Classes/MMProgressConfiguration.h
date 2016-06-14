//
//  MMProgressConfiguration.h
//  Pods
//
//  Created by Alexander Larson on 3/7/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, MMProgressBackgroundType)
{
    /* Don't allow user interactions and show a blurred background. Default value. */
    MMProgressBackgroundTypeBlurred,
    /* Don't allow user interactions and show a solid color background. */
    MMProgressBackgroundTypeSolid,
};

@interface MMProgressConfiguration : NSObject <NSCopying>

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

#pragma mark - Helper

+ (instancetype) defaultConfiguration;

@end
