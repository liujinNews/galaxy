//
//  ApproveCell.m
//  galaxy
//
//  Created by hfk on 16/4/22.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ApproveCell.h"

@implementation ApproveCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =Color_WhiteWeak_Same_20;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)configViewNotApproveWithModel:(MyApplyModel *)model withStatus:(NSString *)status
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 94)];
    [self.contentView addSubview:self.mainView];
    
    self.selImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,17,17)];
    self.selImage.center=CGPointMake(24, 47);
    if ([status isEqualToString:@"1"]) {
        self.selImage.image=[UIImage imageNamed:@"MyApprove_Select"];
    }else{
        self.selImage.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
    }
    [self.mainView addSubview:self.selImage];
    
    
    self.typeImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 44, 44) imageName:nil];
    self.typeImageView.center=CGPointMake(67, 47);
    [self.mainView addSubview:_typeImageView];
    NSDictionary *imageDict = [VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@|%@",model.flowGuid,model.flowCode]];
    self.typeImageView.image = [UIImage imageNamed:imageDict[@"FlowBaseIcon"]];

    
    NSString *title;
    if (![NSString isEqualToNull:model.taskName]){
        title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.serialNo]];
    }else{
        title=[NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%@",model.serialNo],model.taskName];
    }
    self.titleLabel=[GPUtils createLable:CGRectMake(104, 20, Main_Screen_Width-119, 18) text:title font:Font_Important_15_20 textColor:Color_Black_Important_20  textAlignment:NSTextAlignmentLeft];
    //    self.titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:self.titleLabel];
    
    
    
    if (![NSString isEqualToNull:model.requestorDept]) {
        self.nameLabel=[GPUtils createLable:CGRectMake(104, 43,Main_Screen_Width/3.6, 13) text:[NSString stringWithFormat:@"%@",model.requestor] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.nameLabel];
        
    }else{
        self.nameLabel=[GPUtils createLable:CGRectMake(104,43,Main_Screen_Width/3.6, 13) text:[NSString stringWithFormat:@"%@/%@",model.requestor,model.requestorDept] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.nameLabel];
    }
    //    self.nameLabel.backgroundColor=[UIColor blueColor];
    
    self.dataLabel=[GPUtils createLable:CGRectMake(104, 64, 150, 13) text:model.requestorDate font:Font_Same_11_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.dataLabel];
    
    self.moneyLabel=[GPUtils createLable:CGRectMake(0,0,Main_Screen_Width*0.72-119, 13) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20  textAlignment:NSTextAlignmentRight];
    
    self.moneyLabel.text = [VoiceDataManger getFlowMoneyLabelInfo:model withType:2];

    self.moneyLabel.center = CGPointMake(Main_Screen_Width*0.64+44.5, 47);
    [self.mainView addSubview:self.moneyLabel];
    
}
- (void)configViewNotApproveWithModel:(MyApplyModel *)model
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 94)];
    [self.contentView addSubview:self.mainView];
    
    self.typeImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 44, 44) imageName:nil];
    self.typeImageView.center=CGPointMake(47, 47);
    
    NSDictionary *imageDict = [VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@|%@",model.flowGuid,model.flowCode]];
    self.typeImageView.image=[UIImage imageNamed:imageDict[@"FlowBaseIcon"]];

    [self.mainView addSubview:_typeImageView];
    
    
    NSString *title;
    if (![NSString isEqualToNull:model.taskName]){
        title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.serialNo]];
    }else{
        title=[NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%@",model.serialNo],model.taskName];
    }
    self.titleLabel=[GPUtils createLable:CGRectMake(82, 20, Main_Screen_Width-96, 18) text:title font:Font_Important_15_20 textColor:Color_Black_Important_20  textAlignment:NSTextAlignmentLeft];
    //    self.titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:self.titleLabel];
    
    
    
    if ([model.requestorDept isKindOfClass:[NSNull class]]||[model.requestorDept isEqualToString:@""]||[model.requestorDept isEqualToString:@"<null>"]||[model.requestorDept isEqualToString:@"(null)"]||model.requestorDept==nil) {
        self.nameLabel=[GPUtils createLable:CGRectMake(82, 43,Main_Screen_Width/3.42, 13) text:[NSString stringWithFormat:@"%@",model.requestor] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.nameLabel];
        
    }else{
        self.nameLabel=[GPUtils createLable:CGRectMake(82, 43, Main_Screen_Width/3.42, 13) text:[NSString stringWithFormat:@"%@/%@",model.requestor,model.requestorDept] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.nameLabel];
    }
    
    //    self.nameLabel.backgroundColor=[UIColor blueColor];
    
    self.dataLabel=[GPUtils createLable:CGRectMake(82, 64, 150, 13) text:model.requestorDate font:Font_Same_11_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.dataLabel];
    
    self.moneyLabel=[GPUtils createLable:CGRectMake(0,0,Main_Screen_Width*0.71-97, 13) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20  textAlignment:NSTextAlignmentRight];
    
    self.moneyLabel.text = [VoiceDataManger getFlowMoneyLabelInfo:model withType:2];

    self.moneyLabel.center=CGPointMake(Main_Screen_Width*0.65+33.5, 47);
    [self.mainView addSubview:self.moneyLabel];
    
}

