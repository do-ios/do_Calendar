//
//  FSCalendarCollectionView.m
//  FSCalendar
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import "DOCalendarCollectionView.h"
#import "DOCalendarCell.h"

@interface DOCalendarCollectionView ()

- (void)initialize;

@end

@implementation DOCalendarCollectionView

@synthesize scrollsToTop = _scrollsToTop, contentInset = _contentInset;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.scrollsToTop = NO;
    self.contentInset = UIEdgeInsetsZero;
#ifdef __IPHONE_9_0
    if ([self respondsToSelector:@selector(setSemanticContentAttribute:)]) {
        self.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    }
#endif
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:UIEdgeInsetsZero];
}

- (void)setScrollsToTop:(BOOL)scrollsToTop
{
    [super setScrollsToTop:NO];
}

@end

