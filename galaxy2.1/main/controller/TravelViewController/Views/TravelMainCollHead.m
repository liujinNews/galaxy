//
//  TravelMainCollHead.m
//  galaxy
//
//  Created by hfk on 2017/5/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "TravelMainCollHead.h"
//@property (strong, nonatomic) UIImageView *titleImgView;
//@property (strong, nonatomic) UIButton *rightBtn;
@implementation TravelMainCollHead
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
    }
    return self;
}
-(void)configHeadViewWithDict:(NSDictionary *)dict WithView:(UIView *)view{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self addSubview:self.mainView];
    
    NSInteger Y=0;
    if (view) {
        [self.mainView addSubview:view];
        Y=Main_Screen_Width*0.4;
    }
    [self.mainView addSubview:[self createLineViewWithFrame:CGRectMake(0, Y, Main_Screen_Width, 10)]];
    
    
    UIImage *image = [UIImage imageNamed:dict[@"titleImage"]];
    _titleImgView=[[UIImageView alloc]initWithFrame:CGRectMake(8, Y+20, image.size.width, image.size.height)];
    _titleImgView.image = [UIImage imageNamed:dict[@"titleImage"]];
    if ([dict[@"titleImage"] isEqualToString:@"Plane"]||[dict[@"titleImage"]isEqualToString:@"Car"]) {
        UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(8 + image.size.width + 5, Y+20, 100, image.size.height)];
        if ([dict[@"titleImage"]isEqualToString:@"Plane"]) {
            titlelab.text = Custing(@"商旅出行", nil);
        }else{
            titlelab.text = Custing(@"用车", nil);
        }
        titlelab.font = Font_Same_12_20;
        [self.mainView addSubview:titlelab];
    }
    [self.mainView addSubview:_titleImgView];
    NSArray *arr=dict[@"Actitle"];
    if (arr.count==1) {
        NSString *title1=arr[0];
        _rightBtn1=[GPUtils createButton:CGRectMake(Main_Screen_Width-105, Y+18, 90, 22) action:@selector(rightClick:) delegate:self title:title1 font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        _rightBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.mainView addSubview:_rightBtn1];
    }else if (arr.count==2){
        NSString *title1=arr[0];
        CGSize size1 = [title1 sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(100, 22) lineBreakMode:NSLineBreakByCharWrapping];

        _rightBtn1=[GPUtils createButton:CGRectMake(Main_Screen_Width-12-size1.width, Y+18, size1.width, 22) action:@selector(rightClick:) delegate:self title:title1 font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        _rightBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.mainView addSubview:_rightBtn1];

        UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width-12-size1.width-12,Y+18+5, 0.8,12)];
        lineUp.backgroundColor=Color_GrayLight_Same_20;
        [self.mainView addSubview:lineUp];

        NSString *title2=arr[1];
        CGSize size2 = [title2 sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(100, 22) lineBreakMode:NSLineBreakByCharWrapping];

        _rightBtn2=[GPUtils createButton:CGRectMake(Main_Screen_Width-12-size1.width-12-12-size2.width, Y+18, size2.width, 22) action:@selector(rightClick:) delegate:self title:title2 font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        _rightBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.mainView addSubview:_rightBtn2];

    }
    
}
-(void)configHeadViewWithDict:(NSDictionary *)dict{
    [self configHeadViewWithDict:dict WithView:nil];
}

-(UIView *)createLineViewWithFrame:(CGRect)rect{
    if (_lineView) {
        [_lineView removeFromSuperview];
    }
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    _lineView.backgroundColor=Color_White_Same_20;

    return _lineView;
}
-(void)rightClick:(UIButton *)btn{
    NSLog(@"%@",btn.titleLabel.text);
    if ([NSString isEqualToNull:btn.titleLabel.text]) {
        self.RightBtnClickedBlock(btn.titleLabel.text);
    }
    
}
@end
