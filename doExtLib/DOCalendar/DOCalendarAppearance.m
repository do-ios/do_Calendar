//
//  FSCalendarAppearance.m
//  Pods
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//

#import "DOCalendarAppearance.h"
#import "DOCalendarDynamicHeader.h"
#import "UIView+DOExtension.h"

@interface DOCalendarAppearance ()

@property (weak  , nonatomic) DOCalendar *calendar;

@property (strong, nonatomic) NSMutableDictionary *backgroundColors;
@property (strong, nonatomic) NSMutableDictionary *titleColors;
@property (strong, nonatomic) NSMutableDictionary *subtitleColors;
@property (strong, nonatomic) NSMutableDictionary *borderColors;

@property (strong, nonatomic) NSString *titleFontName;
@property (strong, nonatomic) NSString *subtitleFontName;
@property (strong, nonatomic) NSString *weekdayFontName;
@property (strong, nonatomic) NSString *headerTitleFontName;

@property (assign, nonatomic) CGFloat titleFontSize;
@property (assign, nonatomic) CGFloat subtitleFontSize;
@property (assign, nonatomic) CGFloat weekdayFontSize;
@property (assign, nonatomic) CGFloat headerTitleFontSize;

@property (assign, nonatomic) CGFloat preferredTitleFontSize;
@property (assign, nonatomic) CGFloat preferredSubtitleFontSize;
@property (assign, nonatomic) CGFloat preferredWeekdayFontSize;
@property (assign, nonatomic) CGFloat preferredHeaderTitleFontSize;

@property (readonly, nonatomic) UIFont *preferredTitleFont;
@property (readonly, nonatomic) UIFont *preferredSubtitleFont;
@property (readonly, nonatomic) UIFont *preferredWeekdayFont;
@property (readonly, nonatomic) UIFont *preferredHeaderTitleFont;

- (void)adjustTitleIfNecessary;

- (void)invalidateFonts;
- (void)invalidateTextColors;
- (void)invalidateTitleFont;
- (void)invalidateSubtitleFont;
- (void)invalidateWeekdayFont;
- (void)invalidateHeaderFont;
- (void)invalidateTitleTextColor;
- (void)invalidateSubtitleTextColor;
- (void)invalidateWeekdayTextColor;
- (void)invalidateHeaderTextColor;

- (void)invalidateBorderColors;
- (void)invalidateFillColors;
- (void)invalidateEventColors;
- (void)invalidateCellShapes;

@end

