//  DLWPagedScrollView.m
//  DLWPagedScrollView
//
//  Created by dengliwa on 13-9-28.
//  Copyright (c) 2013 dengliwa. All rights reserved.
//

#import "DLWPagedScrollView.h"
#import <QuartzCore/CATransaction.h>

NSString * const GCPagedScrollViewContentOffsetKey = @"contentOffset";
static void *GCContextPointer = &GCContextPointer;
const CGFloat GCPagedScrollViewPageControlHeight = 36.0;

@interface DLWPagedScrollView ()

@property (nonatomic, assign) BOOL touched;
@property (nonatomic, retain) NSMutableArray *points;
@property (nonatomic, readonly) NSMutableArray* views;
@property (nonatomic, readonly) UIPageControl* pageControl;

- (void) updateViewPositionAndPageControl;
- (void) changePage:(UIPageControl*) aPageControl;

@end

@implementation DLWPagedScrollView

@synthesize views;
@synthesize pageControl;

#pragma mark -
#pragma mark Subclass

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.bounces = NO;
        self.page = 0;
        
        //Place page control
        CGRect frame = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, GCPagedScrollViewPageControlHeight);
        UIPageControl* aPageControl = [[UIPageControl alloc] initWithFrame:frame];
        [aPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        aPageControl.defersCurrentPageDisplay = YES;
        aPageControl.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
        [self addSubview:aPageControl];
        
        pageControl = aPageControl;
    }
    return self;
}


- (void) setPagingEnabled:(BOOL) pagingEnabled {
    if (pagingEnabled) [super setPagingEnabled:pagingEnabled];
    else {
        [NSException raise:@"Disabling pagingEnabled" format:@"Paging enabled should not be disabled in GCPagedScrollView"];
    }
}

#pragma mark -
#pragma mark Add/Remove content

- (void) addContentSubview:(UIView *)view {
    [self addContentSubview:view atIndex:[self.views count]];
}

- (void) addContentSubview:(UIView *)view atIndex:(NSUInteger)index {
    view.tag = self.views.count + 100;
    [self insertSubview:view atIndex:index];
    [self.views insertObject:view atIndex:index];
    [self updateViewPositionAndPageControl];
    self.contentOffset = CGPointMake(0, -self.scrollIndicatorInsets.top);
}

- (void)addContentSubviewsFromArray:(NSArray *)contentViews {
    for (UIView* contentView in contentViews) {
        [self addContentSubview:contentView];
    }
}

- (void) removeContentSubview:(UIView *)view {
    [view removeFromSuperview];
    
    [self.views removeObject:view];
    [self updateViewPositionAndPageControl];
}

- (void)removeContentSubviewAtIndex:(NSUInteger)index {
    [self removeContentSubview:[self.views objectAtIndex:index]];
}

- (void) removeAllContentSubviews {
    for (UIView* view in self.views) {
        [view removeFromSuperview];
    }
    
    [self.views removeAllObjects];
    [self updateViewPositionAndPageControl];
}

#pragma mark -
#pragma mark Layout

- (void) updateViewPositionAndPageControl {
    self.points  = [[NSMutableArray alloc] initWithCapacity:self.views.count];
    
    [self.views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* view = (UIView*) obj;
        view.center = CGPointMake(self.frame.size.width * idx + self.frame.size.width / 2, 
                                  (self.frame.size.height - GCPagedScrollViewPageControlHeight) / 2);
        [self.points addObject:[NSValue valueWithCGPoint:view.frame.origin]];
    }];
    
    UIEdgeInsets inset = self.scrollIndicatorInsets;
    CGFloat heightInset = inset.top + inset.bottom;
    self.contentSize = CGSizeMake(self.frame.size.width * [self.views count], self.frame.size.height - heightInset);
    self.pageControl.numberOfPages = self.views.count;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    //Avoid that the pageControl move
    
    CGRect frame = self.pageControl.frame;
    
    if (frame.origin.x <= self.contentOffset.x) {
        for (int i = 0; i < self.views.count - 1; i++) {
            UIView *view = [self.views objectAtIndex:i];
            CGRect rect = view.frame;
            if (rect.origin.x < self.contentOffset.x) {
                rect.origin.x = self.contentOffset.x;
                view.frame = rect;
            }
        }
    }else{
        for (int i = self.views.count-1; i >=0 ; i--) {
            UIView *view = [self.views objectAtIndex:i];
            CGRect rect = view.frame;
            CGPoint point = [self.points[i] CGPointValue];
            if (rect.origin.x > point.x) {
                rect.origin.x = self.contentOffset.x;
                view.frame = rect;
            }
        }
    }

    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    frame.origin.x = self.contentOffset.x;
    frame.origin.y = self.frame.size.height - GCPagedScrollViewPageControlHeight - self.scrollIndicatorInsets.bottom - self.scrollIndicatorInsets.top;
    frame.size.width = self.frame.size.width;
    self.pageControl.frame = frame;

    [CATransaction commit];
    
}

#pragma mark -
#pragma mark Getters/Setters

- (void) setFrame:(CGRect) newFrame {
    [super setFrame:newFrame];
    [self updateViewPositionAndPageControl];
}

- (void) changePage:(UIPageControl*) aPageControl {
    [self setPage:aPageControl.currentPage animated:YES];
}

- (void) setContentOffset:(CGPoint) new {
    new.y = -self.scrollIndicatorInsets.top;
    [super setContentOffset:new];
    self.pageControl.currentPage = self.page; //Update the page number
}

- (NSMutableArray*) views {
    if (views == nil) {
        views = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return views;
}

- (NSUInteger) page {
    return (self.contentOffset.x + self.frame.size.width / 2) / self.frame.size.width;
}

- (void) setPage:(NSUInteger)page {
    [self setPage:page animated:NO];
}

- (void) setPage:(NSUInteger)page animated:(BOOL) animated {
    [self setContentOffset:CGPointMake(page * self.frame.size.width, - self.scrollIndicatorInsets.top) animated:animated];
}


@end
