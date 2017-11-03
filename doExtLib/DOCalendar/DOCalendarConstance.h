//
//  FSCalendarConstane.h
//  FSCalendar
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - Constance

UIKIT_EXTERN CGFloat const DOCalendarStandardHeaderHeight;
UIKIT_EXTERN CGFloat const DOCalendarStandardWeekdayHeight;
UIKIT_EXTERN CGFloat const DOCalendarStandardMonthlyPageHeight;
UIKIT_EXTERN CGFloat const DOCalendarStandardWeeklyPageHeight;
UIKIT_EXTERN CGFloat const DOCalendarStandardCellDiameter;
UIKIT_EXTERN CGFloat const DOCalendarAutomaticDimension;
UIKIT_EXTERN CGFloat const DOCalendarDefaultBounceAnimationDuration;
UIKIT_EXTERN CGFloat const DOCalendarStandardRowHeight;
UIKIT_EXTERN CGFloat const DOCalendarStandardTitleTextSize;
UIKIT_EXTERN CGFloat const DOCalendarStandardSubtitleTextSize;
UIKIT_EXTERN CGFloat const DOCalendarStandardWeekdayTextSize;
UIKIT_EXTERN CGFloat const DOCalendarStandardHeaderTextSize;
UIKIT_EXTERN CGFloat const DOCalendarMaximumEventDotDiameter;

UIKIT_EXTERN NSInteger const DOCalendarDefaultHourComponent;

#if TARGET_INTERFACE_BUILDER
#define FSCalendarDeviceIsIPad NO
#else
#define FSCalendarDeviceIsIPad [[UIDevice currentDevice].model hasPrefix:@"iPad"]
#endif

#define FSCalendarStandardSelectionColor  FSColorRGBA(31,119,219,1.0)
#define FSCalendarStandardTodayColor      FSColorRGBA(198,51,42 ,1.0)
#define FSCalendarStandardTitleTextColor  FSColorRGBA(14,69,221 ,1.0)
#define FSCalendarStandardEventDotColor   FSColorRGBA(31,119,219,0.75)

#define FSColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#if CGFLOAT_IS_DOUBLE
#define FSCalendarFloor(c) floor(c)
#else
#define FSCalendarFloor(c) floorf(c)
#endif

#pragma mark - Deprecated

#define FSCalendarDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

FSCalendarDeprecated('FSCalendarCellShape')
typedef NS_ENUM(NSInteger, DOCalendarCellStyle) {
    FSCalendarCellStyleCircle      = 0,
    FSCalendarCellStyleRectangle   = 1
};

FSCalendarDeprecated('FSCalendarScrollDirection')
typedef NS_ENUM(NSInteger, DOCalendarFlow) {
    FSCalendarFlowVertical,
    FSCalendarFlowHorizontal
};
