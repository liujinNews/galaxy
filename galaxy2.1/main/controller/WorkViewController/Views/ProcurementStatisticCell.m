//
//  ProcurementStatisticCell.m
//  galaxy
//
//  Created by hfk on 16/6/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ProcurementStatisticCell.h"
#import "PNPieChart.h"

@implementation ProcurementStatisticCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
    }
    return self;
}
-(void)configCellWithIndex:(NSInteger)index WithAmount:(NSString *)amount WithHeight:(NSInteger)height WithArray:(NSMutableArray *)array{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width,height)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    NSMutableArray *items = [NSMutableArray array];
    if ([amount floatValue]==0) {
        [items addObject:[PNPieChartDataItem dataItemWithValue:1 color:[GPUtils colorHString:@"#f16971"]]];
        [self createChartViewWithArray:items];
    }else{
        for (NSDictionary *dict in array) {
            if ([dict[@"percent"]floatValue]>0) {
               [items addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"percent"]floatValue] color:[GPUtils colorHString:dict[@"color"]]]];
                [self createChartViewWithArray:items];
            }
        }
    }
  

    
    if ([amount floatValue]==0) {
        UILabel *nodateLab=[GPUtils createLable:CGRectMake(0, 0, 75, 20) text:Custing(@"无数据", nil) font:Font_Same_14_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
        nodateLab.center=CGPointMake(Main_Screen_Width/2, 112);
        [self.mainView addSubview:nodateLab];
    }
    
    for (NSInteger i=0; i<array.count; i++) {
        NSDictionary *dic = array[i];
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        imgView.center=CGPointMake(21, 161+28*i);
        imgView.backgroundColor=[GPUtils colorHString:dic[@"color"]];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 6.0f;
        [self.mainView addSubview:imgView];
        
        UILabel *titleLabel=[GPUtils createLable:CGRectMake(0,0,180, 20) text:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"type"]]]?[NSString stringWithFormat:@"%@",dic[@"type"]]:@"" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        titleLabel.center=CGPointMake(125, 161+28*i);
        [self.mainView addSubview:titleLabel];
        
        UILabel *amountLabel=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width-180, 20) text: [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:dic[@"amount"]]] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        amountLabel.center=CGPointMake(Main_Screen_Width/2+5, 161+28*i);
        [self.mainView addSubview:amountLabel];
        
        
        UILabel *percentLabel=[GPUtils createLable:CGRectMake(0, 0, 60, 20) text:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"percent"]]]?[NSString stringWithFormat:@"%@",dic[@"percent"]]:@"" font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        percentLabel.center=CGPointMake(Main_Screen_Width-40,161+28*i);
//        percentLabel.backgroundColor=[UIColor cyanColor];
        [self.mainView addSubview:percentLabel];
    }
    
    
    if (index==0) {
        UILabel *toltitleLabel=[GPUtils createLable:CGRectMake(0,0,180, 20) text:Custing(@"合计", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        toltitleLabel.center=CGPointMake(125, 161+28*array.count);
        [self.mainView addSubview:toltitleLabel];
        
        UILabel *tolamountLabel=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width-180, 20) text: [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:amount]]  font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        tolamountLabel.center=CGPointMake(Main_Screen_Width/2+5, 161+28*array.count);
        //        amountLabel.backgroundColor=[UIColor blueColor];
        [self.mainView addSubview:tolamountLabel];
        
    }

}
-(void)createChartViewWithArray:(NSMutableArray *)items{
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, 128, 128) items:items];
    pieChart.center=CGPointMake(Main_Screen_Width/2, 81);
    pieChart.descriptionTextColor = Color_form_TextFieldBackgroundColor;
    pieChart.descriptionTextFont  = Font_circleTitle_14;
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.showAbsoluteValues = NO;
    pieChart.showOnlyValues = NO;
    pieChart.shouldHighlightSectorOnTouch = NO;
    pieChart.enableMultipleSelection = NO;
    pieChart.innerCircleRadius = 0.0;
    [pieChart strokeChart];
    pieChart.legendStyle = PNLegendItemStyleSerial;
    pieChart.legendFont = [UIFont boldSystemFontOfSize:14.0f];
    [self.mainView addSubview:pieChart];


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
