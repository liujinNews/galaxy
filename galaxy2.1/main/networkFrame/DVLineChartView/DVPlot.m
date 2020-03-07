//
//  DVPlot.m
//  DVLineChart
//
//  Created by Fire on 15/10/17.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import "DVPlot.h"

@implementation DVPlot

- (instancetype)init {
    
    if (self = [super init]) {
        self.lineColor = Color_Unsel_TitleColor;
        self.pointColor = Color_Unsel_TitleColor;
        self.pointSelectedColor = [UIColor orangeColor];
        self.chartViewFill=YES;
        self.withPoint=YES;
    }
    return self;
}

@end
