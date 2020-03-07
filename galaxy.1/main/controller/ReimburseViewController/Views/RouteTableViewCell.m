//
//  RouteTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/8/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RouteTableViewCell.h"

#define RouteCellHeight 160

#define RouteCellHeightByDidi 198

@implementation RouteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(RouteTableViewCell *)initViewWithModel:(RouteModel *)model isEdit:(BOOL)isEdit{
    RouteTableViewCell *cell = [[RouteTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, RouteCellHeight)];
    self.model = model;
    self.isDidi = NO;
    UIImageView *btn_isEdit = [[UIImageView alloc]init];
    [btn_isEdit setImage:[UIImage imageNamed:@"MyApprove_UnSelect"]];
    [btn_isEdit setHighlightedImage:[UIImage imageNamed:@"MyApprove_Select"]];
    
    [cell addSubview:btn_isEdit];
    [btn_isEdit mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isEdit) {
            make.left.equalTo(@12);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }else{
            make.left.equalTo(@0);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }
        make.top.equalTo(@(RouteCellHeight/2-10));
    }];
   
    //出发时间
    UIImageView *img_deparT = [[UIImageView alloc]init];
    [img_deparT setImage:[UIImage imageNamed:@"Route_Time"]];
    [cell addSubview:img_deparT];
    [img_deparT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(cell.top).offset(@15);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    
    UILabel *lab_deparT = [GPUtils createLable:CGRectZero text:model.departureTimeStr font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_deparT];
    [lab_deparT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_deparT.right).offset(@12);
        make.top.equalTo(img_deparT.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_deparT.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    UIImage *image = [UIImage imageNamed:@"ApproveRemind_Right"];
    UIButton *btn_status = [GPUtils createButton:CGRectMake(0, 0, 60, 20) action:nil delegate:self title:[model.status integerValue]==1?Custing(@"已完成", nil):Custing(@"未完成", nil) font:Font_Important_15_20 titleColor:Color_LabelPlaceHolder_Same_20];
    CGSize size = [NSString sizeWithText:btn_status.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [btn_status setImage:image forState:UIControlStateNormal];
    btn_status.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cell addSubview:btn_status];
    [btn_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab_deparT.top);
        make.right.equalTo(cell.right).offset(-15);
        make.height.equalTo(@20);
    }];
    [btn_status setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
    [btn_status setImageEdgeInsets:UIEdgeInsetsMake(0, size.width, 0, -size.width)];
    
    //到达时间
    UIImageView *img_arrT = [[UIImageView alloc]init];
    [img_arrT setImage:[UIImage imageNamed:@"Route_Time"]];
    [cell addSubview:img_arrT];
    [img_arrT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(lab_deparT.bottom).offset(@12);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    
    UILabel *lab_arrT = [GPUtils createLable:CGRectZero text:model.arrivalTimeStr font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_arrT];
    [lab_arrT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_arrT.right).offset(@12);
        make.top.equalTo(img_arrT.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_arrT.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    //出发地点
    UIImageView *img_deparN = [[UIImageView alloc]init];
    [img_deparN setImage:[UIImage imageNamed:@"Self_Drive_Green"]];
    [cell addSubview:img_deparN];
    [img_deparN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(lab_arrT.bottom).offset(@12);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    
    UILabel *lab_deparN = [GPUtils createLable:CGRectZero text:model.departureName font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_deparN];
    [lab_deparN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_deparN.right).offset(@12);
        make.top.equalTo(img_deparN.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_deparN.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    //到达地点
    UIImageView *img_arrN = [[UIImageView alloc]init];
    [img_arrN setImage:[UIImage imageNamed:@"Self_Drive_Red"]];
    [cell addSubview:img_arrN];
    [img_arrN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(lab_deparN.bottom).offset(@12);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    
    UILabel *lab_arrN = [GPUtils createLable:CGRectZero text:model.arrivalName font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_arrN];
    [lab_arrN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_arrN.right).offset(@12);
        make.top.equalTo(img_arrN.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_arrN.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    //公里
    UIImageView *img_milN = [[UIImageView alloc]init];
    [img_milN setImage:[UIImage imageNamed:@"Route_Mileage"]];
    [cell addSubview:img_milN];
    [img_milN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(lab_arrN.bottom).offset(@12);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    
    UILabel *lab_milN = [GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@ KM",model.mileage] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_milN];
    [lab_milN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_milN.right).offset(@12);
        make.top.equalTo(img_milN.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_milN.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    if ([model.status integerValue]==1) {
        UIButton *btn_lead = [GPUtils createButton:CGRectZero action:@selector(btn_click) delegate:cell title:Custing(@"导入", nil) font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
        if ([model.imported integerValue]==1) {
            [btn_lead setTitle:Custing(@"已导入", nil) forState:UIControlStateNormal];
            [btn_lead setTitleColor:Color_GrayDark_Same_20 forState:UIControlStateNormal];
            btn_lead.userInteractionEnabled = NO;
        }
        [cell addSubview:btn_lead];
        [btn_lead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.right).offset(@-15);
            make.height.equalTo(@20);
            make.top.equalTo(lab_milN.top);
        }];
    }
    
    
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 150, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    [cell addSubview:view];
    
    return cell;
}

-(RouteTableViewCell *)initViewWithModel_Bydidi:(RouteDidiModel *)model isEdit:(BOOL)isEdit isChoosed:(NSString *)choosed{
    
    RouteTableViewCell *cell = [[RouteTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, RouteCellHeightByDidi)];
    self.model_didi = model;
    self.isDidi = YES;
    UIImageView *btn_isEdit = [[UIImageView alloc]init];
    [btn_isEdit setImage:[choosed isEqualToString:@"1"] ?[UIImage imageNamed:@"MyApprove_Select"]:[UIImage imageNamed:@"MyApprove_UnSelect"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell addSubview:btn_isEdit];
    [btn_isEdit mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isEdit) {
            make.left.equalTo(@12);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }else{
            make.left.equalTo(@0);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }
        make.top.equalTo(@(RouteCellHeight/2-10));
    }];
    
    //用车状态
    UILabel *lab_carType = [GPUtils createLable:CGRectZero text:[model.use_car_type integerValue]==1?Custing(@"出租车", nil):[model.use_car_type integerValue]==2?Custing(@"专车", nil):[model.use_car_type integerValue]==3?Custing(@"快车", nil):Custing(@"代驾", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_carType];
    [lab_carType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.left).offset(@12);
        make.top.equalTo(cell.top);
        make.width.equalTo(@(Main_Screen_Width/2));
        make.height.equalTo(@38);
    }];
    
    UIButton *btn_status = [GPUtils createButton:CGRectMake(0, 0, 60, 38) action:nil delegate:self title:[model.status integerValue]==2?Custing(@"已支付", nil):[model.status integerValue]==3?Custing(@"已退款", nil):[model.status integerValue]==4?Custing(@"已取消", nil):Custing(@"部分退款", nil) font:Font_Important_15_20 titleColor:Color_LabelPlaceHolder_Same_20];
    btn_status.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cell addSubview:btn_status];
    [btn_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.top);
        make.right.equalTo(cell.right).offset(-15);
        make.height.equalTo(@38);
    }];
    
    UIView *view_line = [[UIView alloc]initWithFrame:CGRectMake(12, 38, Main_Screen_Width-12, 0.5)];
    view_line.backgroundColor = Color_LineGray_Same_20;
    [cell addSubview:view_line];
    
    //出发时间
    UIImageView *img_deparT = [[UIImageView alloc]init];
    [img_deparT setImage:[UIImage imageNamed:@"Route_Time"]];
    [cell addSubview:img_deparT];
    [img_deparT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(lab_carType.bottom).offset(@18);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    
    UILabel *lab_deparT = [GPUtils createLable:CGRectZero text:model.departure_time font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_deparT];
    [lab_deparT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_deparT.right).offset(@12);
        make.top.equalTo(img_deparT.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_deparT.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    //到达时间
    UIImageView *img_arrT = [[UIImageView alloc]init];
    [img_arrT setImage:[UIImage imageNamed:@"Route_Time"]];
    [cell addSubview:img_arrT];
    [img_arrT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(lab_deparT.bottom).offset(@12);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    UILabel *lab_arrT = [GPUtils createLable:CGRectZero text:model.finish_time font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_arrT];
    [lab_arrT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_arrT.right).offset(@12);
        make.top.equalTo(img_arrT.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_arrT.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    //出发地点
    UIImageView *img_deparN = [[UIImageView alloc]init];
    [img_deparN setImage:[UIImage imageNamed:@"Self_Drive_Green"]];
    [cell addSubview:img_deparN];
    [img_deparN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(lab_arrT.bottom).offset(@12);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    UILabel *lab_deparN = [GPUtils createLable:CGRectZero text:model.start_name font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_deparN];
    [lab_deparN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_deparN.right).offset(@12);
        make.top.equalTo(img_deparN.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_deparN.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    //到达地点
    UIImageView *img_arrN = [[UIImageView alloc]init];
    [img_arrN setImage:[UIImage imageNamed:@"Self_Drive_Red"]];
    [cell addSubview:img_arrN];
    [img_arrN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(lab_deparN.bottom).offset(@12);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    UILabel *lab_arrN = [GPUtils createLable:CGRectZero text:model.end_name font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_arrN];
    [lab_arrN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_arrN.right).offset(@12);
        make.top.equalTo(img_arrN.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_arrN.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    //公里
    UIImageView *img_milN = [[UIImageView alloc]init];
    [img_milN setImage:[UIImage imageNamed:@"Route_Mileage"]];
    [cell addSubview:img_milN];
    [img_milN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn_isEdit.right).offset(@12);
        make.top.equalTo(lab_arrN.bottom).offset(@12);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    UILabel *lab_milN = [GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@ KM",model.normal_distance] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:lab_milN];
    [lab_milN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img_milN.right).offset(@12);
        make.top.equalTo(img_milN.top).offset(@-5);
        make.width.equalTo(@(Main_Screen_Width-img_milN.zl_y-12));
        make.height.equalTo(@20);
    }];
    
    
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 188, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    [cell addSubview:view];
    
    return cell;
}

-(void)btn_click{
    self.Btn_click(_model);
}


@end
