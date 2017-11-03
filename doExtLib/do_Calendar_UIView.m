//
//  do_Calendar_View.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Calendar_UIView.h"

#import "doInvokeResult.h"
#import "doUIModuleHelper.h"
#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "DOCalendar.h"
#import "doJsonHelper.h"

@interface do_Calendar_UIView()<DOCalendarDataSource, DOCalendarDelegate>

@end

@implementation do_Calendar_UIView
{
    DOCalendar *_calendar;
}
#pragma mark - doIUIModuleView协议方法（必须）
//引用Model对象
- (void) LoadView: (doUIModule *) _doUIModule
{
    _model = (typeof(_model)) _doUIModule;
    
    
}
//销毁所有的全局对象
- (void) OnDispose
{
    //自定义的全局属性,view-model(UIModel)类销毁时会递归调用<子view-model(UIModel)>的该方法，将上层的引用切断。所以如果self类有非原生扩展，需主动调用view-model(UIModel)的该方法。(App || Page)-->强引用-->view-model(UIModel)-->强引用-->view
    [_calendar removeFromSuperview];
    _calendar = nil;
}
//实现布局
- (void) OnRedraw
{
    //实现布局相关的修改,如果添加了非原生的view需要主动调用该view的OnRedraw，递归完成布局。view(OnRedraw)<显示布局>-->调用-->view-model(UIModel)<OnRedraw>
    
    //重新调整视图的x,y,w,h
    [doUIModuleHelper OnRedraw:_model];
    
    [self createCalendar];
}

- (void)createCalendar
{
    [_calendar removeFromSuperview];
    _calendar = [[DOCalendar alloc] initWithFrame:self.bounds];
    _calendar.dataSource = self;
    _calendar.delegate = self;
    _calendar.backgroundColor = [UIColor clearColor];
    _calendar.scrollDirection = DOCalendarScrollDirectionHorizontal;

    [self addSubview:_calendar];
}

#pragma mark - TYPEID_IView协议方法（必须）
#pragma mark - Changed_属性
/*
 如果在Model及父类中注册过 "属性"，可用这种方法获取
 NSString *属性名 = [(doUIModule *)_model GetPropertyValue:@"属性名"];
 
 获取属性最初的默认值
 NSString *属性名 = [(doUIModule *)_model GetProperty:@"属性名"].DefaultValue;
 */

#pragma mark -
#pragma mark - 同步异步方法的实现
//同步
- (void)getSelectedDate:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //参数字典_dictParas
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    //_invokeResult设置返回值
    NSDate *today = _calendar.today;
    NSDictionary *dict = [self selectedDate:today];
    
    [_invokeResult SetResultNode:dict];
}
- (void)jump:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //参数字典_dictParas
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    //_invokeResult设置返回值
    NSString *data = [doJsonHelper GetOneText:_dictParas :@"data" :@""];
    if (data.length>0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [_calendar selectDate:[dateFormatter dateFromString:data]];
    }
}
- (void)calendar:(DOCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSDate *today = _calendar.today;
    NSDictionary *dict = [self selectedDate:today];
    
    doInvokeResult* invokeResult = [[doInvokeResult alloc]init:_model.UniqueKey];
    [invokeResult SetResultNode:dict];
    
    [_model.EventCenter FireEvent:@"selectedDate":invokeResult];
}

- (NSDictionary *)selectedDate:(NSDate *)date
{
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    comps = [calendar components:unitFlags fromDate:date];
    
    NSString *year = [@([comps year]) stringValue];
    NSString *month = [@([comps month]) stringValue];
    NSString *day = [@([comps day]) stringValue];
    NSString *weekday = [@([comps weekday]) stringValue];
    
    NSDictionary *dict = @{@"year":year,@"month":month,@"day":day,@"weekday":weekday};
    
    return dict;
}
#pragma mark - doIUIModuleView协议方法（必须）<大部分情况不需修改>
- (BOOL) OnPropertiesChanging: (NSMutableDictionary *) _changedValues
{
    //属性改变时,返回NO，将不会执行Changed方法
    return YES;
}
- (void) OnPropertiesChanged: (NSMutableDictionary*) _changedValues
{
    //_model的属性进行修改，同时调用self的对应的属性方法，修改视图
    [doUIModuleHelper HandleViewProperChanged: self :_model : _changedValues ];
}
- (BOOL) InvokeSyncMethod: (NSString *) _methodName : (NSDictionary *)_dicParas :(id<doIScriptEngine>)_scriptEngine : (doInvokeResult *) _invokeResult
{
    //同步消息
    return [doScriptEngineHelper InvokeSyncSelector:self : _methodName :_dicParas :_scriptEngine :_invokeResult];
}
- (BOOL) InvokeAsyncMethod: (NSString *) _methodName : (NSDictionary *) _dicParas :(id<doIScriptEngine>) _scriptEngine : (NSString *) _callbackFuncName
{
    //异步消息
    return [doScriptEngineHelper InvokeASyncSelector:self : _methodName :_dicParas :_scriptEngine: _callbackFuncName];
}
- (doUIModule *) GetModel
{
    //获取model对象
    return _model;
}

@end
