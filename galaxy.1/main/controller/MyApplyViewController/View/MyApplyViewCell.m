//
//  MyApplyViewCell.m
//  galaxy
//
//  Created by hfk on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MyApplyViewCell.h"

@implementation MyApplyViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_WhiteWeak_Same_20;
    }
    return self;
}
- (void)configViewHasSubmitWithModel:(MyApplyModel*)model{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, [MyApplyViewCell cellHeightWithObj:model])];
    [self.contentView addSubview:self.mainView];
    
//    if ([NSString isEqualToNull:model.comment]) {
    if ([model.status integerValue]==2) {
        
        self.typeImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 44, 44) imageName:nil];
        self.typeImageView.center=CGPointMake(34, 40);
        [self.mainView addSubview:_typeImageView];
        
        
        NSString *title;
        //        if (![NSString isEqualToNull:model.taskName]){
        //            title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.serialNo]];
        //        }else{
        //            title=[NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%@",model.serialNo],model.taskName];
        //        }
        
        if (![NSString isEqualToNull:model.taskName]){
            title=@"";
        }else{
            title=[NSString stringWithFormat:@"%@",model.taskName];
        }
        
        self.titleLabel=[GPUtils createLable:CGRectMake(69, 20, Main_Screen_Width-197, 18) text:title font:Font_Important_15_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        //            self.titleLabel.backgroundColor=[UIColor redColor];
        [self.mainView addSubview:self.titleLabel];
        
        
        self.opinionLabel=[GPUtils createLable:CGRectMake(69,Y(_titleLabel)+HEIGHT(_titleLabel)+10, Main_Screen_Width-130, 14) text:model.comment font:Font_Same_11_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentLeft];
        self.opinionLabel.numberOfLines=0;
        CGSize sizeLabel = [model.comment sizeCalculateWithFont:self.opinionLabel.font constrainedToSize:CGSizeMake(self.opinionLabel.frame.size.width, 10000) lineBreakMode:self.opinionLabel.lineBreakMode];
        self.opinionLabel.frame = CGRectMake(69,Y(_titleLabel)+HEIGHT(_titleLabel)+10,Main_Screen_Width-130,sizeLabel.height);
        self.opinionLabel.text=model.comment;
        //        self.opinionLabel.backgroundColor=[UIColor redColor];
        [self.mainView addSubview:self.opinionLabel];
        
        self.dataLabel=[GPUtils createLable:CGRectMake(X(self.opinionLabel),Y(self.opinionLabel)+HEIGHT(self.opinionLabel)+14, 150, 13) text:model.requestorDate font:Font_Same_11_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        //                    self.dataLabel.backgroundColor=[UIColor cyanColor];
        [self.mainView addSubview:self.dataLabel];
        
        _lineView=[[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-50, ScreenRect.size.width-30, 0.5)];
        _lineView.backgroundColor =Color_GrayLight_Same_20;
        [self.mainView addSubview:_lineView];
        
        self.reSubmitLabel=[GPUtils createLable:CGRectMake(0, 0, 95, 25) text:Custing(@"重新提交", nil) font:Font_Same_12_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
        self.reSubmitLabel.layer.cornerRadius =4.0f;
        self.reSubmitLabel.layer.borderWidth=1;
        self.reSubmitLabel.layer.borderColor = Color_Blue_Important_20.CGColor;
        self.reSubmitLabel.center=CGPointMake(Main_Screen_Width-63, HEIGHT(self.mainView)-25);
        [self.mainView addSubview:self.reSubmitLabel];
        
        self.moneyLabel=[GPUtils createLable:CGRectMake(0,0, 132, 13) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        self.moneyLabel.center=CGPointMake(Main_Screen_Width-81, 26);
        [self.mainView addSubview:self.moneyLabel];
        
        self.statusImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 18, 18) imageName:nil];
        self.statusImageView.center=CGPointMake(Main_Screen_Width-24, 50);
        [self.mainView addSubview:self.statusImageView];
        
        self.statusLabel=[GPUtils createLable:CGRectMake(0, 0, 150, 13) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        self.statusLabel.center=CGPointMake(Main_Screen_Width-115, 50);
        [self.mainView addSubview:self.statusLabel];

        self.moneyLabel.text=[VoiceDataManger getFlowMoneyLabelInfo:model withType:1];

        
        NSDictionary *imageDict = [VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@|%@",model.flowGuid,model.flowCode]];
        self.typeImageView.image=[UIImage imageNamed:imageDict[@"FlowBaseIcon"]];

        
        if ([model.paymentStatus integerValue]==0) {
            if ([model.status integerValue]==0) {
                self.statusImageView.image=[UIImage imageNamed:@"share_NoSubmit"];
                self.statusLabel.text=Custing(@"未提交", nil);
            }else if ([model.status integerValue]==1){
                self.statusImageView.image=[UIImage imageNamed:@"share_Approving"];
                self.statusLabel.text=Custing(@"审批中", nil);
            }else if ([model.status integerValue]==2){
                self.statusImageView.image=[UIImage imageNamed:@"share_ReBack"];
                self.statusLabel.text=Custing(@"退回", nil);
            }else if ([model.status integerValue]==3){
                self.statusImageView.image=[UIImage imageNamed:@"share_Refuse"];
                self.statusLabel.text=Custing(@"拒绝", nil);
            }else if ([model.status integerValue]==4){
                self.statusImageView.image=[UIImage imageNamed:@"share_submit"];
                self.statusLabel.text=Custing(@"审批完成", nil);
            }else if ([model.status integerValue]==6){
                self.statusImageView.image=[UIImage imageNamed:@"share_ReCall"];
                self.statusLabel.text=Custing(@"已撤回", nil);
            }else if ([model.status integerValue]==7){
                self.statusImageView.image=[UIImage imageNamed:@"share_Refuse"];
                self.statusLabel.text=Custing(@"已作废", nil);
            }
        }else if ([model.paymentStatus integerValue]==1){
            self.statusImageView.image=[UIImage imageNamed:@"share_submit"];
            self.statusLabel.text=Custing(@"审批完成(未支付)", nil);
        }else if ([model.paymentStatus integerValue]==2){
            self.statusImageView.image=[UIImage imageNamed:@"share_submit"];
            self.statusLabel.text=Custing(@"审批完成(已支付)", nil);
        }
    }else{
        self.typeImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 44, 44) imageName:nil];
        self.typeImageView.center=CGPointMake(34, 38);
        [self.mainView addSubview:_typeImageView];
        
        NSString *title;
        //        if (![NSString isEqualToNull:model.taskName]){
        //            title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.serialNo]];
        //        }else{
        //            title=[NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%@",model.serialNo],model.taskName];
        //        }
        if (![NSString isEqualToNull:model.taskName]){
            title=@"";
        }else{
            title=[NSString stringWithFormat:@"%@",model.taskName];
        }
        
        self.titleLabel=[GPUtils createLable:CGRectMake(69, 20,Main_Screen_Width-197, 18) text:title font:Font_Important_15_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        //            self.titleLabel.backgroundColor=[UIColor cyanColor];
        [self.mainView addSubview:self.titleLabel];
        
        
        self.dataLabel=[GPUtils createLable:CGRectMake(X(_titleLabel),Y(_titleLabel)+HEIGHT(_titleLabel)+7, 150, 13) text:model.requestorDate font:Font_Same_11_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        //            self.dataLabel.backgroundColor=[UIColor cyanColor];
        [self.mainView addSubview:self.dataLabel];
        
        if ([[NSString stringWithFormat:@"%@",model.viewOrder]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",model.status]isEqualToString:@"4"]) {
            _lineView=[[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-50, ScreenRect.size.width-30, 0.5)];
            _lineView.backgroundColor =Color_GrayLight_Same_20;
            [self.mainView addSubview:_lineView];
            
            self.DetaileBtn=[GPUtils createButton:CGRectMake(0, 0, 95, 25) action:nil delegate:nil title:Custing(@"查看订单", nil) font:Font_Same_12_20 titleColor:Color_Blue_Important_20];
            self.DetaileBtn.layer.cornerRadius =4.0f;
            self.DetaileBtn.layer.borderWidth=1;
            self.DetaileBtn.layer.borderColor = Color_Blue_Important_20.CGColor;
            self.DetaileBtn.center=CGPointMake(Main_Screen_Width-63, HEIGHT(self.mainView)-25);
            [self.mainView addSubview:self.DetaileBtn];
        }
        
        self.moneyLabel=[GPUtils createLable:CGRectMake(0,0,132, 13) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        //        self.moneyLabel.backgroundColor=[UIColor cyanColor];
        self.moneyLabel.center=CGPointMake(Main_Screen_Width-81, 26);
        [self.mainView addSubview:self.moneyLabel];
        
        self.statusImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 18, 18) imageName:nil];
        self.statusImageView.center=CGPointMake(Main_Screen_Width-24, 50);
        [self.mainView addSubview:self.statusImageView];
        
        self.statusLabel=[GPUtils createLable:CGRectMake(0, 0, 150, 13) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        self.statusLabel.center=CGPointMake(Main_Screen_Width-115, 50);
        [self.mainView addSubview:self.statusLabel];
        
        self.moneyLabel.text=[VoiceDataManger getFlowMoneyLabelInfo:model withType:1];
        
        NSDictionary *imageDict = [VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@|%@",model.flowGuid,model.flowCode]];
        self.typeImageView.image=[UIImage imageNamed:imageDict[@"FlowBaseIcon"]];

        if ([model.paymentStatus integerValue]==0) {
            if ([model.status integerValue]==0) {
                self.statusImageView.image=[UIImage imageNamed:@"share_NoSubmit"];
                self.statusLabel.text=Custing(@"未提交", nil);
            }else if ([model.status integerValue]==1){
                self.statusImageView.image=[UIImage imageNamed:@"share_Approving"];
                self.statusLabel.text=Custing(@"审批中", nil);
            }else if ([model.status integerValue]==2){
                self.statusImageView.image=[UIImage imageNamed:@"share_ReBack"];
                self.statusLabel.text=Custing(@"退回", nil);
            }else if ([model.status integerValue]==3){
                self.statusImageView.image=[UIImage imageNamed:@"share_Refuse"];
                self.statusLabel.text=Custing(@"拒绝", nil);
            }else if ([model.status integerValue]==4){
                self.statusImageView.image=[UIImage imageNamed:@"share_submit"];
                self.statusLabel.text=Custing(@"审批完成", nil);
            }else if ([model.status integerValue]==6){
                self.statusImageView.image=[UIImage imageNamed:@"share_ReCall"];
                self.statusLabel.text=Custing(@"已撤回", nil);
            }else if ([model.status integerValue]==7){
                self.statusImageView.image=[UIImage imageNamed:@"share_Refuse"];
                self.statusLabel.text=Custing(@"已作废", nil);
            }
        }else if ([model.paymentStatus integerValue]==1){
            self.statusImageView.image=[UIImage imageNamed:@"share_submit"];
            self.statusLabel.text=Custing(@"审批完成(未支付)", nil);
        }else if ([model.paymentStatus integerValue]==2){
            self.statusImageView.image=[UIImage imageNamed:@"share_submit"];
            self.statusLabel.text=Custing(@"审批完成(已支付)", nil);
        }
    }
}

- (void)configViewNotSubmitWithModel:(MyApplyModel*)model{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, [MyApplyViewCell cellHeightWithObj:model])];

    [self.contentView addSubview:self.mainView];
    
    self.typeImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 44, 44) imageName:nil];
    self.typeImageView.center=CGPointMake(34, 38);
    [self.mainView addSubview:_typeImageView];
    
    
    NSString *title;
    //    if ([model.taskName isKindOfClass:[NSNull class]]||[model.taskName isEqualToString:@""]||[model.taskName isEqualToString:@"<null>"]||[model.taskName isEqualToString:@"(null)"]||model.taskName==nil){
    //        title=@"";
    //    }else{
    //        title=[NSString stringWithFormat:@"%@",model.taskName];
    //    }
    
    if (![NSString isEqualToNull:model.taskName]){
        title=@"";
    }else{
        title=[NSString stringWithFormat:@"%@",model.taskName];
    }
    
    self.titleLabel=[GPUtils createLable:CGRectMake(69, 20, Main_Screen_Width-213, 18) text:title font:Font_Important_15_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    //        self.titleLabel.backgroundColor=[UIColor redColor];
    [self.mainView addSubview:self.titleLabel];
    
    self.moneyLabel=[GPUtils createLable:CGRectMake(0,0, 132, 13) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    self.moneyLabel.center=CGPointMake(Main_Screen_Width-81, 26);
    //     self.moneyLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:self.moneyLabel];
    
    
    self.dataLabel=[GPUtils createLable:CGRectMake(X(_titleLabel),Y(_titleLabel)+HEIGHT(_titleLabel)+7, 150, 13) text:model.requestorDate font:Font_Same_11_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    //    self.dataLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:self.dataLabel];
    
    self.moneyLabel.text=[VoiceDataManger getFlowMoneyLabelInfo:model withType:1];

    NSDictionary *imageDict = [VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@|%@",model.flowGuid,model.flowCode]];
    self.typeImageView.image=[UIImage imageNamed:imageDict[@"FlowBaseIcon"]];

}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight =0;
    MyApplyModel *model=(MyApplyModel *)obj;
    if ([model.status integerValue]==2) {
        CGSize size = [model.comment sizeCalculateWithFont:Font_Same_11_20 constrainedToSize:CGSizeMake(Main_Screen_Width-130, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        cellHeight= 135+size.height;
    }else{
        if ([[NSString stringWithFormat:@"%@",model.viewOrder]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",model.status]isEqualToString:@"4"]) {
            cellHeight= 120;
        }else{
            cellHeight= 75;
        }
    }
    return cellHeight;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
