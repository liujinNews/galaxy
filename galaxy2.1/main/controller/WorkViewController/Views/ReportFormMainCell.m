//
//  ReportFormMainCell.m
//  galaxy
//
//  Created by hfk on 16/5/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ReportFormMainCell.h"

@interface ReportFormMainCell()

//下拉菜单数据源
@property (nonatomic, strong) NSMutableArray *FormChartArray;

//是否已经绘制了下拉菜单
@property (nonatomic, assign) BOOL isAlreadyDrawForm;

@end
@implementation ReportFormMainCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self createMainView];
    }
    return self;
}
-(void)createMainView{
    self.mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 90)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    
    self.titleLabel=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width-180, 20) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    self.titleLabel.center=CGPointMake(Main_Screen_Width/2-75, 22);
    [self.mainView addSubview:self.titleLabel];
    
    self.name1Label=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-130, 20) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    self.name1Label.center=CGPointMake(Main_Screen_Width/2-50, 45);
    [self.mainView addSubview:self.name1Label];
    
    self.name2Label=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-30, 20) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    self.name2Label.center=CGPointMake(Main_Screen_Width/2, 67);
    [self.mainView addSubview:self.name2Label];
    
    self.name3Label=[GPUtils createLable:CGRectMake(0, 0,100, 20) text:nil font:Font_Same_11_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    self.name3Label.center=CGPointMake(Main_Screen_Width-65, 45);
    [self.mainView addSubview:self.name3Label];
    
    self.numberLabel=[GPUtils createLable:CGRectMake(0, 0,160, 20) text:nil font:Font_Important_18_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentRight];
    self.numberLabel.center=CGPointMake(Main_Screen_Width-95, 24);
    [self.mainView addSubview:self.numberLabel];
    
//        self.titleLabel.backgroundColor=[UIColor redColor];
//        self.name1Label.backgroundColor=[UIColor cyanColor];
//        self.name2Label.backgroundColor=[UIColor orangeColor];
//        self.name3Label.backgroundColor=[UIColor blueColor];
//        self.numberLabel.backgroundColor=[UIColor greenColor];
}
-(void)configViewWithModel:(ReportFormMainModel *)model{
    
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([model isKindOfClass:[NSNull class]]) {
        return;
    }
//    if ([model.title isEqualToString:Custing(@"单据查询", nil)]) {
//        self.titleLabel.text=Custing(@"费用单据查询", nil);
//    }else{
        self.titleLabel.text=[NSString stringWithFormat:@"%@",model.title];
//    }
    
    self.name3Label.text=[NSString stringWithFormat:@"%@",model.name3];
    if ([model.code isEqualToString:@"001"]) {
        self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,[GPUtils transformNsNumber:model.value1]];
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,[GPUtils transformNsNumber:model.value2]];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:model.value3]];
//        self.numberLabel.textColor=Color_Red_Weak_20;
        
    }else if ([model.code isEqualToString:@"002"]){
        self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,[GPUtils transformNsNumber:model.value1]];
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,[GPUtils transformNsNumber:model.value2]];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:model.value3]];
//        self.numberLabel.textColor=Color_Green_Weak_20;
        
    }else if ([model.code isEqualToString:@"003"]){
        self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,[GPUtils transformNsNumber:model.value1]];
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,[GPUtils transformNsNumber:model.value2]];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:model.value3]];
//        self.numberLabel.textColor=Color_Blue_Important_20;
    }else if ([model.code isEqualToString:@"004"]){
        self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,[GPUtils transformNsNumber:model.value1]];
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,model.value2];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:model.value3]];
//        self.numberLabel.textColor=Color_Purple_Weak_20;
        
    }else if ([model.code isEqualToString:@"005"]){

        NSArray *array = [model.value1 componentsSeparatedByString:@"|"];
        if (array.count>1) {
            self.name1Label.text=[NSString stringWithFormat:@"%@%@|%@",model.name1,[GPUtils transformNsNumber:array[0]],array[1]];
        }else{
            self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,[GPUtils transformNsNumber:array[0]]];
        }
        NSArray *array2 = [model.value2 componentsSeparatedByString:@"|"];
        if (array2.count>1) {
            self.name2Label.text=[NSString stringWithFormat:@"%@%@|%@",model.name2,[GPUtils transformNsNumber:array2[0]],array2[1]];
        }else{
            self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,[GPUtils transformNsNumber:array2[0]]];
        }
        self.numberLabel.text=[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:model.value3]];
