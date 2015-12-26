//
//  BIInputMehodLoadingFooter.m
//  BIRefreshControlDemo
//
//  Created by AugustRush on 11/25/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import "BIInputMehodLoadingFooter.h"

@implementation BIInputMehodLoadingFooter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark - BILoadingFooterDelegate methods

- (void)loadingFooter:(BILoadingFooter *)footer didChangedLoadingProgress:(CGFloat)progress {
    self.backgroundColor = [UIColor colorWithRed:progress green:progress blue:progress alpha:1];
}

@end
