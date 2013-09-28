//
//  DLWViewController.m
//  DLWPagedScrollView
//
//  Created by dengliwa on 13-9-28.
//  Copyright (c) 2013年 dengliwa. All rights reserved.
//

#import "DLWViewController.h"
#import "GCPagedScrollView.h"

@interface DLWViewController ()

@property (nonatomic, retain) GCPagedScrollView* scrollView;
- (UIView*) createViewAtIndex:(NSUInteger) index;

@end

@implementation DLWViewController

#pragma mark - View lifecycle

/*
- (void)loadView {
    [super loadView];
    
    GCPagedScrollView* scrollView = [[GCPagedScrollView alloc] initWithFrame:self.view.frame];
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.view = scrollView;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];

    GCPagedScrollView* scrollView = [[GCPagedScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView = scrollView;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:scrollView];
    
    self.scrollView.backgroundColor = [UIColor blackColor];
    
    for (NSUInteger index = 1; index < 5; index ++) {
        //You add your content views here
        [self.scrollView addContentSubview:[self createViewAtIndex:index]];
    }
}

#pragma mark -
#pragma mark Getters
/*
- (GCPagedScrollView *)scrollView {
    return (GCPagedScrollView*) self.view;
}
*/
#pragma mark -
#pragma mark Helper methods

- (UIView *)createViewAtIndex:(NSUInteger)index {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width,
                                                            self.view.frame.size.height - 70)];
    view.backgroundColor = [UIColor colorWithWhite:(255 - (index)*30)/255.0 alpha:1.0];
    UILabel* numberLabel = [[UILabel alloc] initWithFrame:view.bounds];
    numberLabel.text = [NSString stringWithFormat:@"%d", index];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont boldSystemFontOfSize:50.0];
    [view addSubview:numberLabel];

    return view;
}

@end