@implementation DOCalendarAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _adjustsFontSizeToFitContentSize = YES;
        
        _titleFontSize = _preferredTitleFontSize  = DOCalendarStandardTitleTextSize;
        _subtitleFontSize = _preferredSubtitleFontSize = DOCalendarStandardSubtitleTextSize;
        _weekdayFontSize = _preferredWeekdayFontSize = DOCalendarStandardWeekdayTextSize;
        _headerTitleFontSize = _preferredHeaderTitleFontSize = DOCalendarStandardHeaderTextSize;
        
        _titleFontName = [UIFont systemFontOfSize:1].fontName;
        _subtitleFontName = [UIFont systemFontOfSize:1].fontName;
        _weekdayFontName = [UIFont systemFontOfSize:1].fontName;
        _headerTitleFontName = [UIFont systemFontOfSize:1].fontName;
        
        _headerTitleColor = FSCalendarStandardTitleTextColor;
        _headerDateFormat = @"MMMM yyyy";
        _headerMinimumDissolvedAlpha = 0.2;
        _weekdayTextColor = FSCalendarStandardTitleTextColor;
        _caseOptions = DOCalendarCaseOptionsHeaderUsesDefaultCase|DOCalendarCaseOptionsWeekdayUsesDefaultCase;
        
        _backgroundColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _backgroundColors[@(DOCalendarCellStateNormal)]      = [UIColor clearColor];
        _backgroundColors[@(DOCalendarCellStateSelected)]    = FSCalendarStandardSelectionColor;
        _backgroundColors[@(DOCalendarCellStateDisabled)]    = [UIColor clearColor];
        _backgroundColors[@(DOCalendarCellStatePlaceholder)] = [UIColor clearColor];
        _backgroundColors[@(DOCalendarCellStateToday)]       = FSCalendarStandardTodayColor;
        
        _titleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _titleColors[@(DOCalendarCellStateNormal)]      = [UIColor blackColor];
        _titleColors[@(DOCalendarCellStateSelected)]    = [UIColor whiteColor];
        _titleColors[@(DOCalendarCellStateDisabled)]    = [UIColor grayColor];
        _titleColors[@(DOCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _titleColors[@(DOCalendarCellStateToday)]       = [UIColor whiteColor];
        
        _subtitleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _subtitleColors[@(DOCalendarCellStateNormal)]      = [UIColor darkGrayColor];
        _subtitleColors[@(DOCalendarCellStateSelected)]    = [UIColor whiteColor];
        _subtitleColors[@(DOCalendarCellStateDisabled)]    = [UIColor lightGrayColor];
        _subtitleColors[@(DOCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _subtitleColors[@(DOCalendarCellStateToday)]       = [UIColor whiteColor];
        
        _borderColors[@(DOCalendarCellStateSelected)] = [UIColor clearColor];
        _borderColors[@(DOCalendarCellStateNormal)] = [UIColor clearColor];
        
        _cellShape = DOCalendarCellShapeCircle;
        _eventColor = FSCalendarStandardEventDotColor;
        
        _borderColors = [NSMutableDictionary dictionaryWithCapacity:2];
        
    }
    return self;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    BOOL needsInvalidating = NO;
    if (![_titleFontName isEqualToString:titleFont.fontName]) {
        _titleFontName = titleFont.fontName;
        needsInvalidating = YES;
    }
    if (_titleFontSize != titleFont.pointSize) {
        _titleFontSize = titleFont.pointSize;
        needsInvalidating = YES;
    }
    if (needsInvalidating) {
        [self invalidateTitleFont];
    }
}

- (UIFont *)titleFont
{
    return [UIFont fontWithName:_titleFontName size:_titleFontSize];
}

- (void)setSubtitleFont:(UIFont *)subtitleFont
{
    BOOL needsInvalidating = NO;
    if (![_subtitleFontName isEqualToString:subtitleFont.fontName]) {
        _subtitleFontName = subtitleFont.fontName;
        needsInvalidating = YES;
    }
    if (_subtitleFontSize != subtitleFont.pointSize) {
        _subtitleFontSize = subtitleFont.pointSize;
        needsInvalidating = YES;
    }
    if (needsInvalidating) {
        [self invalidateSubtitleFont];
    }
}

- (UIFont *)subtitleFont
{
    return [UIFont fontWithName:_subtitleFontName size:_subtitleFontSize];
}

- (void)setWeekdayFont:(UIFont *)weekdayFont
{
    BOOL needsInvalidating = NO;
    if (![_weekdayFontName isEqualToString:weekdayFont.fontName]) {
        _weekdayFontName = weekdayFont.fontName;
        needsInvalidating = YES;
    }
    if (_weekdayFontSize != weekdayFont.pointSize) {
        _weekdayFontSize = weekdayFont.pointSize;
        needsInvalidating = YES;
    }
    if (needsInvalidating) {
        [self invalidateWeekdayFont];
    }
}

- (UIFont *)weekdayFont
{
    return [UIFont fontWithName:_weekdayFontName size:_weekdayFontSize];
}

- (void)setHeaderTitleFont:(UIFont *)headerTitleFont
{
    BOOL needsInvalidating = NO;
    if (![_headerTitleFontName isEqualToString:headerTitleFont.fontName]) {
        _headerTitleFontName = headerTitleFont.fontName;
        needsInvalidating = YES;
    }
    if (_headerTitleFontSize != headerTitleFont.pointSize) {
        _headerTitleFontSize = headerTitleFont.pointSize;
        needsInvalidating = YES;
    }
    if (needsInvalidating) {
        [self invalidateHeaderFont];
    }
}

- (void)setTitleVerticalOffset:(CGFloat)titleVerticalOffset
{
    if (_titleVerticalOffset != titleVerticalOffset) {
        _titleVerticalOffset = titleVerticalOffset;
        [_calendar.collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setSubtitleVerticalOffset:(CGFloat)subtitleVerticalOffset
{
    if (_subtitleVerticalOffset != subtitleVerticalOffset) {
        _subtitleVerticalOffset = subtitleVerticalOffset;
        [_calendar.collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (UIFont *)headerTitleFont
{
    return [UIFont fontWithName:_headerTitleFontName size:_headerTitleFontSize];
}

- (void)setTitleDefaultColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(DOCalendarCellStateNormal)] = color;
    } else {
        [_titleColors removeObjectForKey:@(DOCalendarCellStateNormal)];
    }
    [self invalidateTitleTextColor];
}

- (UIColor *)titleDefaultColor
{
    return _titleColors[@(DOCalendarCellStateNormal)];
}

- (void)setTitleSelectionColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(DOCalendarCellStateSelected)] = color;
    } else {
        [_titleColors removeObjectForKey:@(DOCalendarCellStateSelected)];
    }
    [self invalidateTitleTextColor];
}

- (UIColor *)titleSelectionColor
{
    return _titleColors[@(DOCalendarCellStateSelected)];
}

- (void)setTitleTodayColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(DOCalendarCellStateToday)] = color;
    } else {
        [_titleColors removeObjectForKey:@(DOCalendarCellStateToday)];
    }
    [self invalidateTitleTextColor];
}