//        self.numberLabel.textColor=Color_Purple_Weak_20;
    }else if ([model.code isEqualToString:@"006"]){
        NSArray *array = [model.value1 componentsSeparatedByString:@"|"];
        if ([NSString isEqualToNull:array[1]]) {
            self.name1Label.text=[NSString stringWithFormat:@"%@%@|%@",model.name1,[GPUtils transformNsNumber:array[0]],array[1]];
        }else{
            self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,[GPUtils transformNsNumber:array[0]]];
        }
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,model.value2];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:model.value3]];
//        self.numberLabel.textColor=Color_Purple_Weak_20;
    }else if ([model.code isEqualToString:@"007"]){
        self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,model.value1];
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,model.value2];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",model.value3];
//        self.numberLabel.textColor=Color_Blue_Important_20;
        
    }else if ([model.code isEqualToString:@"008"]){
        self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,model.value1];
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,model.value2];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",model.value3];
//        self.numberLabel.textColor=Color_Blue_Important_20;
        
    }else if ([model.code isEqualToString:@"009"]){
        self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,model.value1];
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,[GPUtils notRounding:[model.value2 floatValue] afterPoint:1]];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",model.value3];
//        self.numberLabel.textColor=Color_Red_Weak_20;
    }else if ([model.code isEqualToString:@"010"]){
        self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,model.value1];
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,[GPUtils transformNsNumber:model.value2]];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:model.value3]];
//        self.numberLabel.textColor=Color_Orange_Weak_20;
    }else if ([model.code isEqualToString:@"011"]){
        self.name1Label.text=[NSString stringWithFormat:@"%@%@",model.name1,model.value1];
        self.name2Label.text=[NSString stringWithFormat:@"%@%@",model.name2,model.value2];
        self.numberLabel.text=[NSString stringWithFormat:@"%@",model.value3];
//        self.numberLabel.textColor=Color_Purple_Weak_20;
    }
}

/**
 *  构建下拉视图
 */
- (void)buildChartViewWithModel:(ReportFormMainModel *)model{
    
    [self.ChartView removeFromSuperview];
    self.ChartView=[[UIView alloc]initWithFrame:CGRectMake(0, 90, Main_Screen_Width, 135)];
    self.ChartView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:self.ChartView];
    
    if ([self.dataSource respondsToSelector:@selector(dataSourceForFormItem)])
    {
        self.FormChartArray=[self.dataSource dataSourceForFormItem];
        NSLog(@"%@",self.FormChartArray);
        [self CreateChartViewsWithModel:model];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.numberOfTapsRequired =1;
    [self.ChartView addGestureRecognizer:tap];
    UIView *singleTapView = [tap view];
    if ([model.code isEqualToString:@"001"]) {
        singleTapView.tag = 1;
    }else if ([model.code isEqualToString:@"002"]){
        singleTapView.tag = 2;
    }else if ([model.code isEqualToString:@"003"]){
        singleTapView.tag = 3;
    }else if ([model.code isEqualToString:@"004"]){
        singleTapView.tag = 4;
    }else if ([model.code isEqualToString:@"005"]){
        singleTapView.tag = 11;
    }else if ([model.code isEqualToString:@"006"]){
        singleTapView.tag = 5;
    }else if ([model.code isEqualToString:@"007"]){
        singleTapView.tag =6;
    }else if ([model.code isEqualToString:@"008"]){
        singleTapView.tag =7;
    }else if ([model.code isEqualToString:@"009"]){
        singleTapView.tag =8;
    }else if ([model.code isEqualToString:@"010"]){
        singleTapView.tag =9;
    }else if ([model.code isEqualToString:@"011"]){
        singleTapView.tag =10;
    }
}

