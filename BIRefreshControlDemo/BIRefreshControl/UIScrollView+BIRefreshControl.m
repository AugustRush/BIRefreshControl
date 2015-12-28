//
//  UIScrollView+BIRefreshHeader.m
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/24/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import "UIScrollView+BIRefreshControl.h"
#import <objc/runtime.h>

@interface UIScrollView (BIRefreshExtension)

@end

@implementation UIScrollView (BIRefreshExtension)

- (void)setRefreshHeader:(BIRefreshHeader *)refreshHeader {
  objc_setAssociatedObject(self, @selector(refreshHeader), refreshHeader,
                           OBJC_ASSOCIATION_ASSIGN);
}

- (BIRefreshHeader *)refreshHeader {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setLoadingFooter:(BILoadingFooter *)loadingFooter {
  objc_setAssociatedObject(self, @selector(loadingFooter), loadingFooter,
                           OBJC_ASSOCIATION_ASSIGN);
}

- (BILoadingFooter *)loadingFooter {
  return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation UIScrollView (BIRefreshHeader)

#pragma mark - public methods

- (void)bi_addRefreshHeaderWithControl:(BIRefreshHeader *)control
                                Height:(CGFloat)height
                        refreshHandler:(void (^)(void))handler {
  if (self.refreshHeader != nil) {
    [self.refreshHeader removeFromSuperview];
    self.refreshHeader = nil;
  }
  control.refreshHandler = handler;
  control.offsetThreshold = height;
  [self addSubview:control];
  // associate
  self.refreshHeader = control;
  // layout
  [self initializeLayoutWithRefreshControl:control height:height];
}

- (void)bi_addLoadingFooterWithControl:(BILoadingFooter *)control
                                height:(CGFloat)height
                        loadingHandler:(void (^)(void))handler {
  if (self.loadingFooter != nil) {
    [self.loadingFooter removeFromSuperview];
    self.loadingFooter = nil;
  }
  control.loadingHandler = handler;
  control.offsetThreshold = height;
  [self addSubview:control];

  // associate
  self.loadingFooter = control;
  // layout
  [self initializeLayoutWithLoadingControl:control height:height];
}

- (void)bi_startRefreshing {
  [self.refreshHeader startRefreshing];
}

- (void)bi_stopRefreshing {
  [self.refreshHeader stopRefreshing];
}

- (void)bi_startLoading {
  [self.loadingFooter startLoading];
}

- (void)bi_stopLoading {
  [self.loadingFooter stopLoading];
}

#pragma mark - private methods

- (void)initializeLayoutWithRefreshControl:(BIRefreshHeader *)control
                                    height:(CGFloat)height {
  control.translatesAutoresizingMaskIntoConstraints = NO;

  NSLayoutConstraint *leftConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeLeft
                                  multiplier:1
                                    constant:0];

  NSLayoutConstraint *topConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeTop
                                  multiplier:1
                                    constant:-height];
  NSLayoutConstraint *rightConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeRight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeRight
                                  multiplier:1
                                    constant:0];
  NSLayoutConstraint *heightConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                    constant:height];
  // must add width constraint for control,because scrollView's width up to its
  // subViews
  NSLayoutConstraint *widthConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeWidth
                                  multiplier:1
                                    constant:0];

  [self addConstraints:@[
    leftConstraint,
    topConstraint,
    rightConstraint,
    heightConstraint,
    widthConstraint
  ]];
}

- (void)initializeLayoutWithLoadingControl:(BILoadingFooter *)control
                                    height:(CGFloat)height {
  control.translatesAutoresizingMaskIntoConstraints = NO;

  NSLayoutConstraint *leftConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeLeft
                                  multiplier:1
                                    constant:0];

  NSLayoutConstraint *topConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeTop
                                  multiplier:1
                                    constant:0];
  [self.loadingFooter
      setValue:topConstraint
        forKey:@"topConstraint"]; // assignment an private property
  NSLayoutConstraint *rightConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeRight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeRight
                                  multiplier:1
                                    constant:0];
  NSLayoutConstraint *heightConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                    constant:height];
  // must add width constraint for control,because scrollView's width up to its
  // subViews
  NSLayoutConstraint *widthConstraint =
      [NSLayoutConstraint constraintWithItem:control
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeWidth
                                  multiplier:1
                                    constant:0];

  [self addConstraints:@[
    leftConstraint,
    topConstraint,
    rightConstraint,
    heightConstraint,
    widthConstraint
  ]];
}

@end
