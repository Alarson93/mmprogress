//
//  MMProgress.m
//  Pods
//
//  Created by Alexander Larson on 3/7/16.
//
//

#import "MMProgress.h"
#import "TOMSMorphingLabel.h"

//Using (0, 0, 1) in the CATransform breaks animation
#define FLOATZERO 0.001

static CGFloat const MMFadeAnimationDuration = 0.3f;
static CGFloat const MMLayoutAnimationDuration = 0.3f;
static CGFloat const MMAnimationViewToStatusLabelVerticalSpaceConstraintConstant = 10.0f;
static CGFloat const MMContentViewWithStatusInset = 10.0f;
static CGFloat const MMContentViewWithoutStatusInset = 20.0f;
static CGFloat const MMContentViewCornerRadius = 8.0f;
static CGFloat const MMContentViewWithoutStatusCornerRadius = 15.0f;

@interface MMProgress ()

//Constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *statusLabelTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *animationViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewHeight;

@property (nonatomic) NSArray *constraintsToSuperview;

// UI
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *animationView;
@property (nonatomic, weak) IBOutlet TOMSMorphingLabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *backgroundEffectView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *contentEffectView;
@property (weak, nonatomic) IBOutlet UIView *backgroundColorView;
@property (weak, nonatomic) IBOutlet UIView *contentColorView;

//State
@property (nonatomic) NSString *status;
@property (nonatomic) MMProgressBackgroundType backgroundType;
@property (nonatomic) MMProgressConfiguration *configuration;
@property (nonatomic) UIVisualEffect *backgroundEffect;
@property (nonatomic, getter = isFullScreen) BOOL fullScreen;
@property (nonatomic, getter = presentWithAnimation) BOOL presentAnimated;

@end

@implementation MMProgress

#pragma mark - Life cycle

+ (MMProgress *) sharedView
{
    static MMProgress *sharedView = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        UINib *nib = [UINib nibWithNibName:@"MMProgressView" bundle:[NSBundle bundleForClass:[self class]]];
        sharedView = [nib instantiateWithOwner:self options:0][0];

        //Remove context provided by storyboard
        sharedView.animationView.backgroundColor = [UIColor clearColor];
    });

    return sharedView;
}

- (instancetype) initWithCoder:(NSCoder *) aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _configuration = _configuration ? : [MMProgressConfiguration defaultConfiguration];
    }

    return self;
}

#pragma mark - Show

+ (void) show
{
    [self showWithStatus:nil];
}

+ (void) showWithStatus:(NSString *) status
{
    [self showWithStatus:status onView:nil];
}

+ (void) showWithStatus:(NSString *) status onView:(UIView *) superview
{
    [self showWithStatus:status onView:superview temporaryConfig:nil];
}

+ (void) showWithStatus:(NSString *) status onView:(UIView *) superview temporaryConfig:(MMProgressConfiguration *) tempConfig
{
    [[self sharedView] showStatus:status view:superview configuration:tempConfig];
}

#pragma mark - Dimiss

+ (void) dismiss
{
    [self dismissAnimatedWithCompletion:nil];
}

+ (void) dismissAnimatedWithCompletion:(MMPCompletionBlock) completion
{
    if ([self sharedView].superview)
    {
        [[self sharedView] disappearWithCompletion:completion];
    }
}

#pragma mark - Show Implementation

- (void) showStatus:(NSString *) status view:(UIView *) superview configuration:(MMProgressConfiguration *) temporaryConfig
{
    //If temporary config is nil, it will use the regular
    [self setupWithConfig:temporaryConfig andStatus:status];
    superview = superview ? : [self currentWindow];

    if (self.superview == superview)
    {
        [self updateUIAnimated];
    }
    else
    {
        [self presentOnView:superview];
    }
}

- (void) updateUIAnimated
{
    //Resets the progress hud to the presented state and begins updating the content.
    //Cancel previous animations to prevent abnormal animation behavior
    [self.layer removeAllAnimations];
    [self present];

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:MMLayoutAnimationDuration
                     animations:^{
         //Setting text to empty fixes UI bug
         weakSelf.statusLabel.text = @"";
         [weakSelf setupUI];
     }];
}

#pragma mark - Present New HUD

