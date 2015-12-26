//
//  UIScrollView+BICustomRefreshControl.m
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/25/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import "UIScrollView+BICustomRefreshControl.h"
#import "BIInputMethodRefreshHeader.h"
#import "BIInputMehodLoadingFooter.h"

@implementation UIScrollView (BICustomRefreshControl)

- (void)bi_addInputMethodRefreshHeaderWithHandler:(void (^)(void))handler {
    BIInputMethodRefreshHeader *header = [[BIInputMethodRefreshHeader alloc] init];
    [self bi_addRefreshHeaderWithControl:header Height:100 refreshHandler:handler];
}

- (void)bi_addInputMethodLoadingFooterWithHandler:(void (^)(void))handler {
    BIInputMehodLoadingFooter *footer = [[BIInputMehodLoadingFooter alloc] init];
    [self bi_addLoadingFooterWithControl:footer height:100 loadingHandler:handler];
}

@end
