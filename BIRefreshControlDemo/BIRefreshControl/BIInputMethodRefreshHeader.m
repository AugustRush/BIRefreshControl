//
//  BIInputMethodRefreshHeader.m
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/25/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import "BIInputMethodRefreshHeader.h"

@implementation BIInputMethodRefreshHeader

#pragma mark - init methods

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - BIRefreshHeaderDelegate methods

- (void)refreshControl:(BIRefreshHeader *)control didChangeRefreshProgress:(CGFloat)progress {
        NSLog(@"progress is %f",progress);
    self.alpha = progress;
}

- (void)refreshControl:(BIRefreshHeader *)control didChangeRefreshState:(BIRefreshHeaderState)state {
    switch (state) {
        case BIRefreshHeaderStateInitial: {

            break;
        }
        case BIRefreshHeaderStateRefreshing: {

            break;
        }
        case BIRefreshHeaderStateFinished: {

            break;
        }
        default: {
            break;
        }
    }
}

@end