- (void) presentOnView:(UIView *) superview
{
    [self clearUI];
    [self addToView:superview];
    [self setupHUDConstraints];
    [self setupUI];
    [self present];
}

- (void) clearUI
{
    if (self.configuration.presentAnimated)
    {
        self.layer.transform = CATransform3DMakeScale(FLOATZERO, FLOATZERO, 1);
    }

    [self.statusLabel setTextWithoutMorphing:@""];
}

- (void) addToView:(UIView *) superview
{
    if (self.superview)
    {
        [self.superview removeConstraints:self.constraintsToSuperview];
        [self removeFromSuperview];
    }

    [superview addSubview:self];
    [superview bringSubviewToFront:self];
}

- (void) present
{
    if (self.presentAnimated)
    {
        [self animateAppearance];
    }
    else
    {
        [self appearanceCompleted];
    }
}

#pragma mark - Setup UI

- (void) setupUI
{
    [self setupAnimationView];
    [self setupStatus:self.status];
    [self setupViews];
    [self setupUIConstraints];
}

- (void) setupAnimationView
{
    [self.animationView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.animationView addSubview:self.configuration.loadingIndicator];
}

- (void) setupStatus:(NSString *) status
{
    self.statusLabel.text = status;
    self.statusLabel.textColor = self.configuration.statusColor;
    self.statusLabel.font = self.configuration.statusFont;
}

- (void) setupViews
{
    switch (self.backgroundType)
    {
        case MMProgressBackgroundTypeSolid :
            self.backgroundEffectView.hidden = YES;
            self.contentEffectView.hidden = YES;
            break;

        case MMProgressBackgroundTypeBlurred :
            self.backgroundEffectView.hidden = !self.isFullScreen;
            self.contentEffectView.hidden = self.isFullScreen;
            break;
    }

    //HUD size
    if ([self isFullScreen])
    {
        [self setupViewsFullscreen];
    }
    else
    {
        [self setupViewsNotFullscreen];
    }

    //Shadow
    self.contentView.layer.shadowOffset = CGSizeZero;
    self.contentView.layer.shadowRadius = 5;
    self.contentView.layer.shadowOpacity = (self.configuration.shadowEnabled && ![self isFullScreen]) ? self.configuration.shadowOpacity : 0;

    //Border
    self.contentView.layer.borderWidth = self.configuration.borderEnabled ? self.configuration.borderWidth : 0;
    self.contentView.layer.borderColor = self.configuration.borderColor.CGColor;
}

- (void) setupUIConstraints
{
    self.animationViewWidth.constant = self.configuration.loadingIndicator.bounds.size.width;
    self.animationViewHeight.constant = self.configuration.loadingIndicator.bounds.size.height;
    self.animationViewTopConstraint.constant = self.status ? MMContentViewWithStatusInset : MMContentViewWithoutStatusInset;
    self.statusLabelTopConstraint.constant = self.configuration.loadingIndicator ? MMAnimationViewToStatusLabelVerticalSpaceConstraintConstant : 0;

    [self layoutIfNeeded];
}

#pragma mark - Layouts

- (void) setupViewsFullscreen
{
    self.contentView.layer.cornerRadius = 0.0f;
    self.contentColorView.layer.cornerRadius = self.contentView.layer.cornerRadius;
    self.contentEffectView.layer.cornerRadius = self.contentView.layer.cornerRadius;

    self.contentColorView.backgroundColor = [UIColor clearColor];
    self.backgroundColorView.backgroundColor = self.configuration.backgroundColor;
}

- (void) setupViewsNotFullscreen
{
    self.contentView.layer.cornerRadius = (self.status) ? MMContentViewCornerRadius : MMContentViewWithoutStatusCornerRadius;
    self.contentColorView.layer.cornerRadius = self.contentView.layer.cornerRadius;
    self.contentEffectView.layer.cornerRadius = self.contentView.layer.cornerRadius;

    self.contentColorView.backgroundColor = self.configuration.backgroundColor;
    self.backgroundColorView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Appearance

- (void) animateAppearance
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:[self showDuration]
                          delay:0.0f
                        options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
         if (weakSelf)
         {
             weakSelf.layer.transform = CATransform3DIdentity;
         }
     } completion:^(BOOL finished) {
         if (finished)
         {
             [weakSelf appearanceCompleted];
         }
     }];
}

