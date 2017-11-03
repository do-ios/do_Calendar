//
//  FSCalendarEventView.h
//  FSCalendar
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOCalendarEventIndicator : UIView

@property (assign, nonatomic) NSInteger numberOfEvents;
@property (strong, nonatomic) id color;
@property (assign, nonatomic) BOOL needsAdjustingViewFrame;

@end
