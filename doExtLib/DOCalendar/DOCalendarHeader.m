//
//  FSCalendarHeader.m
//  
//
//  Created by @userName on @time.
//  Copyright (c) 2016年 DoExt. All rights reserved.
//
//

#import "DOCalendar.h"
#import "UIView+DOExtension.h"
#import "DOCalendarHeader.h"
#import "DOCalendarCollectionView.h"
#import "DOCalendarDynamicHeader.h"

@interface DOCalendarHeader ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;

@property (assign, nonatomic) BOOL needsAdjustingMonthPosition;

@end

@implementation DOCalendarHeader


#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scrollEnabled = YES;
    _needsAdjustingMonthPosition = YES;
    _needsAdjustingViewFrame = YES;
    
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing = 0;
    collectionViewLayout.sectionInset = UIEdgeInsetsZero;
    collectionViewLayout.itemSize = CGSizeMake(1, 1);
    self.collectionViewLayout = collectionViewLayout;
    
    DOCalendarCollectionView *collectionView = [[DOCalendarCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    collectionView.scrollEnabled = NO;
    collectionView.userInteractionEnabled = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:collectionView];
    [collectionView registerClass:[DOCalendarHeaderCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = collectionView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_needsAdjustingViewFrame) {
        _needsAdjustingViewFrame = NO;
        _collectionViewLayout.itemSize = CGSizeMake(1, 1);
        _collectionView.frame = CGRectMake(0, self.fs_height*0.1, self.fs_width, self.fs_height*0.9);
        _collectionViewLayout.itemSize = CGSizeMake(
                                                        _collectionView.fs_width*((_scrollDirection==UICollectionViewScrollDirectionHorizontal)?0.5:1),
                                                        _collectionView.fs_height
                                                       );
    }
    
    if (_needsAdjustingMonthPosition) {
        _needsAdjustingMonthPosition = NO;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            [_collectionView setContentOffset:CGPointMake((_scrollOffset+0.5)*_collectionViewLayout.itemSize.width, 0) animated:NO];
        } else {
            [_collectionView setContentOffset:CGPointMake(0, _scrollOffset * _collectionViewLayout.itemSize.height) animated:NO];
        }
    };
    
}

- (void)dealloc
{
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (self.calendar.scope) {
        case DOCalendarScopeMonth: {
            switch (_scrollDirection) {
                case UICollectionViewScrollDirectionVertical: {
                    NSDate *minimumPage = [_calendar beginingOfMonthOfDate:_calendar.minimumDate];
                    NSInteger count = [_calendar monthsFromDate:minimumPage toDate:_calendar.maximumDate] + 1;
                    return count;
                }
                case UICollectionViewScrollDirectionHorizontal: {
                    // 这里需要默认多出两项，否则当contentOffset为负时，切换到其他页面时会自动归零
                    // 2 more pages to prevent scrollView from auto bouncing while push/present to other UIViewController
                    NSDate *minimumPage = [_calendar beginingOfMonthOfDate:_calendar.minimumDate];
                    NSInteger count = [_calendar monthsFromDate:minimumPage toDate:_calendar.maximumDate] + 1;
                    return count + 2;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case DOCalendarScopeWeek: {
            NSDate *minimumPage = [_calendar beginingOfMonthOfDate:_calendar.minimumDate];
            NSInteger count = [_calendar weeksFromDate:minimumPage toDate:_calendar.maximumDate] + 1;
            return count + 2;
        }
        default: {
            break;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DOCalendarHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.header = self;
    cell.titleLabel.font = _appearance.preferredHeaderTitleFont;
    cell.titleLabel.textColor = _appearance.headerTitleColor;
    _calendar.formatter.dateFormat = _appearance.headerDateFormat;
    BOOL usesUpperCase = (_appearance.caseOptions & 15) == DOCalendarCaseOptionsHeaderUsesUpperCase;
    NSString *text = nil;
    switch (self.calendar.scope) {
        case DOCalendarScopeMonth: {
            if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                // 多出的两项需要置空
                if ((indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:0] - 1)) {
                    text = nil;
                } else {
                    NSDate *date = [_calendar dateByAddingMonths:indexPath.item-1 toDate:_calendar.minimumDate];
                    text = [_calendar.formatter stringFromDate:date];
                }
            } else {
                NSDate *date = [_calendar dateByAddingMonths:indexPath.item toDate:_calendar.minimumDate];
                text = [_calendar.formatter stringFromDate:date];
            }
            break;
        }
        case DOCalendarScopeWeek: {
            if ((indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:0] - 1)) {
                text = nil;
            } else {
                NSDate *firstPage = [_calendar middleOfWeekFromDate:_calendar.minimumDate];
                NSDate *date = [_calendar dateByAddingWeeks:indexPath.item-1 toDate:firstPage];
                text = [_calendar.formatter stringFromDate:date];
            }
            break;
        }
        default: {
            break;
        }
    }
    text = usesUpperCase ? text.uppercaseString : text;
    cell.titleLabel.text = text;
    [cell setNeedsLayout];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
}

#pragma mark - Properties


- (void)setCalendar:(DOCalendar *)calendar
{
    if (![_calendar isEqual:calendar]) {
        _calendar = calendar;
        _appearance  = calendar.appearance;
    }
}


- (void)setScrollOffset:(CGFloat)scrollOffset
{
    if (_scrollOffset != scrollOffset) {
        _scrollOffset = scrollOffset;
    }
    _needsAdjustingMonthPosition = YES;
    [self setNeedsLayout];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        _collectionViewLayout.scrollDirection = scrollDirection;
        _needsAdjustingMonthPosition = YES;
        _needsAdjustingViewFrame = YES;
        [self setNeedsLayout];
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    if (_scrollEnabled != scrollEnabled) {
        _scrollEnabled = scrollEnabled;
        [_collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

#pragma mark - Public

- (void)reloadData
{
    [_collectionView reloadData];
}

@end


@implementation DOCalendarHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    _titleLabel.frame = bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.contentView.bounds;
    
    if (self.header.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat position = [self.contentView convertPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds)) toView:self.header].x;
        CGFloat center = CGRectGetMidX(self.header.bounds);
        if (self.header.scrollEnabled) {
            self.contentView.alpha = 1.0 - (1.0-self.header.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.fs_width;
        } else {
            self.contentView.alpha = (position > 0 && position < self.header.fs_width*0.75);
        }
    } else if (self.header.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat position = [self.contentView convertPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds)) toView:self.header].y;
        CGFloat center = CGRectGetMidY(self.header.bounds);
        self.contentView.alpha = 1.0 - (1.0-self.header.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.fs_height;
    }
    
}

- (void)invalidateHeaderFont
{
    _titleLabel.font = self.header.appearance.preferredHeaderTitleFont;
}

- (void)invalidateHeaderTextColor
{
    _titleLabel.textColor = self.header.appearance.headerTitleColor;
}

@end


@interface DOCalendarHeaderTouchDeliver()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation DOCalendarHeaderTouchDeliver
{
    UITapGestureRecognizer *_tap;
    NSMutableArray *_years;
    UIPickerView *_pick;
    UIView *_pickView;
}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *hitView = [super hitTest:point withEvent:event];
//    if (hitView == self) {
//        return _calendar.collectionView ?: hitView;
//    }
//    return hitView;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yearPick:)];
        [self addGestureRecognizer:_tap];
        
        _years = [NSMutableArray array];
        for (int i=1970; i<2070; i++) {
            [_years addObject:[@(i) stringValue]];
        }
    }
    return self;
}

