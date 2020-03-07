//
//  ConfigItemProtocol.h
//  MyDemo
//
//  Created by wilderliao on 15/10/27.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ItemType){
    ITEM_TITLE_DESCRIBE = 0,    //含title 和 描述信息
    ITEM_TITLE_SWITCH           //含title 和 switch控件
};

@protocol ConfigItemProtocol;

typedef void (^ConfigCellAction)(id<ConfigItemProtocol> configItem);

@protocol ConfigItemProtocol <NSObject>

- (instancetype)initWithTitle:(NSString *)title itemType:(ItemType)type switchOn:(BOOL)isOn describe:(NSString*)des action:(ConfigCellAction)action;

@optional
- (NSString *)title;
- (UIImage *)icon;
- (BOOL)switchOn;
- (void)ConfigCellAction;
- (NSString *)describe;
- (NSInteger)tag;
- (void)setTag:(NSInteger)tag;

@end
