//
//  MyTitleSwitchCell.m
//  MyDemo
//
//  Created by wilderliao on 15/10/27.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyTitleSwitchCell.h"

#import "ConfigItem.h"

@implementation MyTitleSwitchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.mySwitch = [[UISwitch alloc] init];
        [_mySwitch addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = self.mySwitch;
    }
    return self;
}

- (void)onValueChanged:(UISwitch *)sw
{
    _mySwitch = sw;
    _item.switchOn = sw.on;
    [_item ConfigCellAction];
}

- (void)config:(ConfigItem *)item
{
    self.item = item;
    self.textLabel.text = item.title;
    [self.mySwitch setOn:item.switchOn];
    self.mySwitch.enabled = item.isEnable;
}

@end
