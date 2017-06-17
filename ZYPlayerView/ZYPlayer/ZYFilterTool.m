//
//  ZYFilterTool.m
//  ZYPlayerView
//
//  Created by zhuyongqing on 2017/6/17.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYFilterTool.h"

@implementation ZYFilterTool

+ (instancetype)filter{
    
    static ZYFilterTool *_filter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _filter = [[ZYFilterTool alloc] init];
    });
    return _filter;
}


- (CIImage *)renderCIImage:(CIImage *)ciImg{
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:ciImg forKey:kCIInputImageKey];
    [filter setDefaults];
    // 修改亮度   -1---1   数越大越亮
    [filter setValue:@(self.light) forKey:@"inputBrightness"];
    
    // 修改饱和度  0---2
    [filter setValue:@(self.saturation) forKey:@"inputSaturation"];
    
    // 修改对比度  0---4
    [filter setValue:@(self.contrast) forKey:@"inputContrast"];
    CIImage *outputImage = [filter outputImage];
    
    return outputImage;
}

@end
