//
//  MMPViewController.m
//  MMProgress
//
//  Created by Alex Larson on 03/07/2016.
//  Copyright (c) 2016 Alex Larson. All rights reserved.
//

#import "MMPViewController.h"
#import <MMProgress/MMProgress.h>

@interface MMPViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *orangeImageView;

@end

@implementation MMPViewController

- (IBAction) hudWithTimer:(id) sender
{
    [MMProgress showWithStatus:@"Loading data..."];
    [MMProgress dismiss];
    [MMProgress showWithStatus:@"More data"];

//    [NSTimer scheduledTimerWithTimeInterval:10.0
//                                     target:self
//                                   selector:@selector(dismissProgress)
//                                   userInfo:nil
//                                    repeats:NO];
//
//    [NSTimer scheduledTimerWithTimeInterval:7
//                                     target:self
//                                   selector:@selector(presentHUD3)
//                                   userInfo:nil
//                                    repeats:NO];
//
//    [NSTimer scheduledTimerWithTimeInterval:6
//                                     target:self
//                                   selector:@selector(presentHUD2)
//                                   userInfo:nil
//                                    repeats:NO];
//
//    [NSTimer scheduledTimerWithTimeInterval:5.0
//                                     target:self
//                                   selector:@selector(presentHUD)
//                                   userInfo:nil
//                                    repeats:NO];
}

- (void) dismissProgress
{
    [MMProgress dismiss];
}

- (void) presentHUD
{
    [MMProgress showWithStatus:@"asdf"];
}

- (void) presentHUD2
{
    [MMProgress showWithStatus:@"And more data!"];
}

- (void) presentHUD3
{
    [MMProgress showWithStatus:@"Custom view!"];
//     [MMProgress showWithStatus:@"Custom view!" onView:self.orangeImageView];
}

@end
