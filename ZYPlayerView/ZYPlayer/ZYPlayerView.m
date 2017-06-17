//
//  ZYPlayerView.m
//  ZYPlayerView
//
//  Created by zhuyongqing on 2017/6/17.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZYFilterTool.h"
#import "ZYGlKImageView.h"

@interface ZYPlayerView(){
    AVPlayerItemVideoOutput *_videoOutPut;
    
    dispatch_queue_t _renderQueue;
    
    CGSize _videoSize;
}

@property(nonatomic,strong) AVPlayer *player;

@property(nonatomic,strong) CADisplayLink *playLink;

@property(nonatomic,strong) ZYGlKImageView *glkImgView;

@property(nonatomic,strong) ZYGlKImageView *blurView;

@property(nonatomic,strong) UIVisualEffectView *effectView;



@end


@implementation ZYPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initPlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)playEnd{
    [self.player.currentItem seekToTime:CMTimeMakeWithSeconds(0, self.player.currentItem.duration.timescale)];
    [self.player play];
}

- (void)playerRender{
    
    CMTime itemTime = [_videoOutPut itemTimeForHostTime:CACurrentMediaTime()];
    
    if ([_videoOutPut hasNewPixelBufferForItemTime:itemTime]) {
        
        dispatch_async(_renderQueue, ^{
            CVPixelBufferRef pixelBuffer = [_videoOutPut copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
        
            CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

            CIImage *outPutImg = [[ZYFilterTool filter] renderCIImage:ciImage];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self.blurView.renderImg = outPutImg;
                self.glkImgView.renderImg = outPutImg;
                
            });
            
            CVBufferRelease(pixelBuffer);
           
        });
        
    }else{
        
    }
}

- (void)initPlayer{
    
    _renderQueue = dispatch_queue_create("com.render", DISPATCH_QUEUE_SERIAL);
    
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"play" ofType:@"mp4"];
    NSURL *videoUrl = [NSURL fileURLWithPath:urlPath];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:videoUrl];
    
    _videoOutPut = [[AVPlayerItemVideoOutput alloc] initWithOutputSettings:nil];
    
    _player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    [self.player.currentItem addOutput:_videoOutPut];
    
    AVAsset *asset = self.player.currentItem.asset;
    AVAssetTrack *track = asset.tracks.firstObject;
    _videoSize = track.naturalSize;
    
    
    _playLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(playerRender)];
    [_playLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _playLink.frameInterval = 2;
    
    _blurView = [[ZYGlKImageView alloc] init];
    [self addSubview:_blurView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _effectView.alpha = .95;
    [_blurView addSubview:_effectView];
    
    _glkImgView = [[ZYGlKImageView alloc] init];
    [self addSubview:_glkImgView];
    
    [_player play];
    
}

- (void)setUpVideoSize{
    
    CGFloat width = _videoSize.width;
    CGFloat height = _videoSize.height;
    
    CGFloat newWidth;
    CGFloat newHeight;
    
    if (width > height) {
        newWidth = CGRectGetWidth(self.frame);
        newHeight = newWidth * height/width;
    }else if(height > width){
        newHeight = CGRectGetWidth(self.frame);
        newWidth = newHeight * width/height;
    }else{
        
        newWidth = CGRectGetWidth(self.frame);
        newHeight = newWidth;
    }
    
    _videoSize = CGSizeMake(newWidth, newHeight);
    
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.blurView.frame = self.bounds;
    self.effectView.frame = self.bounds;
    
    [self setUpVideoSize];
    
    self.glkImgView.frame = CGRectMake(0,0,_videoSize.width,_videoSize.height);
    self.glkImgView.center = self.blurView.center;
}





@end
