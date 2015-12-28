//
//  BIInputMethodRefreshHeader.m
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/25/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import "BIInputMethodRefreshHeader.h"
#import "NSString+Path.h"

@implementation BIInputMethodRefreshHeader

#pragma mark - init methods

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
    _refreshAnimatedText = @"****  Refreshing  ****";
    self.delegate = self;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.strokeColor = [UIColor colorWithRed:252/255.0 green:70/255.0 blue:209/255.0 alpha:1].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineWidth = 3;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.autoreverses = YES;
    layer.path = [_refreshAnimatedText bezierPathWithFont:[UIFont fontWithName:@"Snell Roundhand" size:40]].CGPath;
}

#pragma mark - BIRefreshHeaderDelegate methods

- (void)refreshControl:(BIRefreshHeader *)control didChangeRefreshProgress:(CGFloat)progress {
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    if (self.state != BIRefreshHeaderStateRefreshing) {
        layer.strokeEnd = progress - 0.5;
    }else{
        layer.strokeEnd = 1.5;
    }
}

- (void)refreshControl:(BIRefreshHeader *)control didChangeRefreshState:(BIRefreshHeaderState)state {
    switch (state) {
        case BIRefreshHeaderStateInitial: {

            break;
        }
        case BIRefreshHeaderStateRefreshing:
        case BIRefreshHeaderStateFinished: {
            [self refreshControl:control didChangeRefreshProgress:1.5];
            break;
        }
        default: {
            break;
        }
    }
}

@end
