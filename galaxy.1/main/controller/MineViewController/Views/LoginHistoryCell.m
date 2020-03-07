//
//  LoginHistoryCell.m
//  galaxy
//
//  Created by hfk on 2018/4/17.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "LoginHistoryCell.h"

@implementation LoginHistoryCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView{
    if (!_lab_Date) {
        _lab_Date=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Date];
    }
    [_lab_Date makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@12);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.size.equalTo(CGSizeMake(100, 20));
    }];
    
    if (!_lab_Time) {
        _lab_Time=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Time];
    }
    [_lab_Time makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.bottom).offset(@2);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.size.equalTo(CGSizeMake(100, 20));
    }];
    
    if (!_lab_Name) {
        _lab_Name=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Name];
    }
    
    [_lab_Name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@12);
        make.right.equalTo(self.contentView.right).offset(@-12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-12-12-100, 20));
    }];
    
    if (!_lab_Ip) {
        _lab_Ip=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Ip];
    }
    [_lab_Ip makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Name.bottom).offset(@2);
        make.bottom.equalTo(self.contentView.bottom).offset(@-15);
        make.right.equalTo(self.contentView.right).offset(@-12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-12-12-100, 20));
    }];
    
    if (!_view_Line) {
        _view_Line = [[UIView alloc]initWithFrame:CGRectZero];
        _view_Line.backgroundColor=Color_GrayLight_Same_20;
        [self.contentView addSubview:_view_Line];
    }
    [_view_Line makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.height.equalTo(@0);
    }];
}
-(void)configCellWithArray:(NSMutableArray *)dataArray WithIndex:(NSIndexPath *)index{
    if (index.row==dataArray.count-1) {
        [_view_Line updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        [_view_Line updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
        }];
    }
    NSDictionary *dict=dataArray[index.row];
    self.lab_Name.text=[NSString stringWithIdOnNO:dict[@"deviceName"]];
    
    self.lab_Ip.text=[NSString stringWithFormat:@"IP:%@",[NSString stringWithIdOnNO:dict[@"operatorIP"]]];
    
    NSArray *array=[[NSString stringWithFormat:@"%@",dict[@"operatorDate"]] componentsSeparatedByString:@" "];
    if (array.count==2) {
        self.lab_Date.text=[NSString stringWithIdOnNO:array[0]];
        self.lab_Time.text=[NSString stringWithIdOnNO:array[1]];
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
