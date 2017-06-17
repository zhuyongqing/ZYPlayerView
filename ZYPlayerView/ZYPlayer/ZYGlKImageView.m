//
//  ZYGlKImageView.m
//  ZYPlayerView
//
//  Created by zhuyongqing on 2017/6/17.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYGlKImageView.h"
#import <GLKit/GLKit.h>

@interface ZYGlKImageView()<GLKViewDelegate>

@property(nonatomic,strong) GLKView *glkView;

@property(nonatomic,strong) CIContext *imageContext;

@end

@implementation ZYGlKImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initGlkView];
    }
    return self;
}

- (void)initGlkView{
    
    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _glkView = [[GLKView alloc] initWithFrame:CGRectZero context:eaglContext];
    _glkView.delegate = self;
    [_glkView bindDrawable];
    _glkView.enableSetNeedsDisplay = NO;
    [self addSubview:_glkView];
    [EAGLContext setCurrentContext:eaglContext];
    
    _imageContext = [CIContext contextWithEAGLContext:eaglContext options:@{kCIContextWorkingColorSpace:[NSNull null]}];
    
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self.imageContext drawImage:self.renderImg inRect:CGRectMake(0, 0, self.glkView.drawableWidth, self.glkView.drawableHeight) fromRect:[self.renderImg extent]];
    
}


- (void)setRenderImg:(CIImage *)renderImg{
    _renderImg = renderImg;
    
    [self.glkView display];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.glkView.frame = self.bounds;
}

@end
