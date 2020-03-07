//
//  addTravelAndDayCollectionCell.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/2.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "addTravelAndDayCollectionCell.h"

@implementation addTravelAndDayCollectionCell
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.mainView removeFromSuperview];
        self.mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, floor((Main_Screen_Width-150)/2), 33)];
        self.mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.mainView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.mainView];
        
        self.triangleView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.mainView)-14.5, 18.5, 14.5, 14.5)];
        self.triangleView.image = GPImage(@"costClassDeleteTriangle");
        self.triangleView.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:self.triangleView];
        
        
        
        
        self.expenseLa = [GPUtils createLable:CGRectMake(0, 0, WIDTH(self.mainView), HEIGHT(self.mainView)) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
        self.expenseLa.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:self.expenseLa];
        
    }
    return self;
}

@end
