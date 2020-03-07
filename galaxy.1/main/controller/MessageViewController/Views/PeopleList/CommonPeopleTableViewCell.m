//
//  CommonPeopleTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CommonPeopleTableViewCell.h"

@implementation CommonPeopleTableViewCell

-(void)layoutSubviews
{
    if ([NSString isEqualToNull:_dic[@"userDspName"]]) {
        self.lab_name.text = _dic[@"userDspName"];
    }else if ([NSString isEqualToNull:_dic[@"requestor"]]) {
        self.lab_name.text = _dic[@"requestor"];
    }
    
    NSDictionary * dics = (NSDictionary *)[NSString transformToObj:_dic[@"photoGraph"] ];
    NSString * nicai = [NSString stringWithFormat:@"%@",[dics objectForKey:@"filepath"]];
    if ([NSString isEqualToNull:nicai]) {
        [self.img_head sd_setImageWithURL:[NSURL URLWithString:nicai]];
    }
    else
    {
        if (_img_head.image==nil) {
            _img_head.image = [UIImage imageNamed:@"Message_Man"];
        }
        
    }
    
    if ([NSString isEqualToNull:_dic[@"department"]]) {
        _lab_department.text = _dic[@"department"];
    }else if ([NSString isEqualToNull:_dic[@"requestorDept"]]) {
        _lab_department.text = _dic[@"requestorDept "];
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
