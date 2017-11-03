//
//  FSCalendarHeader.h
//  
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "DOCalendarCollectionView.h"

@class DOCalendar,DOCalendarAppearance;

@interface DOCalendarHeader : UIView

@property (weak, nonatomic) DOCalendarCollectionView *collectionView;
@property (weak, nonatomic) DOCalendar *calendar;
@property (weak, nonatomic) DOCalendarAppearance *appearance;

@property (assign, nonatomic) CGFloat scrollOffset;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) BOOL scrollEnabled;
@property (assign, nonatomic) BOOL needsAdjustingViewFrame;

- (void)reloadData;

@end


@interface DOCalendarHeaderCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) DOCalendarHeader *header;

- (void)invalidateHeaderFont;
- (void)invalidateHeaderTextColor;

@end


@interface DOCalendarHeaderTouchDeliver : UIView

@property (weak, nonatomic) DOCalendar *calendar;
@property (weak, nonatomic) DOCalendarHeader *header;

@end
