//
//  BIInputMehodLoadingFooter.m
//  BIRefreshControlDemo
//
//  Created by AugustRush on 11/25/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import "BIInputMehodLoadingFooter.h"
#import "NSString+Path.h"

@implementation BIInputMehodLoadingFooter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

#pragma mark - private methods

- (void)setUp {
    _loadingAnimatedText = @"Just Loading text";
    self.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.strokeColor = [UIColor colorWithRed:252/255.0 green:70/255.0 blue:209/255.0 alpha:1].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineWidth = 3;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.autoreverses = YES;
    layer.path = [_loadingAnimatedText bezierPathWithFont:[UIFont fontWithName:@"noteworthy" size:48]].CGPath;
}

#pragma mark - BILoadingFooterDelegate methods

- (void)loadingFooter:(BILoadingFooter *)footer didChangedLoadingProgress:(CGFloat)progress {
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.strokeEnd = progress;
}

@end