- (UIColor *)titleTodayColor
{
    return _titleColors[@(DOCalendarCellStateToday)];
}

- (void)setTitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(DOCalendarCellStatePlaceholder)] = color;
    } else {
        [_titleColors removeObjectForKey:@(DOCalendarCellStatePlaceholder)];
    }
    [self invalidateTitleTextColor];
}

- (UIColor *)titlePlaceholderColor
{
    return _titleColors[@(DOCalendarCellStatePlaceholder)];
}

- (void)setTitleWeekendColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(DOCalendarCellStateWeekend)] = color;
    } else {
        [_titleColors removeObjectForKey:@(DOCalendarCellStateWeekend)];
    }
    [self invalidateTitleTextColor];
}

- (UIColor *)titleWeekendColor
{
    return _titleColors[@(DOCalendarCellStateWeekend)];
}

- (void)setSubtitleDefaultColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(DOCalendarCellStateNormal)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(DOCalendarCellStateNormal)];
    }
    [self invalidateSubtitleTextColor];
}

-(UIColor *)subtitleDefaultColor
{
    return _subtitleColors[@(DOCalendarCellStateNormal)];
}

- (void)setSubtitleSelectionColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(DOCalendarCellStateSelected)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(DOCalendarCellStateSelected)];
    }
    [self invalidateSubtitleTextColor];
}

- (UIColor *)subtitleSelectionColor
{
    return _subtitleColors[@(DOCalendarCellStateSelected)];
}

- (void)setSubtitleTodayColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(DOCalendarCellStateToday)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(DOCalendarCellStateToday)];
    }
    [self invalidateSubtitleTextColor];
}

- (UIColor *)subtitleTodayColor
{
    return _subtitleColors[@(DOCalendarCellStateToday)];
}

- (void)setSubtitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(DOCalendarCellStatePlaceholder)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(DOCalendarCellStatePlaceholder)];
    }
    [self invalidateSubtitleTextColor];
}

- (UIColor *)subtitlePlaceholderColor
{
    return _subtitleColors[@(DOCalendarCellStatePlaceholder)];
}

- (void)setSubtitleWeekendColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(DOCalendarCellStateWeekend)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(DOCalendarCellStateWeekend)];
    }
    [self invalidateSubtitleTextColor];
}

