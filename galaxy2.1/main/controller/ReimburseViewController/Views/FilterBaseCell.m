//
//  FilterBaseCell.m
//  galaxy
//
//  Created by hfk on 16/8/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FilterBaseCell.h"

@implementation FilterBaseCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor=[GPUtils randomColor];
        _titleLabel=[GPUtils createLable:CGRectMake(0, 0,(Main_Screen_Width-54)/3, 30) text:nil font:Font_Same_14_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
        _titleLabel.layer.masksToBounds=YES;
        _titleLabel.layer.cornerRadius=3.0f;
        _titleLabel.layer.borderWidth=1.0;
        //        _titleLabel.layer.borderColor=Color_GrayLight_Same_20.CGColor;
        [self addSubview:_titleLabel];
    }
    return self;
}
-(void)configCollectCellWithData:(NSMutableArray *)array WithType:(NSString *)type WithFirstChoosed:(NSString *)firChoosed WithSecondChoosed:(NSString *)secChoosed WithThirdChoosed:(NSString *)thirChoosed WithIndex:(NSIndexPath *)indexPath{
    _titleLabel.textColor=Color_Black_Important_20;
    _titleLabel.backgroundColor=Color_FilterBackColor_Weak_20;
    _titleLabel.layer.borderColor=Color_FilterBackColor_Weak_20.CGColor;
    _titleLabel.numberOfLines=0;
    _titleLabel.adjustsFontSizeToFitWidth=YES;
    _titleLabel.minimumScaleFactor=0.5;
    _titleLabel.text = nil;
    if (indexPath.section==0) {
        NSString *code=array[0][indexPath.row];
        
        if ([type isEqualToString:@"PayMengtPro"]){
            if ([code isEqualToString:@""]) {
                _titleLabel.text=Custing(@"全部", nil);
                
            }else if ([code isEqualToString:@"4"]){
                _titleLabel.text=Custing(@"处理成功", nil);
                
                
            }else if ([code isEqualToString:@"0,1,2,11,12"]){
                _titleLabel.text=Custing(@"处理中", nil);
                
            }else if ([code isEqualToString:@"3,5,6,7,8,9,10"]){
                _titleLabel.text=Custing(@"处理失败", nil);
                
            }
        }else{
            NSDictionary *dict = [VoiceDataManger getFlowShowInfo:code];
            _titleLabel.text = dict[@"Title"];
        }
        
        if ([code isEqualToString:firChoosed]) {
            _titleLabel.textColor=Color_Blue_Important_20;
            _titleLabel.backgroundColor=Color_form_TextFieldBackgroundColor;
            _titleLabel.layer.borderColor=Color_Blue_Important_20.CGColor;
        }
    }else if (indexPath.section==1){
        NSString *code=array[1][indexPath.row];
        
        if ([code isEqualToString:@""]) {
            _titleLabel.text=Custing(@"全部", nil);
            
        }else if ([code isEqualToString:@"1"]){
            _titleLabel.text=Custing(@"审批中", nil);
            
            
        }else if ([code isEqualToString:@"4"]){
            _titleLabel.text=Custing(@"审批完成", nil);
            
        }else if ([code isEqualToString:@"2"]){
            _titleLabel.text=Custing(@"退回", nil);
            
        }else if ([code isEqualToString:@"7"]){
            _titleLabel.text=Custing(@"作废", nil);
            
        }
        
        if ([code isEqualToString:secChoosed]) {
            _titleLabel.textColor=Color_Blue_Important_20;
            _titleLabel.backgroundColor=Color_form_TextFieldBackgroundColor;
            _titleLabel.layer.borderColor=Color_Blue_Important_20.CGColor;
        }
    }else if (indexPath.section==2){
        NSString *code=array[2][indexPath.row];
        
        if ([code isEqualToString:@"0"]) {
            _titleLabel.text=Custing(@"全部", nil);
            
        }else if ([code isEqualToString:@"1"]){
            _titleLabel.text=Custing(@"未支付", nil);
            
            
        }else if ([code isEqualToString:@"2"]){
            _titleLabel.text=Custing(@"已支付", nil);
            
        }
        if ([code isEqualToString:thirChoosed]) {
            _titleLabel.textColor=Color_Blue_Important_20;
            _titleLabel.backgroundColor=Color_form_TextFieldBackgroundColor;
            _titleLabel.layer.borderColor=Color_Blue_Important_20.CGColor;
        }
    }
}

@end

