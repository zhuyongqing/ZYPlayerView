//
//  ViewController.m
//  ZYPlayerView
//
//  Created by zhuyongqing on 2017/6/17.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ViewController.h"
#import "ZYPlayerView.h"
#import "ZYFilterTool.h"
@interface ViewController ()

@property(nonatomic,strong) ZYPlayerView *playerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initPlayerView];
    
    [self initSlider];
}

- (void)initPlayerView{
    _playerView = [[ZYPlayerView alloc] init];
    [self.view addSubview:_playerView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.playerView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
}


- (void)initSlider{
    NSArray *maxValues = @[@1,@2,@4];
    NSArray *minValues = @[@(-1),@0,@0];
    NSArray *values = @[@0,@1,@1];
    
    for (int i = 0; i<3; i++) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 100 + CGRectGetWidth(self.view.frame) + i * (50), CGRectGetWidth(self.view.frame) - 40, 40)];
        slider.value = [values[i] floatValue];
        slider.maximumValue = [maxValues[i] floatValue];
        slider.minimumValue = [minValues[i] floatValue];
        slider.thumbTintColor = [UIColor cyanColor];
        slider.tag = i + 10;
        [self.view addSubview:slider];
        [slider addTarget:self action:@selector(slidervalueChangeAction:) forControlEvents:UIControlEventValueChanged];
        [self slidervalueChangeAction:slider];
    }
}

- (void)slidervalueChangeAction:(UISlider *)slider{
    
    ZYFilterTool *filterTool = [ZYFilterTool filter];
    
    
    switch (slider.tag - 10) {
        case 0:
            filterTool.light = slider.value;
            break;
        case 1:
            filterTool.saturation = slider.value;
            break;
        case 2:
            filterTool.contrast = slider.value;
            break;
        default:
            break;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
