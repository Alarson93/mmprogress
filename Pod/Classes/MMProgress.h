//
//  MMProgress.h
//  Pods
//
//  Created by Alexander Larson on 3/7/16.
//
//

#import <UIKit/UIKit.h>
#import "MMProgressConfiguration.h"

typedef void (^MMPCompletionBlock)(void);

@interface MMProgress : UIView

//TODO: Present in update
//TODO: Tapblock - show whole view immediately (clear; block) and animate in hud=

#pragma mark - Configuration

+ (MMProgressConfiguration *) configuration;

+ (void) setConfiguration:(MMProgressConfiguration *) newConfiguration;

#pragma mark - Loading

+ (void) show;
+ (void) showWithStatus:(NSString *) status;
+ (void) showWithStatus:(NSString *) status onView:(UIView *) superview;
+ (void) showWithStatus:(NSString *) status onView:(UIView *) superview temporaryConfig:(MMProgressConfiguration *) tempConfig;

#pragma mark - Dimiss

+ (void) dismiss;
+ (void) dismissAnimatedWithCompletion:(MMPCompletionBlock) completion;

#pragma mark - Information

+ (BOOL) isVisible;


@end
