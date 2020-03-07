//
//  PurAndContractDetailView.m
//  galaxy
//
//  Created by hfk on 2019/1/7.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "PurAndContractDetailView.h"
#import "PurContractSinglePayCell.h"
#import "ContractBatchPayCell.h"

@interface PurAndContractDetailView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *flowCode;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyPaymentFormData *formData;


@end

@implementation PurAndContractDetailView

-(instancetype)initWithFlowCode:(NSString *)flowcode{
    self = [super init];
    if (self) {
        [self setClipsToBounds:YES];
        _flowCode = flowcode;
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = Color_BorrowLine_Same_20;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(0);
        }];
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tableView.bottom);
        }];
    }
    return self;
}

-(void)updateViewWithData:(MyPaymentFormData *)formData{
    NSInteger height = 0;
    self.formData = formData;
    if ([self.flowCode isEqualToString:@"F0005"]) {
        [_tableView registerClass:[PurContractSinglePayCell class] forCellReuseIdentifier:@"PurContractSinglePayCell"];
        height = 120 + (self.formData.arr_paymentPurDetails.count * [PurContractSinglePayCell cellHeight]);
    }else if ([self.flowCode isEqualToString:@"F0013"]){
        if (self.formData.int_isContractPaymentMethod == 1) {
            [_tableView registerClass:[ContractBatchPayCell class] forCellReuseIdentifier:@"ContractBatchPayCell"];
            height = [ContractBatchPayCell cellHeight] * self.formData.arr_paymentContDetailDtoList.count;

        }else{
            [_tableView registerClass:[PurContractSinglePayCell class] forCellReuseIdentifier:@"PurContractSinglePayCell"];
            height = 150 + (self.formData.arr_paymentContDetailDtoList.count * [PurContractSinglePayCell cellHeight]);
        }
    }
    [_tableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [_tableView reloadData];
}
//MARK:UITableViewDataSource 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.flowCode isEqualToString:@"F0005"]) {
        return self.formData.arr_paymentPurDetails.count;
    }else if ([self.flowCode isEqualToString:@"F0013"]){
        return self.formData.arr_paymentContDetailDtoList.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.flowCode isEqualToString:@"F0005"]) {
        return [PurContractSinglePayCell cellHeight];
    }else if ([self.flowCode isEqualToString:@"F0013"]){
        if (self.formData.int_isContractPaymentMethod == 1) {
            return [ContractBatchPayCell cellHeight];
        }else{
            return [PurContractSinglePayCell cellHeight];
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.flowCode isEqualToString:@"F0013"] && self.formData.int_isContractPaymentMethod == 1) {
        return 0.01;
    }
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.flowCode isEqualToString:@"F0013"] && self.formData.int_isContractPaymentMethod == 1) {
        return [[UIView alloc]init];
    }else{
        UIView *View_head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
        UILabel *no = [GPUtils createLable:CGRectMake(12, 0, 70, 30) text:Custing(@"序号", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [View_head addSubview:no];
        
        UILabel *date = [GPUtils createLable:CGRectMake(90, 0, 100, 30) text:Custing(@"付款日期", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [View_head addSubview:date];
        
        UILabel *money = [GPUtils createLable:CGRectMake(190, 0, Main_Screen_Width - 190 - 12, 30) text:Custing(@"已付金额", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [View_head addSubview:money];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 1)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [View_head addSubview:lineView];

        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 29, Main_Screen_Width, 1)];
        lineView1.backgroundColor = Color_GrayLight_Same_20;
        [View_head addSubview:lineView1];

        return View_head;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.flowCode isEqualToString:@"F0005"]) {
        return 90;
    }else if ([self.flowCode isEqualToString:@"F0013"] && self.formData.int_isContractPaymentMethod != 1){
        return 120;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *View_footer= [[UIView alloc]init];
    if ([self.flowCode isEqualToString:@"F0005"]) {
        View_footer.frame = CGRectMake(0, 0  , Main_Screen_Width, 90);
        UILabel *title1 = [GPUtils createLable:CGRectMake(12, 0, 110, 30) text:Custing(@"采购金额", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [View_footer addSubview:title1];
        UILabel *amount1 = [GPUtils createLable:CGRectMake(122, 0, Main_Screen_Width - 122 - 12, 30) text:[GPUtils transformNsNumber:self.formData.str_PurAmount] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [View_footer addSubview:amount1];

        UILabel *title2 = [GPUtils createLable:CGRectMake(12, 30, 110, 30) text:Custing(@"本次付款金额", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [View_footer addSubview:title2];
        UILabel *amount2 = [GPUtils createLable:CGRectMake(122, 30, Main_Screen_Width - 122 - 12, 30) text:[GPUtils transformNsNumber:self.formData.str_PaymentAmount] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [View_footer addSubview:amount2];

        UILabel *title3 = [GPUtils createLable:CGRectMake(12, 60, 110, 30) text:Custing(@"剩余金额", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [View_footer addSubview:title3];
        UILabel *amount3 = [GPUtils createLable:CGRectMake(122, 60, Main_Screen_Width - 122 - 12, 30) text:[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.formData.str_PurOverAmount with:self.formData.str_PaymentAmount]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [View_footer addSubview:amount3];
        
    }else if ([self.flowCode isEqualToString:@"F0013"] && self.formData.int_isContractPaymentMethod != 1){
        View_footer.frame = CGRectMake(0, 0, Main_Screen_Width, 120);
        UILabel *title1 = [GPUtils createLable:CGRectMake(12, 0, 110, 30) text:Custing(@"合同金额", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [View_footer addSubview:title1];
        UILabel *amount1 = [GPUtils createLable:CGRectMake(122, 0, Main_Screen_Width - 122 - 12, 30) text:[GPUtils transformNsNumber:self.formData.str_ContractAmount] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [View_footer addSubview:amount1];

        UILabel *title2 = [GPUtils createLable:CGRectMake(12, 30, 110, 30) text:Custing(@"已付款金额合计", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [View_footer addSubview:title2];
        UILabel *amount2 = [GPUtils createLable:CGRectMake(122, 30, Main_Screen_Width - 122 - 12, 30) text:[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.formData.str_ContractAmount with:self.formData.str_ContractOverAmount]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [View_footer addSubview:amount2];
        
        UILabel *title3 = [GPUtils createLable:CGRectMake(12, 60, 110, 30) text:Custing(@"本次付款金额", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [View_footer addSubview:title3];
        UILabel *amount3 = [GPUtils createLable:CGRectMake(122, 60, Main_Screen_Width - 122 - 12, 30) text:[GPUtils transformNsNumber:self.formData.str_PaymentAmount] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [View_footer addSubview:amount3];
        
        UILabel *title4 = [GPUtils createLable:CGRectMake(12, 90, 110, 30) text:Custing(@"剩余金额", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [View_footer addSubview:title4];
        UILabel *amount4 = [GPUtils createLable:CGRectMake(122, 90, Main_Screen_Width - 122 - 12, 30) text:[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.formData.str_ContractOverAmount with:self.formData.str_PaymentAmount]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [View_footer addSubview:amount4];
    }
    return View_footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict;
    if ([self.flowCode isEqualToString:@"F0005"]) {
        dict = self.formData.arr_paymentPurDetails[indexPath.row];
    }else if ([self.flowCode isEqualToString:@"F0013"]){
        dict = self.formData.arr_paymentContDetailDtoList[indexPath.row];
    }
    if ([self.flowCode isEqualToString:@"F0013"] && self.formData.int_isContractPaymentMethod == 1) {
        ContractBatchPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContractBatchPayCell" forIndexPath:indexPath];
        [cell configCellWithDict:dict WithHideLine:(indexPath.row == self.formData.arr_paymentContDetailDtoList.count - 1)];
        return cell;
    }else{
        PurContractSinglePayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurContractSinglePayCell" forIndexPath:indexPath];
        cell.flowCode = self.flowCode;
        [cell configCellWithDict:dict WithIndex:indexPath.row];
        return cell;  
    }
    return [UITableViewCell new];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