- (void)yearPick:(UITapGestureRecognizer *)tap
{
    if (!_pickView) {
        _pickView = [[UIView alloc] initWithFrame:self.calendar.bounds];
        _pickView.backgroundColor = self.calendar.superview.backgroundColor;
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.titleLabel.font = self.calendar.appearance.titleFont;
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton sizeToFit];
        confirmButton.frame = CGRectMake(0, 0, CGRectGetWidth(confirmButton.frame), CGRectGetHeight(confirmButton.frame));
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.titleLabel.font = self.calendar.appearance.titleFont;
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton sizeToFit];
        cancelButton.frame = CGRectMake(CGRectGetWidth(_pickView.frame)-CGRectGetWidth(cancelButton.frame), 0, CGRectGetWidth(cancelButton.frame), CGRectGetHeight(cancelButton.frame));
        
        _pick = [[UIPickerView alloc] initWithFrame:self.calendar.bounds];
        _pick.delegate = self;
        _pick.dataSource = self;
        [_pickView addSubview:confirmButton];
        [_pickView addSubview:cancelButton];
        [_pickView addSubview:_pick];
        [_pickView bringSubviewToFront:confirmButton];
        [_pickView bringSubviewToFront:cancelButton];
    }
    NSString *currentYear = [[self currentDate:[NSDate date]] substringWithRange:NSMakeRange(0, 4)];
    NSUInteger index = [_years indexOfObject:currentYear];
    
    [_pick selectRow:index inComponent:0 animated:NO];
    [self.calendar addSubview:_pickView];
}

- (void)confirm:(id)sender
{
    [_pickView removeFromSuperview];

    NSString *today = [[self currentDate:_calendar.today] substringFromIndex:4];
    NSString *year = _years[[_pick selectedRowInComponent:0]];
    [_calendar selectDate:[self currentDate:[NSString stringWithFormat:@"%@%@",year,today]]];
}

- (void)cancel:(id)sender
{
    [_pickView removeFromSuperview];
}

#pragma mark - pick delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_years count];
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel *l = (UILabel *)view;
    
    if (!l) {
        l = [UILabel new];
    }
    l.font = self.calendar.appearance.titleFont;
    l.text = _years[row];
    [l setTextAlignment:NSTextAlignmentCenter];
    l.adjustsFontSizeToFitWidth = YES;
    
    
    return l;
}
- (id)currentDate:(id)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if ([date isKindOfClass:[NSDate class]]) {
        return [dateFormatter stringFromDate:date];
    }
    return [dateFormatter dateFromString:date];
}

@end