//
//  BIRefreshHeader.h
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/24/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BIRefreshHeaderState) {
    BIRefreshHeaderStateInitial,
    BIRefreshHeaderStateRefreshing,
    BIRefreshHeaderStateFinished,
};

@protocol BIRefreshHeaderDelegate;

@interface BIRefreshHeader : UIView

@property (nonatomic, weak) id<BIRefreshHeaderDelegate> delegate;
@property (nonatomic, assign, readonly) BIRefreshHeaderState state;
@property (nonatomic, assign) CGFloat offsetThreshold;
@property (nonatomic, copy) void(^refreshHandler)(void);

- (void)startRefreshing;
- (void)stopRefreshing;

@end

@protocol BIRefreshHeaderDelegate <NSObject>

@optional
- (void)refreshControl:(BIRefreshHeader *)control didChangeRefreshProgress:(CGFloat)progress;
- (void)refreshControl:(BIRefreshHeader *)control didChangeRefreshState:(BIRefreshHeaderState)state;

@end