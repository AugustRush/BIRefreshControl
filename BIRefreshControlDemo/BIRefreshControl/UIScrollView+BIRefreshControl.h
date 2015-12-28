//
//  UIScrollView+BIRefreshHeader.h
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/24/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIRefreshHeader.h"
#import "BILoadingFooter.h"

@interface UIScrollView (BIRefreshControl)

@property (readonly) BIRefreshHeader *refreshHeader;
@property (readonly) BILoadingFooter *loadingFooter;

- (void)bi_addRefreshHeaderWithControl:(BIRefreshHeader *)control
                                Height:(CGFloat)height
                        refreshHandler:(void (^)(void))handler;

- (void)bi_addLoadingFooterWithControl:(BILoadingFooter *)control
                                height:(CGFloat)height
                        loadingHandler:(void (^)(void))handler;

//header
- (void)bi_startRefreshing;
- (void)bi_stopRefreshing;

//footer
- (void)bi_startLoading;
- (void)bi_stopLoading;

@end