- (UIColor *)subtitleWeekendColor
{
    return _subtitleColors[@(DOCalendarCellStateWeekend)];
}

- (void)setSelectionColor:(UIColor *)color
{
    if (color) {
        _backgroundColors[@(DOCalendarCellStateSelected)] = color;
    } else {
        [_backgroundColors removeObjectForKey:@(DOCalendarCellStateSelected)];
    }
    [self invalidateFillColors];
}

- (UIColor *)selectionColor
{
    return _backgroundColors[@(DOCalendarCellStateSelected)];
}

- (void)setTodayColor:(UIColor *)todayColor
{
    if (todayColor) {
        _backgroundColors[@(DOCalendarCellStateToday)] = todayColor;
    } else {
        [_backgroundColors removeObjectForKey:@(DOCalendarCellStateToday)];
    }
    [self invalidateFillColors];
}

- (UIColor *)todayColor
{
    return _backgroundColors[@(DOCalendarCellStateToday)];
}

- (void)setTodaySelectionColor:(UIColor *)todaySelectionColor
{
    if (todaySelectionColor) {
        _backgroundColors[@(DOCalendarCellStateToday|DOCalendarCellStateSelected)] = todaySelectionColor;
    } else {
        [_backgroundColors removeObjectForKey:@(DOCalendarCellStateToday|DOCalendarCellStateSelected)];
    }
    [self invalidateFillColors];
}

- (UIColor *)todaySelectionColor
{
    return _backgroundColors[@(DOCalendarCellStateToday|DOCalendarCellStateSelected)];
}

- (void)setEventColor:(UIColor *)eventColor
{
    if (![_eventColor isEqual:eventColor]) {
        _eventColor = eventColor;
        [self invalidateEventColors];
    }
}

- (void)setBorderDefaultColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(DOCalendarCellStateNormal)] = color;
    } else {
        [_borderColors removeObjectForKey:@(DOCalendarCellStateNormal)];
    }
    [self invalidateBorderColors];
}

- (UIColor *)borderDefaultColor
{
    return _borderColors[@(DOCalendarCellStateNormal)];
}

- (void)setBorderSelectionColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(DOCalendarCellStateSelected)] = color;
    } else {
        [_borderColors removeObjectForKey:@(DOCalendarCellStateSelected)];
    }
    [self invalidateBorderColors];
}

- (UIColor *)borderSelectionColor
{
    return _borderColors[@(DOCalendarCellStateSelected)];
}

- (void)setCellShape:(DOCalendarCellShape)cellShape
{
    if (_cellShape != cellShape) {
        _cellShape = cellShape;
        [self invalidateCellShapes];
    }
}

- (void)setWeekdayTextColor:(UIColor *)weekdayTextColor
{
    if (![_weekdayTextColor isEqual:weekdayTextColor]) {
        _weekdayTextColor = weekdayTextColor;
        [self invalidateWeekdayTextColor];
    }
}

- (void)setHeaderTitleColor:(UIColor *)color
{
    if (![_headerTitleColor isEqual:color]) {
        _headerTitleColor = color;
        [self invalidateHeaderTextColor];
    }
}

