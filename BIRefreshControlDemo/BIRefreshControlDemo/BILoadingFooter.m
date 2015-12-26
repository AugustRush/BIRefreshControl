//
//  BILoadingControl.m
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/25/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import "BILoadingFooter.h"
#import "BIRefresh.h"
#import "BIRefreshHeader.h"

static void *BILoadingFooterObserverContentSizeContext = &BILoadingFooterObserverContentSizeContext;
static void *BILoadingFooterObserverContentOffsetContext = &BILoadingFooterObserverContentOffsetContext;

@interface BILoadingFooter ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets origianlInset;
@property (nonatomic, weak) NSLayoutConstraint *topConstraint;

@end

@implementation BILoadingFooter

#pragma mark - init methods

- (instancetype)init {
    self = [super init];
    if (self) {
        self.state = BILoadingFooterStateInitial;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.state = BILoadingFooterStateInitial;
    }
    return self;
}

#pragma mark - override methods

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (self.superview) {
        [self removeLoadingControlObservers];
    }
    
    if (self.superview == nil && [newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.origianlInset = self.scrollView.contentInset;
        [self addRefreshControlObservers];
    }
}

#pragma mark - private methods

- (void)removeLoadingControlObservers {
    @try {
        [self.superview removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
        [self.superview removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)addRefreshControlObservers {
    [self.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionNew context:BILoadingFooterObserverContentSizeContext];
    [self.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:BILoadingFooterObserverContentOffsetContext];
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

- (BOOL)canLoading {
    return self.scrollView.refreshHeader.state != BIRefreshHeaderStateRefreshing;
}

#pragma mark - NSKeyValueObserving method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == BILoadingFooterObserverContentSizeContext) {
        CGSize newSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        //
        self.topConstraint.constant = MAX(newSize.height + self.origianlInset.top, CGRectGetHeight(self.scrollView.bounds));
        [self.scrollView bringSubviewToFront:self];
    }else if (context == BILoadingFooterObserverContentOffsetContext) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat contentHeight = MAX(self.scrollView.contentSize.height, CGRectGetHeight(self.scrollView.bounds));
        CGFloat progress = (offset.y + CGRectGetHeight(self.scrollView.bounds) - contentHeight)/self.offsetThreshold;
        if (offset.y > 0 &&
            progress > 1 &&
            self.scrollView.isTracking == NO) {
            [self startLoading];
        }
        if (offset.y > 0 &&
            [self.delegate respondsToSelector:@selector(loadingFooter:didChangedLoadingProgress:)]) {
            if (progress < 0) {
                progress = 0;
            }
            //if it's loading just make progress as 1
            [self.delegate loadingFooter:self didChangedLoadingProgress:(_state == BILoadingFooterStateLoading) ? 1:progress];
        }
    }
}

#pragma mark - public methods

- (void)startLoading {
    if (self.state != BILoadingFooterStateLoading &&
        [self canLoading]) {
        self.state = BILoadingFooterStateLoading;
        self.scrollView.bounces = NO;
        //when contentSize.height < scrollView.bounds.size.height
        CGFloat height = CGRectGetHeight(self.scrollView.bounds) - self.origianlInset.top - self.origianlInset.bottom - self.scrollView.contentSize.height;
        if (height < 0) {
            height = 0;
        }
        [self springAnimation:^{
            UIEdgeInsets inset = self.origianlInset;
            inset.bottom += (self.offsetThreshold + height);
            [self.scrollView setContentInset:inset];
        } completion:^(BOOL finished) {
            self.scrollView.bounces = YES;
            if (self.loadingHandler) {
                self.loadingHandler();
            }
        }];
    }
}

- (void)stopLoading {
    if (self.state != BILoadingFooterStateFinished) {
        [self springAnimation:^{
            [self.scrollView setContentInset:self.origianlInset];
        } completion:^(BOOL finished) {
            self.state = BILoadingFooterStateFinished;
        }];
    }
}

@end
