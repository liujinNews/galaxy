//
//  ColleagueListCell.m
//  galaxy
//
//  Created by hfk on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ColleagueListCell.h"

@implementation ColleagueListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellAccessoryNone;
        [self createView];
    }
    return self;
}
-(void)createView{
    
    if (!_img_UserPho) {
        _img_UserPho=[[UIImageView alloc]init];
        _img_UserPho.layer.masksToBounds = YES;
        _img_UserPho.layer.cornerRadius = 20.0f;
        [self.contentView addSubview:_img_UserPho];
    }
    [_img_UserPho makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(@12);
        make.top.equalTo(self.contentView.top).offset(@10);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    if (!_lab_Name) {
        _lab_Name=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Name];
    }
    [_lab_Name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.equalTo(self.contentView.left).offset(@65);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-65-12, 30));
    }];
    
    if (!_lab_Job) {
        _lab_Job=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Job];
    }
    [_lab_Job makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@30);
        make.left.equalTo(self.contentView.left).offset(@65);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-65-12, 25));
    }];
    
    
    if (!_view_Line) {
        _view_Line=[[UIView alloc]init];
        _view_Line.backgroundColor=Color_GrayLight_Same_20;
        [self.contentView addSubview:_view_Line];
    }
    
    [_view_Line makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.contentView.left).offset(@65);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-65, 0.5));
    }];
}
-(void)setDict_data:(NSDictionary *)dict_data{
    if (dict_data) {
        if (![dict_data[@"photoGraph"] isKindOfClass:[NSNull class]]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:dict_data[@"photoGraph"]];
            [_img_UserPho sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
        }else{
            if ([[NSString stringWithFormat:@"%@",dict_data[@"gender"]]isEqualToString:@"1"]) {
                _img_UserPho.image=[UIImage imageNamed:@"Message_Woman"];
            }else{
                _img_UserPho.image=[UIImage imageNamed:@"Message_Man"];
            }
        }
        _lab_Name.text=[NSString isEqualToNull:dict_data[@"userDspName"]]?[NSString stringWithFormat:@"%@",dict_data[@"userDspName"]]:@"";
        _lab_Job.text=[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict_data[@"department"]],[NSString stringWithFormat:@"%@",dict_data[@"jobTitle"]]]];

    }
}
-(void)setBool_hasLine:(BOOL)bool_hasLine{
    _view_Line.hidden=bool_hasLine;
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
