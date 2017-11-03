//
//  FSCalendarStaticHeader.h
//  FSCalendar
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DOCalendar,DOCalendarAppearance;

@interface DOCalendarStickyHeader : UICollectionReusableView

@property (weak, nonatomic) DOCalendar *calendar;
@property (weak, nonatomic) DOCalendarAppearance *appearance;

@property (weak, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSArray *weekdayLabels;
@property (strong, nonatomic) NSDate *month;

- (void)invalidateHeaderFont;
- (void)invalidateHeaderTextColor;
- (void)invalidateWeekdayFont;
- (void)invalidateWeekdayTextColor;

- (void)invalidateWeekdaySymbols;

@end