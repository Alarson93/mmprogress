//
//  MMProgressConfiguration.m
//  Pods
//
//  Created by Alexander Larson on 3/7/16.
//
//

#import "MMProgressConfiguration.h"
#import <SpinKit/RTSpinKitView.h>

@implementation MMProgressConfiguration

#pragma mark - NSObject

//@property (nonatomic) BOOL borderEnabled;
//@property (nonatomic) CGFloat borderWidth;
//@property (nonatomic, strong) UIColor *borderColor;

- (id) init
{
    if (self = [super init])
    {
        _backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        _backgroundType = MMProgressBackgroundTypeSolid;
        _backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _fullScreen = NO;

        _shadowEnabled = [self ios9AndUp];
        _shadowOpacity = 0.5f;

        _borderEnabled = ![self ios9AndUp];
        _borderWidth = 1 / [[UIScreen mainScreen] scale];
        _borderColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.25f];

        _presentAnimated = YES;

        _statusColor = [UIColor darkGrayColor];
        _statusFont = [UIFont systemFontOfSize:17.0f];

        _tapBlock = YES;

        RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleArc];
        spinner.color = [UIColor darkGrayColor];
        _loadingIndicator = spinner;
    }

    return self;
}

#pragma mark - NSCopying

- (id) copyWithZone:(NSZone *) zone
{
    MMProgressConfiguration *copy = [[MMProgressConfiguration allocWithZone:zone] init];

    copy.backgroundColor = [self.backgroundColor copy];
    copy.backgroundType = self.backgroundType;
    copy.backgroundEffect = [self.backgroundEffect copy];
    copy.fullScreen = [self isFullScreen];

    copy.shadowEnabled = self.shadowEnabled;
    copy.shadowOpacity = self.shadowOpacity;

    copy.borderEnabled = self.borderEnabled;
    copy.borderWidth = self.borderWidth;
    copy.borderColor = [self.borderColor copy];

    copy.presentAnimated = self.presentAnimated;

    copy.statusColor = [self.statusColor copy];
    copy.statusFont = [self.statusFont copy];

    copy.tapBlock = self.tapBlock;

    copy.loadingIndicator = self.loadingIndicator;

    return copy;
}

#pragma mark - Helpers

+ (instancetype) defaultConfiguration
{
    return [[self alloc] init];
}

#pragma mark - Convenience

- (BOOL) ios9AndUp
{
    NSOperatingSystemVersion ios9_0_0 = (NSOperatingSystemVersion) { 9, 0, 0 };

    return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios9_0_0];
}

@end
