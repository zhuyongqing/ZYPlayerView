//
//  ZYFilterTool.h
//  ZYPlayerView
//
//  Created by zhuyongqing on 2017/6/17.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface ZYFilterTool : NSObject

@property(nonatomic,assign) float saturation;

@property(nonatomic,assign) float contrast;

@property(nonatomic,assign) float light;


+ (instancetype)filter;

- (CIImage *)renderCIImage:(CIImage *)ciImg;


@end