- (void)configViewHasApproveWithModel:(MyApplyModel *)model{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]init];
    [self.contentView addSubview:self.mainView];
    
    if (![model.comment isKindOfClass:[NSNull class]]&&model.comment&&model.comment!=nil&&![model.comment isEqualToString:@"<null>"]&&![model.comment isEqualToString:@"(null)"]&&![model.comment isEqualToString:@""]) {
        
        
        CGSize size = [model.comment sizeCalculateWithFont:Font_Same_11_20 constrainedToSize:CGSizeMake(Main_Screen_Width-130, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        NSInteger height=110+size.height;
        self.mainView.frame=CGRectMake(0, 0, ScreenRect.size.width, height);
        
        self.typeImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 44, 44) imageName:nil];
        self.typeImageView.center=CGPointMake(47, 42);
        
        NSDictionary *imageDict = [VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@|%@",model.flowGuid,model.flowCode]];
        self.typeImageView.image=[UIImage imageNamed:imageDict[@"FlowBaseIcon"]];

        [self.mainView addSubview:_typeImageView];
        
        
        NSString *title;
        if (![NSString isEqualToNull:model.taskName]){
            title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.serialNo]];
        }else{
            title=[NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%@",model.serialNo],model.taskName];
        }
        self.titleLabel=[GPUtils createLable:CGRectMake(82, 20,Main_Screen_Width-230, 18) text:title font:Font_Important_15_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        //            self.titleLabel.backgroundColor=[UIColor redColor];
        [self.mainView addSubview:self.titleLabel];
        
        
        if ([model.requestorDept isKindOfClass:[NSNull class]]||[model.requestorDept isEqualToString:@""]||[model.requestorDept isEqualToString:@"<null>"]||[model.requestorDept isEqualToString:@"(null)"]||model.requestorDept==nil) {
            self.nameLabel=[GPUtils createLable:CGRectMake(82, 45, Main_Screen_Width-222, 13) text:[NSString stringWithFormat:@"%@",model.requestor] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.mainView addSubview:self.nameLabel];
            
        }else{
            self.nameLabel=[GPUtils createLable:CGRectMake(82, 45, Main_Screen_Width-222, 13) text:[NSString stringWithFormat:@"%@/%@",model.requestor,model.requestorDept] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.mainView addSubview:self.nameLabel];
        }
        //        self.nameLabel.backgroundColor=[UIColor blueColor];
        
        
        self.opinionLabel=[GPUtils createLable:CGRectMake(82,Y(_nameLabel)+HEIGHT(_nameLabel)+5, Main_Screen_Width-130, 14) text:model.comment font:Font_Same_11_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentLeft];
        self.opinionLabel.numberOfLines=0;
        CGSize sizeLabel = [model.comment sizeCalculateWithFont:self.opinionLabel.font constrainedToSize:CGSizeMake(self.opinionLabel.frame.size.width, 10000) lineBreakMode:self.opinionLabel.lineBreakMode];
        self.opinionLabel.frame = CGRectMake(82,Y(_nameLabel)+HEIGHT(_nameLabel)+5,Main_Screen_Width-130,sizeLabel.height);
        self.opinionLabel.text=model.comment;
        //        self.opinionLabel.backgroundColor=[UIColor redColor];
        [self.mainView addSubview:self.opinionLabel];
        
        
        
        self.dataLabel=[GPUtils createLable:CGRectMake(X(self.opinionLabel),Y(self.opinionLabel)+HEIGHT(self.opinionLabel)+14, 150, 13) text:model.requestorDate font:Font_Same_11_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        //    self.dataLabel.backgroundColor=[UIColor cyanColor];
        [self.mainView addSubview:self.dataLabel];
        
        
        self.moneyLabel=[GPUtils createLable:CGRectMake(0,0,132, 13) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20   textAlignment:NSTextAlignmentRight];
        self.moneyLabel.text = [VoiceDataManger getFlowMoneyLabelInfo:model withType:2];

        self.moneyLabel.center=CGPointMake(Main_Screen_Width-81, 26);
        [self.mainView addSubview:self.moneyLabel];
        
        self.statusImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:nil];
        self.statusImageView.center=CGPointMake(Main_Screen_Width-25, 50);
        [self.mainView addSubview:self.statusImageView];
        
        self.statusLabel=[GPUtils createLable:CGRectMake(0, 0, 140, 13) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        self.statusLabel.center=CGPointMake(Main_Screen_Width-108, 50);
        //        self.statusLabel.backgroundColor=[UIColor redColor];
        
        [self.mainView addSubview:self.statusLabel];
        
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
        
        self.mainView.frame=CGRectMake(0, 0, ScreenRect.size.width, 94);
        
        self.typeImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 44, 44) imageName:nil];
        self.typeImageView.center=CGPointMake(47, 47);
        
        NSDictionary *imageDict = [VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@|%@",model.flowGuid,model.flowCode]];
        self.typeImageView.image=[UIImage imageNamed:imageDict[@"FlowBaseIcon"]];

        [self.mainView addSubview:_typeImageView];
        
        
        NSString *title;
        if (![NSString isEqualToNull:model.taskName]){
            title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.serialNo]];
        }else{
            title=[NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%@",model.serialNo],model.taskName];
        }
        self.titleLabel=[GPUtils createLable:CGRectMake(82, 20, Main_Screen_Width-230, 18) text:title font:Font_Important_15_20 textColor:Color_Black_Important_20  textAlignment:NSTextAlignmentLeft];
        //        self.titleLabel.backgroundColor=[UIColor cyanColor];
        [self.mainView addSubview:self.titleLabel];
        
        
        
        if ([model.requestorDept isKindOfClass:[NSNull class]]||[model.requestorDept isEqualToString:@""]||[model.requestorDept isEqualToString:@"<null>"]||[model.requestorDept isEqualToString:@"(null)"]||model.requestorDept==nil) {
            self.nameLabel=[GPUtils createLable:CGRectMake(82, 43,Main_Screen_Width-222, 13) text:[NSString stringWithFormat:@"%@",model.requestor] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.mainView addSubview:self.nameLabel];
            
        }else{
            self.nameLabel=[GPUtils createLable:CGRectMake(82, 43, Main_Screen_Width-222, 13) text:[NSString stringWithFormat:@"%@/%@",model.requestor,model.requestorDept] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.mainView addSubview:self.nameLabel];
        }
        //        self.nameLabel.backgroundColor=[UIColor blueColor];
        
        
        self.dataLabel=[GPUtils createLable:CGRectMake(82, 64, 150, 13) text:model.requestorDate font:Font_Same_11_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.dataLabel];
        
        
        self.moneyLabel=[GPUtils createLable:CGRectMake(0,0, 132, 13) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20   textAlignment:NSTextAlignmentRight];
        //            self.moneyLabel.backgroundColor=[UIColor redColor];
        self.moneyLabel.text = [VoiceDataManger getFlowMoneyLabelInfo:model withType:2];

        self.moneyLabel.center=CGPointMake(Main_Screen_Width-81, 26);
        [self.mainView addSubview:self.moneyLabel];
        
        self.statusImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:nil];
        self.statusImageView.center=CGPointMake(Main_Screen_Width-25, 50);
        [self.mainView addSubview:self.statusImageView];
        
        self.statusLabel=[GPUtils createLable:CGRectMake(0, 0,140, 13) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        self.statusLabel.center=CGPointMake(Main_Screen_Width-108,50);
        //        self.statusLabel.backgroundColor=[UIColor redColor];
        [self.mainView addSubview:self.statusLabel];
        
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
                self.statusLabel.text=Custing(@"审批完成",nil);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
