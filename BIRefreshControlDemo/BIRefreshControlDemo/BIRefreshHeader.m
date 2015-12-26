//
//  BIRefreshHeader.m
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/24/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import "BIRefreshHeader.h"
#import "BIRefresh.h"
#import "BILoadingFooter.h"

static void *BIRefreshHeaderObserverContentOffsetContext = &BIRefreshHeaderObserverContentOffsetContext;

@interface BIRefreshHeader ()

@property (nonatomic, assign) BIRefreshHeaderState state;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets originalInset;

@end

@implementation BIRefreshHeader

#pragma mark - init methods

- (instancetype)init {
    self = [super init];
    if (self) {
        self.state = BIRefreshHeaderStateInitial;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.state = BIRefreshHeaderStateInitial;
    }
    return self;
}

#pragma mark - override methods

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (self.superview) {
        [self removeRefreshControlObservers];
    }
    
    if (self.superview == nil && [newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.originalInset = self.scrollView.contentInset;
        [self addRefreshControlObservers];
    }
}

#pragma mark - private methods

- (void)addRefreshControlObservers {
    [self.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:BIRefreshHeaderObserverContentOffsetContext];
}

- (void)removeRefreshControlObservers {
    //must use superView to remove observers, why?
    @try {
        [self.superview removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)springAnimation:(void(^)(void))animation completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:kBIRefreshHeaderAnimateInterval
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animation
                     completion:completion];

}

- (void)setState:(BIRefreshHeaderState)state {
    _state = state;
    if ([self.delegate respondsToSelector:@selector(refreshControl:didChangeRefreshState:)]) {
        [self.delegate refreshControl:self didChangeRefreshState:_state];
    }
}

- (BOOL)canRefresh {
    return self.scrollView.loadingFooter.state != BILoadingFooterStateLoading;
}

#pragma mark - NSKeyValueObserving methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == BIRefreshHeaderObserverContentOffsetContext) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat progress = -offset.y/self.offsetThreshold;
        if (progress > 1 &&
            self.scrollView.isTracking == NO) {
            [self startRefreshing];
        }
        if (offset.y < 0 &&
            [self.delegate respondsToSelector:@selector(refreshControl:didChangeRefreshProgress:)]) {
            if (progress < 0) {
                progress = 0;
            }
            [self.delegate refreshControl:self didChangeRefreshProgress:(_state == BIRefreshHeaderStateRefreshing) ? 1:progress];
        }
    }
}

#pragma mark - public methods

- (void)stopRefreshing {
    if (self.state != BIRefreshHeaderStateFinished) {
        [self springAnimation:^{
            [self.scrollView setContentInset:self.originalInset];
        } completion:^(BOOL finished) {
            self.state = BIRefreshHeaderStateFinished;
        }];
    }
}

- (void)startRefreshing {
    if (self.state != BIRefreshHeaderStateRefreshing &&
        [self canRefresh]) {
        self.state = BIRefreshHeaderStateRefreshing;
        self.scrollView.bounces = NO;
        [self springAnimation:^{
            [self.scrollView setContentInset:UIEdgeInsetsMake(_offsetThreshold, 0, 0, 0)];
            self.scrollView.contentOffset = CGPointMake(0, -_offsetThreshold);
        } completion:^(BOOL finished) {
            self.scrollView.bounces = YES;
            if (self.refreshHandler) {
                self.refreshHandler();
            }
        }];
    }
}

@end
