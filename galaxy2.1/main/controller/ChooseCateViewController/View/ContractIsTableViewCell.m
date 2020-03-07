//
//  ContractIsTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ContractIsTableViewCell.h"

@implementation ContractIsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lab_title_no.text = Custing(@"付款批次", nil);
    _lab_title_Amount.text = Custing(@"付款金额", nil);
    _lab_title_gridOrder.text = Custing(@"合同明细", nil);
    _lab_title_paidAmount.text = Custing(@"已付金额", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setLable_Value:(ChooseCateFreModel *)model{
    self.lab_no.text = model.no;
    self.lab_amount.text = [GPUtils transformNsNumber:model.amount];
    self.lab_serialNo.text =[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.contractNo],[NSString stringWithFormat:@"%@",model.contractName]] WithCompare:@"/"]; 
    self.lab_gridOrder.text = model.gridOrder;
    self.lab_paidAmount.text = [GPUtils transformNsNumber:model.paidAmount];
    self.lab_totalAmount.text = [GPUtils transformNsNumber:model.totalAmount];
}

@end
