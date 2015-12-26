//
//  UIScrollView+BICustomRefreshControl.h
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/25/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+BIRefreshControl.h"

@interface UIScrollView (BICustomRefreshControl)

- (void)bi_addInputMethodRefreshHeaderWithHandler:(void (^)(void))handler;
- (void)bi_addInputMethodLoadingFooterWithHandler:(void (^)(void))handler;

@end
