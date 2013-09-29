//
//  DLWPagedScrollView.h
//  DLWPagedScrollView
//
//  Created by dengliwa on 13-9-28.
//  Copyright (c) 2013 dengliwa. All rights reserved.

#import <UIKit/UIKit.h>

//Simple UIScrollView subclass that automatically handle UIPageControl and paged content
@interface DLWPagedScrollView : UIScrollView

@property (nonatomic, assign) NSUInteger page; //Zero based number of page

- (void) setPage:(NSUInteger)page animated:(BOOL) animated;

//Add or remove content view from the scrollview
- (void) addContentSubview:(UIView*) view;
- (void) addContentSubview:(UIView*) view atIndex:(NSUInteger) index;
- (void) addContentSubviewsFromArray:(NSArray*) contentViews;

- (void) removeContentSubview:(UIView*) view;
- (void) removeContentSubviewAtIndex:(NSUInteger) index;
- (void) removeAllContentSubviews;

@end
