//
//  FSCalendarAnimator.h
//  FSCalendar
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOCalendar.h"
#import "DOCalendarCollectionView.h"
#import "DOCalendarFlowLayout.h"
#import "DOCalendarDynamicHeader.h"

typedef NS_ENUM(NSUInteger, DOCalendarTransition) {
    DOCalendarTransitionNone,
    DOCalendarTransitionMonthToWeek,
    DOCalendarTransitionWeekToMonth
};
typedef NS_ENUM(NSUInteger, DOCalendarTransitionState) {
    DOCalendarTransitionStateIdle,
    DOCalendarTransitionStateInProgress
};

@interface DOCalendarAnimator : NSObject

@property (weak, nonatomic) DOCalendar *calendar;
@property (weak, nonatomic) DOCalendarCollectionView *collectionView;
@property (weak, nonatomic) DOCalendarFlowLayout *collectionViewLayout;

@property (assign, nonatomic) DOCalendarTransition transition;
@property (assign, nonatomic) DOCalendarTransitionState state;

@property (assign, nonatomic) CGSize cachedMonthSize;

- (void)performScopeTransitionFromScope:(DOCalendarScope)fromScope toScope:(DOCalendarScope)toScope animated:(BOOL)animated;
- (void)performBoudingRectTransitionFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth duration:(CGFloat)duration;

@end
