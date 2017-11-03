//
//  NSString+FSExtension.h
//  FSCalendar
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DOExtension)

- (NSDate *)fs_dateWithFormat:(NSString *)format;
- (NSDate *)fs_date;

@end