- (void) appearanceCompleted
{
    if (!self.superview)
    {
        NSLog(@"Animation incomplete.");
        return;
    }

    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.status);
}

#pragma mark - Disapperance

- (void) disappearWithCompletion:(MMPCompletionBlock) completion
{
    if (self.presentAnimated)
    {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:[self dismissDuration]
                              delay:0.0f
                            options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
             if (weakSelf)
             {
                 weakSelf.layer.transform = CATransform3DMakeScale(FLOATZERO, FLOATZERO, 1);
             }
         } completion:^(BOOL finished) {
             if (finished)
             {
                 [weakSelf disappearCompleted:completion];
             }
         }];
    }
    else
    {
        [self disappearCompleted:completion];
    }
}

- (void) disappearCompleted:(MMPCompletionBlock) completion
{
    [self removeFromSuperview];
    self.status = @"";
    //TODO: Caused potential crashes; try again using the modified morphing label.
//    [self.statusLabel setTextWithoutMorphing:@""];

    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);

    if (completion)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

#pragma mark - Convenience Methods

- (CGFloat) percentPresented
{
    return self.layer.transform.m11;
}

- (UIWindow *) currentWindow
{
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;

    if (!currentWindow)
    {
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];

        for (UIWindow *window in frontToBackWindows)
        {
            if (window.windowLevel == UIWindowLevelNormal)
            {
                currentWindow = window;
                break;
            }
        }
    }

    return currentWindow;
}

- (void) setBackgroundEffect:(UIVisualEffect *) backgroundEffect
{
    _backgroundEffect = backgroundEffect;
    self.backgroundEffectView.effect = _backgroundEffect;
    self.contentEffectView.effect = _backgroundEffect;
}

- (NSTimeInterval) dismissDuration
{
    //Ex: 0.3 seconds @ 70% presented would dismiss for 0.21 seconds
    return MMFadeAnimationDuration * [self percentPresented];
}

- (NSTimeInterval) showDuration
{
    //Ex: 0.3 seconds @ 30% presented would dismiss for 0.21 seconds
    return MMFadeAnimationDuration * (1 - [self percentPresented]);
}

#pragma mark - HUD Constraints

- (void) setupHUDConstraints
{
    if (self.configuration.tapBlock)
    {
        self.constraintsToSuperview = [self constraintsTapBlock];
    }
    else
    {
        self.constraintsToSuperview = [self constraintsNoTapBlock];
    }

    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraints:self.constraintsToSuperview];

    [self layoutIfNeeded];
}

- (NSArray *) constraintsTapBlock
{
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{ @"self" : self }];

    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{ @"self" : self }];

    return [verticalConstraints arrayByAddingObjectsFromArray:horizontalConstraints];
}

- (NSArray *) constraintsNoTapBlock
{
    NSMutableArray *contraints = [NSMutableArray array];


    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{ @"self" : self.contentView }];
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{ @"self" : self.contentView }];

    NSLayoutConstraint *horizontalCenter = [NSLayoutConstraint constraintWithItem:self
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.superview
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0 constant:0];

    NSLayoutConstraint *verticalCenter = [NSLayoutConstraint constraintWithItem:self
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.superview
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0 constant:0];

    [contraints addObjectsFromArray:verticalConstraints];
    [contraints addObjectsFromArray:horizontalConstraints];
    [contraints addObject:horizontalCenter];
    [contraints addObject:verticalCenter];

    return contraints;
}

#pragma mark - Configuration

+ (MMProgressConfiguration *) configuration
{
    return [self sharedView].configuration;
}

+ (void) setConfiguration:(MMProgressConfiguration *) newConfiguration
{
    [self sharedView].configuration = newConfiguration;
}

- (void) setupWithConfig:(MMProgressConfiguration *) config andStatus:(NSString *) status
{
    MMProgressConfiguration *targetConfig = config ? : self.configuration;

    self.backgroundType = targetConfig.backgroundType;
    self.fullScreen = targetConfig.fullScreen;
    self.backgroundEffect = targetConfig.backgroundEffect;
    self.presentAnimated = targetConfig.presentAnimated;
    self.status = [status copy];
}

#pragma mark - Visibility

//TODO: Maybe change this to return the superview object?
+ (BOOL) isVisible
{
    return ([self sharedView].superview != nil);
}

@end
