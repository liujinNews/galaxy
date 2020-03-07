//
//  TravelInfoCell.m
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "TravelInfoCell.h"

@implementation TravelInfoCell

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configCellWith:(FormSubChildModel *)model withStatus:(NSInteger)status{
    self.fromcity.text = model.str_param1;
    self.backcity.text = model.str_param2;
    self.name.text = model.str_param3;
    if (status==1) {
        _btn_delete.hidden =NO;
        [_btn_delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _btn_delete.hidden =YES;
    }
    if (model.str_param4) {
        self.fromAmt.text = model.str_param4;
    }
    if (model.str_param5) {
        self.backAmt.text = model.str_param5;
    }
    if (model.str_param6) {
        self.totalAmt.text = model.str_param6;
    }
}
-(void)delete:(id)sender{
    if (self.deleteBtnClickedBlock) {
        self.deleteBtnClickedBlock(sender);
    }
}
+ (CGFloat)cellHeightWithObj:(FormSubChildModel *)obj{
    return 60;
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
