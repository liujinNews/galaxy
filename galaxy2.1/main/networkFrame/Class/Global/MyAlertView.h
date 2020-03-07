//
//  MyAlertView.h
//  MyDemo
//
//  Created by wilderliao on 15/10/27.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAlertView;
typedef void (^TouchBlock)(MyAlertView* ,NSInteger);

@interface MyAlertView : UIAlertView

@property(nonatomic,copy)TouchBlock block;

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles block:(TouchBlock)block;
@end
