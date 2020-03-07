//
//  UIBarButtonItem+Common.h
//  Coding_iOS
//
//  Created by hfk on 14/11/5.
//  Copyright (c) 2017年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)

+(UIBarButtonItem *)RootCustomNavButtonWithWithButton:(UIButton *)itemButtom title:(NSString *)title titleColor:(UIColor *)color titleIndex:(NSInteger)index imageName:(NSString *)imageName target:(id)targe action:(SEL)action;

@end

