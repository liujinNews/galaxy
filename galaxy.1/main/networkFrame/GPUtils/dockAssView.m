//
//  dockAssView.m
//  galaxy
//
//  Created by 赵碚 on 15/7/27.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "dockAssView.h"

@implementation dockAssView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initContentsName:(NSString *)imgName Text:(NSString *)text Color:(UIColor *)color {
    CGFloat imgviewX = self.frame.size.width*0.5/2;
    CGFloat imgViewW = self.frame.size.width*0.5;
    //self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgviewX, 6, imgViewW, imgViewW)];
    //[self.imgView setImage:[UIImage imageNamed:imgName]];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgViewW + 2, self.frame.size.width, self.frame.size.height - imgViewW)];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, imgViewW*2, imgViewW)];
    self.label.text = text;
    self.label.textColor = color;
    self.label.font = [UIFont systemFontOfSize:16.0f];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.redBallImgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgviewX+imgViewW+2, 6, 6, 6)];
    [self.redBallImgView setImage:[UIImage imageNamed:@"dqzt.png"]];
    self.redBallImgView.hidden = true;
    //[self addSubview:self.imgView];
    [self addSubview:self.label];
    [self addSubview:self.redBallImgView];
}

- (void)setContentsName:(NSString *)imgName Color:(UIColor *)textColor {
    //[self.imgView setImage:[UIImage imageNamed:imgName]];
    self.label.textColor = textColor;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
