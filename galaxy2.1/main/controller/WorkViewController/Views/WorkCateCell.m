//
//  WorkCateCell.m
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "WorkCateCell.h"

@implementation WorkCateCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpContentView];
    }
    return self;
}
-(void)setUpContentView{
    UIView *superView = self.contentView;
    
    if (!self.iconImgView) {
        self.iconImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [superView addSubview:self.iconImgView];
    }
    
    if (!self.titleLabel) {
        self.titleLabel=[GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
        self.titleLabel.numberOfLines = 0;
        [superView addSubview:self.titleLabel];
    }
    
    if (!self.NewImageView) {
        self.NewImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [superView addSubview:self.NewImageView];
    }else{
        self.NewImageView.frame=CGRectZero;
    }
    
    if (!self.TipsLabel) {
        self.TipsLabel=[GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
        _TipsLabel.backgroundColor=Color_Red_Message_20;
        _TipsLabel.layer.borderColor = [UIColor redColor].CGColor;
        _TipsLabel.layer.borderWidth = 1.0f;
        _TipsLabel.layer.masksToBounds = YES;
        [superView addSubview:self.TipsLabel];
    }else{
        self.TipsLabel.frame=CGRectZero;
    }
    
    if (!self.rightLine) {
        self.rightLine=[[UIView alloc]initWithFrame:CGRectZero];
        self.rightLine.backgroundColor=Color_GrayLight_Same_20;
        [superView addSubview:self.rightLine];
    }else{
        self.rightLine.frame=CGRectZero;
    }
    
    if (!self.downLine) {
        self.downLine=[[UIView alloc]initWithFrame:CGRectZero];
        self.downLine.backgroundColor=Color_GrayLight_Same_20;
        [superView addSubview:self.downLine];
    }else{
        self.downLine.frame=CGRectZero;
    }
}

-(void)configCcellWithArrat:(NSMutableArray *)arr WithindexPath:(NSIndexPath *)indexPath{
    
    WorkShowModel *model=arr[indexPath.section][indexPath.row];
    userData *userdatas=[userData shareUserData];

    [self setUpContentView];
    
    self.iconImgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",model.appIcon]];
    self.titleLabel.text=[NSString isEqualToNull:model.appName]?model.appName:@"";
    self.titleLabel.textColor = Color_Black_Important_20;
    if (model.appType==1) {
        self.backgroundColor=Color_ClearBlue_Same_20;
        
        self.iconImgView.frame=CGRectMake(0, 0, 32, 32);
        self.iconImgView.center=CGPointMake(Main_Screen_Width/4,Main_Screen_Width*0.36/2-16);
        self.titleLabel.frame=CGRectMake(0, 0,Main_Screen_Width/2-40, 16);
        self.titleLabel.center=CGPointMake(Main_Screen_Width/4, Main_Screen_Width*0.36/2+23);
        
        if (indexPath.row==0) {
            self.rightLine.frame=CGRectMake(0, 0,0.5,72);
            self.rightLine.center=CGPointMake(WIDTH(self)-0.25,HEIGHT(self)/2);
            
            NSString *num=[NSString stringWithFormat:@"%@",[userData shareUserData].work_waitNum];
            if ([NSString isEqualToNullAndZero:num]) {
                if ([num floatValue]>99) {
                    self.TipsLabel.frame=CGRectMake(0, 0, 36, 22);
                    self.TipsLabel.font=Font_Same_14_20;
                    self.TipsLabel.center=CGPointMake(ceilf(Main_Screen_Width/4+16+36/2),ceilf(Main_Screen_Width*0.36/2-16-22/2-5));
                    self.TipsLabel.text=@"99+";
                    self.TipsLabel.layer.cornerRadius = 10;
                }else{
                    CGSize size=[num sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(10000, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
                    self.TipsLabel.font=Font_Same_14_20;
                    NSInteger len=ceilf((size.width>size.height?size.width+6:size.height+6)/2)*2  ;
                    self.TipsLabel.frame= CGRectMake(0, 0, len, len);
                    self.TipsLabel.center=CGPointMake(ceilf(Main_Screen_Width/4+16+len/2),ceilf(Main_Screen_Width*0.36/2-16-len/2-5));
                    self.TipsLabel.text=num;
                    self.TipsLabel.layer.cornerRadius = len/2;
                }
            }
            if (userdatas.SystemType==1 && userdatas.bool_AgentHasApprove == NO) {
                self.titleLabel.textColor = [GPUtils colorHString:@"#b2b2b2"];
                _TipsLabel.backgroundColor = [GPUtils colorHString:@"#b2b2b2"];
                _TipsLabel.layer.borderColor = [GPUtils colorHString:@"#b2b2b2"].CGColor;
            }
        }
    }else if (model.appType==2){
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        self.iconImgView.frame=CGRectMake(0, 0, 40, 40);
        self.iconImgView.center=CGPointMake(Main_Screen_Width/6,Main_Screen_Width*0.28/2-12);
        self.titleLabel.frame=CGRectMake(0, 0,Main_Screen_Width/4, 35);
        self.titleLabel.center=CGPointMake(Main_Screen_Width/6, Main_Screen_Width*0.28/2+26);
        
        if ([model.appIsNew floatValue]==1) {
            _NewImageView.frame= CGRectMake(Main_Screen_Width/3-30, 0, 30, 30);
            _NewImageView.image=[UIImage imageNamed:@"Work_New"];
        }
        
        if ((indexPath.row+1)%3!=0) {
            self.rightLine.frame=CGRectMake(WIDTH(self)-0.5, 0, 0.5, HEIGHT(self));
        }
        
        NSInteger section=indexPath.section;
        NSInteger count=((NSMutableArray *)arr[section]).count;
        if (count>=4&&indexPath.row<=count-4) {
            self.downLine.frame=CGRectMake(0, HEIGHT(self)-0.5, WIDTH(self), 0.5);
        }
        
    }else if (model.appType==3||model.appType==4){
        
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        self.iconImgView.frame=CGRectMake(0, 0, 40, 40);
        self.iconImgView.center=CGPointMake(Main_Screen_Width/6,Main_Screen_Width*0.28/2-12);
        self.titleLabel.frame=CGRectMake(0, 0,Main_Screen_Width/4, 35);
        self.titleLabel.center=CGPointMake(Main_Screen_Width/6, Main_Screen_Width*0.28/2+26);
        
        if (model.appType==4) {
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.appIcon]];
        }
        if ((indexPath.row+1)%3!=0) {
            self.rightLine.frame=CGRectMake(WIDTH(self)-0.5, 0, 0.5, HEIGHT(self));
        }
        self.downLine.frame=CGRectMake(0, HEIGHT(self)-0.5, WIDTH(self), 0.5);
    }
}

+(CGSize)ccellSizeWithObj:(WorkShowModel *)model{
    CGSize itemSize;
    if (model.appType==1) {
        itemSize=CGSizeMake(Main_Screen_Width/2, Main_Screen_Width*0.36);
    }else{
        itemSize=CGSizeMake(Main_Screen_Width/3, Main_Screen_Width*0.28);
    }
    return itemSize;
}

@end

