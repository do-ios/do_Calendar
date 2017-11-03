//
//  FSCalendarDynamicHeader.h
//  
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "DOCalendar.h"
#import "DOCalendarCell.h"
#import "DOCalendarHeader.h"
#import "DOCalendarStickyHeader.h"

@interface DOCalendar (Dynamic)

@property (readonly, nonatomic) CAShapeLayer *maskLayer;
@property (readonly, nonatomic) DOCalendarHeader *header;
@property (readonly, nonatomic) UICollectionView *collectionView;
@property (readonly, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (readonly, nonatomic) NSArray *weekdays;
@property (readonly, nonatomic) BOOL ibEditing;
@property (readonly, nonatomic) BOOL floatingMode;
@property (readonly, nonatomic) NSArray *visibleStickyHeaders;
@property (readonly, nonatomic) CGFloat preferredHeaderHeight;
@property (readonly, nonatomic) CGFloat preferredWeekdayHeight;
@property (readonly, nonatomic) CGFloat preferredRowHeight;
@property (readonly, nonatomic) UIView *bottomBorder;

@property (readonly, nonatomic) NSCalendar *calendar;
@property (readonly, nonatomic) NSDateComponents *components;
@property (readonly, nonatomic) NSDateFormatter *formatter;

@property (readonly, nonatomic) UIView *contentView;
@property (readonly, nonatomic) UIView *daysContainer;

@property (assign, nonatomic) BOOL needsAdjustingMonthPosition;
@property (assign, nonatomic) BOOL needsAdjustingViewFrame;

- (void)invalidateWeekdayFont;
- (void)invalidateWeekdayTextColor;

- (void)invalidateHeaders;
- (void)invalidateWeekdaySymbols;
- (void)invalidateAppearanceForCell:(DOCalendarCell *)cell;

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath scope:(DOCalendarScope)scope;
- (NSIndexPath *)indexPathForDate:(NSDate *)date;
- (NSIndexPath *)indexPathForDate:(NSDate *)date scope:(DOCalendarScope)scope;

- (NSInteger)numberOfHeadPlaceholdersForMonth:(NSDate *)month;

- (CGSize)sizeThatFits:(CGSize)size scope:(DOCalendarScope)scope;

@end

@interface DOCalendarAppearance (Dynamic)

@property (readwrite, nonatomic) DOCalendar *calendar;

@property (readonly, nonatomic) NSDictionary *backgroundColors;
@property (readonly, nonatomic) NSDictionary *titleColors;
@property (readonly, nonatomic) NSDictionary *subtitleColors;
@property (readonly, nonatomic) NSDictionary *borderColors;

@property (readonly, nonatomic) UIFont *preferredTitleFont;
@property (readonly, nonatomic) UIFont *preferredSubtitleFont;
@property (readonly, nonatomic) UIFont *preferredWeekdayFont;
@property (readonly, nonatomic) UIFont *preferredHeaderTitleFont;

- (void)adjustTitleIfNecessary;
- (void)invalidateFonts;

@end


@interface DOCalendarHeader (Dynamic)

@property (readonly, nonatomic) UICollectionView *collectionView;

@end


