//
//  PopMenuItem.m
//  galaxy
//
//  Created by hfk on 2016/12/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PopMenuItem.h"

@implementation PopMenuItem
- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName {
    return [self initWithTitle:title iconName:iconName glowColor:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                    glowColor:(UIColor *)glowColor {
    return [self initWithTitle:title iconName:iconName glowColor:glowColor index:-1];
}

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                        index:(NSInteger)index {
    return [self initWithTitle:title iconName:iconName glowColor:nil index:index];
}

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                    glowColor:(UIColor *)glowColor
                        index:(NSInteger)index {
    if (self = [super init]) {
        self.title = title;
        self.iconImage = [UIImage imageNamed:iconName];
        self.glowColor = glowColor;
        self.index = index;
    }
    return self;
}


+ (instancetype)itemWithTitle:(NSString *)title
                     iconName:(NSString *)iconName {
    return [self itemWithTitle:title iconName:iconName glowColor:nil index:-1];
}

+ (instancetype)itemWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                    glowColor:(UIColor *)glowColor {
    return [self itemWithTitle:title iconName:iconName glowColor:glowColor index:-1];
}

+ (instancetype)itemWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                        index:(NSInteger)index {
    return [self itemWithTitle:title iconName:iconName glowColor:nil index:index];
}

+ (instancetype)itemWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                    glowColor:(UIColor *)glowColor
                        index:(NSInteger)index {
    PopMenuItem *item = [[self alloc ] initWithTitle:title iconName:iconName glowColor:glowColor index:index];
    return item;
}
@end