- (void)setHeaderMinimumDissolvedAlpha:(CGFloat)headerMinimumDissolvedAlpha
{
    if (_headerMinimumDissolvedAlpha != headerMinimumDissolvedAlpha) {
        _headerMinimumDissolvedAlpha = headerMinimumDissolvedAlpha;
        [_calendar.header.collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
        [_calendar.visibleStickyHeaders makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setHeaderDateFormat:(NSString *)headerDateFormat
{
    if (![_headerDateFormat isEqual:headerDateFormat]) {
        _headerDateFormat = headerDateFormat;
        [_calendar invalidateHeaders];
    }
}

- (void)setAdjustsFontSizeToFitContentSize:(BOOL)adjustsFontSizeToFitContentSize
{
    if (_adjustsFontSizeToFitContentSize != adjustsFontSizeToFitContentSize) {
        _adjustsFontSizeToFitContentSize = adjustsFontSizeToFitContentSize;
        if (adjustsFontSizeToFitContentSize) {
            [self invalidateFonts];
        }
    }
}

- (UIFont *)preferredTitleFont
{
    return [UIFont fontWithName:_titleFontName size:_adjustsFontSizeToFitContentSize?_preferredTitleFontSize:_titleFontSize];
}

- (UIFont *)preferredSubtitleFont
{
    return [UIFont fontWithName:_subtitleFontName size:_adjustsFontSizeToFitContentSize?_preferredSubtitleFontSize:_subtitleFontSize];
}

- (UIFont *)preferredWeekdayFont
{
    return [UIFont fontWithName:_weekdayFontName size:_adjustsFontSizeToFitContentSize?_preferredWeekdayFontSize:_weekdayFontSize];
}

- (UIFont *)preferredHeaderTitleFont
{
    return [UIFont fontWithName:_headerTitleFontName size:_adjustsFontSizeToFitContentSize?_preferredHeaderTitleFontSize:_headerTitleFontSize];
}

- (void)adjustTitleIfNecessary
{
    if (!self.calendar.floatingMode) {
        if (_adjustsFontSizeToFitContentSize) {
            CGFloat factor       = (_calendar.scope==DOCalendarScopeMonth) ? 6 : 1.1;
            _preferredTitleFontSize       = _calendar.collectionView.fs_height/3/factor;
            _preferredTitleFontSize       -= (_preferredTitleFontSize-DOCalendarStandardTitleTextSize)*0.5;
            _preferredSubtitleFontSize    = _calendar.collectionView.fs_height/4.5/factor;
            _preferredSubtitleFontSize    -= (_preferredSubtitleFontSize-DOCalendarStandardSubtitleTextSize)*0.75;
            _preferredHeaderTitleFontSize = _preferredTitleFontSize * 1.25;
            _preferredWeekdayFontSize     = _preferredTitleFontSize;
            
        }
    } else {
        _preferredHeaderTitleFontSize = 20;
        if (FSCalendarDeviceIsIPad) {
            _preferredHeaderTitleFontSize = DOCalendarStandardHeaderTextSize * 1.5;
            _preferredTitleFontSize = DOCalendarStandardTitleTextSize * 1.3;
            _preferredSubtitleFontSize = DOCalendarStandardSubtitleTextSize * 1.15;
            _preferredWeekdayFontSize = _preferredTitleFontSize;
        }
        CGFloat multiplier = 1+(_calendar.lineHeightMultiplier-1)/4;
        _preferredHeaderTitleFontSize *= multiplier;
        _preferredTitleFontSize *= multiplier;
        _preferredSubtitleFontSize *= multiplier;
        _preferredSubtitleFontSize *= multiplier;
    }
    
    // reload appearance
    [self invalidateFonts];
}

- (void)setCaseOptions:(DOCalendarCaseOptions)caseOptions
{
    if (_caseOptions != caseOptions) {
        _caseOptions = caseOptions;
        [_calendar invalidateWeekdaySymbols];
        [_calendar invalidateHeaders];
    }
}

- (void)invalidateAppearance
{
    [self invalidateFonts];
    [self invalidateTextColors];
    [self invalidateBorderColors];
    [self invalidateFillColors];
    /*
    [_calendar.collectionView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_calendar invalidateAppearanceForCell:obj];
    }];
    [_calendar.header.collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    [_calendar.visibleStickyHeaders makeObjectsPerformSelector:@selector(setNeedsLayout)];
     */
}

- (void)invalidateFonts
{
    [self invalidateTitleFont];
    [self invalidateSubtitleFont];
    [self invalidateWeekdayFont];
    [self invalidateHeaderFont];
}

- (void)invalidateTextColors
{
    [self invalidateTitleTextColor];
    [self invalidateSubtitleTextColor];
    [self invalidateWeekdayTextColor];
    [self invalidateHeaderTextColor];
}

- (void)invalidateBorderColors
{
    [_calendar.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
}

- (void)invalidateFillColors
{
    [_calendar.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
}

- (void)invalidateEventColors
{
    [_calendar.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
}

- (void)invalidateCellShapes
{
    [_calendar.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
}

- (void)invalidateTitleFont
{
    [_calendar.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
}

- (void)invalidateSubtitleFont
{
    [_calendar.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
}

- (void)invalidateTitleTextColor
{
    [_calendar.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
}

- (void)invalidateSubtitleTextColor
{
    [_calendar.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
}

- (void)invalidateWeekdayFont
{
    [_calendar invalidateWeekdayFont];
    [_calendar.visibleStickyHeaders makeObjectsPerformSelector:_cmd];
}

- (void)invalidateWeekdayTextColor
{
    [_calendar invalidateWeekdayTextColor];
    [_calendar.visibleStickyHeaders makeObjectsPerformSelector:_cmd];
}

- (void)invalidateHeaderFont
{
    [_calendar.header.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
    [_calendar.visibleStickyHeaders makeObjectsPerformSelector:_cmd];
}

- (void)invalidateHeaderTextColor
{
    [_calendar.header.collectionView.visibleCells makeObjectsPerformSelector:_cmd];
    [_calendar.visibleStickyHeaders makeObjectsPerformSelector:_cmd];
}

@end


@implementation DOCalendarAppearance (Deprecated)

- (void)setCellStyle:(DOCalendarCellStyle)cellStyle
{
    self.cellShape = (DOCalendarCellShape)cellStyle;
}

- (DOCalendarCellStyle)cellStyle
{
    return (DOCalendarCellStyle)self.cellShape;
}

- (void)setUseVeryShortWeekdaySymbols:(BOOL)useVeryShortWeekdaySymbols
{
    _caseOptions &= 15;
    self.caseOptions |= (useVeryShortWeekdaySymbols*DOCalendarCaseOptionsWeekdayUsesSingleUpperCase);
}

- (BOOL)useVeryShortWeekdaySymbols
{
    return (_caseOptions & (15<<4) ) == DOCalendarCaseOptionsWeekdayUsesSingleUpperCase;
}

- (void)setAutoAdjustTitleSize:(BOOL)autoAdjustTitleSize
{
    self.adjustsFontSizeToFitContentSize = autoAdjustTitleSize;
}

- (BOOL)autoAdjustTitleSize
{
    return self.adjustsFontSizeToFitContentSize;
}

- (void)setTitleTextSize:(CGFloat)titleTextSize
{
    self.titleFont = [UIFont fontWithName:_titleFontName size:titleTextSize];
}

- (CGFloat)titleTextSize
{
    return _titleFontSize;
}

- (void)setSubtitleTextSize:(CGFloat)subtitleTextSize
{
    self.subtitleFont = [UIFont fontWithName:_subtitleFontName size:subtitleTextSize];
}

- (CGFloat)subtitleTextSize
{
    return _subtitleFontSize;
}

- (void)setWeekdayTextSize:(CGFloat)weekdayTextSize
{
    self.weekdayFont = [UIFont fontWithName:_weekdayFontName size:weekdayTextSize];
}

- (CGFloat)weekdayTextSize
{
    return _weekdayFontSize;
}

- (void)setHeaderTitleTextSize:(CGFloat)headerTitleTextSize
{
    self.headerTitleFont = [UIFont fontWithName:_headerTitleFontName size:headerTitleTextSize];
}

- (CGFloat)headerTitleTextSize
{
    return _headerTitleFontSize;
}

- (void)setAdjustsFontSizeToFitCellSize:(BOOL)adjustsFontSizeToFitCellSize
{
    self.adjustsFontSizeToFitContentSize = adjustsFontSizeToFitCellSize;
}

- (BOOL)adjustsFontSizeToFitCellSize
{
    return self.adjustsFontSizeToFitContentSize;
}

@end