-(void)CreateChartViewsWithModel:(ReportFormMainModel *)model{
    
    if ([model.code isEqualToString:@"001"]||[model.code isEqualToString:@"002"]||[model.code isEqualToString:@"003"]||[model.code isEqualToString:@"004"]||[model.code isEqualToString:@"007"]||[model.code isEqualToString:@"010"]||[model.code isEqualToString:@"011"]) {
        DVLineChartView *lineView = [[DVLineChartView alloc] initWithFrame:CGRectMake(-10, 0, Main_Screen_Width+20, 135)];
        lineView.delegate = self;
        lineView.xAxisTitleArray =self.FormChartArray[0];
        double max = [[self.FormChartArray[1] valueForKeyPath:@"@max.doubleValue"] doubleValue];
        lineView.yAxisMaxValue =max+1;
        [self.ChartView addSubview:lineView];
        
        DVPlot *plot = [[DVPlot alloc] init];
        plot.pointArray =self.FormChartArray[1];
        NSInteger count=(Main_Screen_Width)/45;
        if (plot.pointArray.count>count) {
            lineView.index=plot.pointArray.count-count;
        }else{
            lineView.index=0;
        }
        
        if ([model.code isEqualToString:@"001"]) {
            plot.lineColor =Color_Red_Weak_20;
            plot.pointImage=[UIImage imageNamed:@"ReportForm_Red"];
        }else if ([model.code isEqualToString:@"002"]){
            plot.lineColor =Color_Green_Weak_20;
            plot.pointImage=[UIImage imageNamed:@"ReportForm_Green"];
        }else if ([model.code isEqualToString:@"003"]||[model.code isEqualToString:@"007"]){
            plot.lineColor =Color_Blue_Important_20;
            plot.pointImage=[UIImage imageNamed:@"ReportForm_Blue"];
        }else if ([model.code isEqualToString:@"004"]||[model.code isEqualToString:@"011"]){
            plot.lineColor =Color_Purple_Weak_20;
            plot.pointImage=[UIImage imageNamed:@"ReportForm_Purple"];
        }else if ([model.code isEqualToString:@"010"]){
            plot.lineColor =Color_Orange_Weak_20;
            plot.pointImage=[UIImage imageNamed:@"ReportForm_Orange"];
        }
        
        [lineView addPlot:plot];
        [lineView draw];
        
    }else if ([model.code isEqualToString:@"006"]||[model.code isEqualToString:@"008"]||[model.code isEqualToString:@"009"]||[model.code isEqualToString:@"005"]){
        DVBarChartView *chartView = [[DVBarChartView alloc] initWithFrame:CGRectMake(-10, 0, Main_Screen_Width+20, 135)];
        [self.ChartView addSubview:chartView];
        chartView.yAxisViewWidth = 10;
        chartView.xAxisTitleArray = self.FormChartArray[0];
        if ([chartView.xAxisTitleArray isKindOfClass:[NSNull class]]||chartView.xAxisTitleArray.count==0) {
            chartView.xAxisTitleArray=@[@""];
            double max =(double)20;
            chartView.yAxisMaxValue =max;
            chartView.xValues = @[@0];
            chartView.showPointLabel=NO;
            chartView.index=0;
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
            imageView.center=CGPointMake(chartView.center.x, chartView.center.y-20);
            imageView.image=[UIImage imageNamed:@"TemporarilyNoData"];
            [chartView addSubview:imageView];
             UILabel *label=[GPUtils createLable:CGRectMake(0, 0,150,20) text:Custing(@"暂无数据", nil) font:Font_Same_11_20 textColor:[GPUtils colorHString:CustomColorForLightText] textAlignment:NSTextAlignmentCenter];
            label.center=CGPointMake(imageView.center.x, imageView.center.y+30);
            [chartView addSubview:label];
        }else{
            double max = [[self.FormChartArray[1] valueForKeyPath:@"@max.doubleValue"] doubleValue];
            chartView.yAxisMaxValue =max+1;
            chartView.xValues = self.FormChartArray[1];
            NSInteger count=(Main_Screen_Width)/45;
            if (chartView.xValues.count>count) {
                chartView.index=chartView.xValues.count-count;
            }else{
                chartView.index=0;
            }
        }
        chartView.delegate = self;
        if ([model.code isEqualToString:@"006"]) {
            chartView.barColor=Color_Purple_Weak_20;
        }else if ([model.code isEqualToString:@"008"]){
            chartView.barColor=Color_Blue_Important_20;
        }else if ([model.code isEqualToString:@"009"]||[model.code isEqualToString:@"005"]){
            chartView.barColor=Color_Red_Weak_20;
        }
        [chartView draw];
    }
    
}

- (void)tapGesture:(id)sender {
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    //    NSLog(@"%d",[singleTap view].tag);
    if ([self.delegate respondsToSelector:@selector(FormTableViewCell:didSeletedFormItemAtIndex:)]) {
        [self.delegate FormTableViewCell:self didSeletedFormItemAtIndex:[singleTap view].tag];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.isOpenForm = selected;
    
    // Configure the view for the selected state
}

@end
