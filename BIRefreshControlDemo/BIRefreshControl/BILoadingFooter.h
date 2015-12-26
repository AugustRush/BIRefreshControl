//
//  BILoadingControl.h
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/25/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BILoadingFooterState) {
    BILoadingFooterStateInitial,
    BILoadingFooterStateLoading,
    BILoadingFooterStateFinished,
};

@protocol BILoadingFooterDelegate;

@interface BILoadingFooter : UIView

@property (nonatomic, weak) id<BILoadingFooterDelegate> delegate;
@property (nonatomic, assign) BILoadingFooterState state;
@property (nonatomic, assign) CGFloat offsetThreshold;
@property (nonatomic, copy) void (^loadingHandler)(void);

- (void)startLoading;
- (void)stopLoading;

@end

@protocol BILoadingFooterDelegate <NSObject>

@optional
- (void)loadingFooter:(BILoadingFooter *)footer didChangedLoadingProgress:(CGFloat)progress;
- (void)loadingFooter:(BILoadingFooter *)footer didChangedLoadingState:(BILoadingFooterState)state;

@end
