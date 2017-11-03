//
//  NSString+FSExtension.m
//  FSCalendar
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import "NSString+DOExtension.h"
#import "NSDate+DOExtension.h"

@implementation NSString (DOExtension)

- (NSDate *)fs_dateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [NSDateFormatter fs_sharedDateFormatter];
    formatter.dateFormat = format;
    return [formatter dateFromString:self];
}

- (NSDate *)fs_date
{
    return [self fs_dateWithFormat:@"yyyyMMdd"];
}

@end
