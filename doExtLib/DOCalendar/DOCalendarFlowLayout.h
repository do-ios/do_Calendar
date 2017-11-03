//
//  FSCalendarAnimationLayout.h
//  FSCalendar
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DOCalendar;

typedef NS_ENUM(NSUInteger, DOCalendarScope);

@interface DOCalendarFlowLayout : UICollectionViewFlowLayout <UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) DOCalendar *calendar;


@end
