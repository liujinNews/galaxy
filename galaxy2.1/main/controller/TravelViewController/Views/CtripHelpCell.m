//
//  CtripHelpCell.m
//  galaxy
//
//  Created by hfk on 2017/5/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "CtripHelpCell.h"

@implementation CtripHelpCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}
-(void)configItemWithrRow:(NSInteger)index{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self addSubview:self.mainView];
    
    UIImageView *imageview=[GPUtils createImageViewFrame:CGRectMake(0, 10, Main_Screen_Width, Main_Screen_Width*0.681) imageName:Custing(@"travel_help_head", nil)];
    [self.mainView addSubview:imageview];
    
}

@end
