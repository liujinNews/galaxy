//
//  UIBarButtonItem+Common.m
//  Coding_iOS
//
//  Created by hfk on 14/11/5.
//  Copyright (c) 2017年 Coding. All rights reserved.
//

#import "UIBarButtonItem+Common.h"

@implementation UIBarButtonItem (Common)

+(UIBarButtonItem *)RootCustomNavButtonWithWithButton:(UIButton *)itemButtom title:(NSString *)title titleColor:(UIColor *)color titleIndex:(NSInteger)index imageName:(NSString *)imageName target:(id)targe action:(SEL)action{
    
    if (itemButtom==nil) {
        itemButtom = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [itemButtom setImage:image forState:UIControlStateNormal];
    itemButtom.titleLabel.font = Font_Same_14_20;
    [itemButtom setTitle:title forState:UIControlStateNormal];
    [itemButtom setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    
    if (color == nil&& title!=nil) {
        color = Color_Unsel_TitleColor;
    }
    
    [itemButtom setTitleColor:color forState:UIControlStateNormal];
    itemButtom.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [itemButtom addTarget:targe action:action
         forControlEvents:UIControlEventTouchUpInside];
    if (title == nil && imageName != nil) {
        [itemButtom setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    }else if (title != nil && imageName == nil){
        CGSize size=[title sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(10000, 44) lineBreakMode:NSLineBreakByTruncatingTail];
        if (index>0) {
            [itemButtom setFrame:CGRectMake(0, 0, size.width+14, 44)];
        }else{
            [itemButtom setFrame:CGRectMake(0, 0, size.width+5, 44)];
        }
    } 
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithCustomView:itemButtom];
    return barButtonItem;
}

@end
