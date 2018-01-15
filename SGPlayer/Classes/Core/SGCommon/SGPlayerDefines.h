//
//  SGPlayerDefines.h
//  SGPlayer
//
//  Created by Single on 2018/1/9.
//  Copyright © 2018年 single. All rights reserved.
//

#ifndef SGPlayerDefines_h
#define SGPlayerDefines_h


#import <Foundation/Foundation.h>


#if defined(__cplusplus)
#define SGPLAYER_EXTERN extern "C"
#else
#define SGPLAYER_EXTERN extern
#endif


typedef NS_ENUM(NSUInteger, SGPlayerPlaybackState)
{
    SGPlayerPlaybackStateIdle,
    SGPlayerPlaybackStatePlaying,
    SGPlayerPlaybackStateSeeking,
    SGPlayerPlaybackStatePaused,
    SGPlayerPlaybackStateInterrupted,
    SGPlayerPlaybackStateStopped,
    SGPlayerPlaybackStateFinished,
    SGPlayerPlaybackStateFailed,
};

typedef NS_ENUM(NSUInteger, SGPlayerLoadState)
{
    SGPlayerLoadStateIdle,
    SGPlayerLoadStateLoading,
    SGPlayerLoadStatePlayable,
};

typedef NS_ENUM(NSUInteger, SGPlayerBackgroundMode)
{
    SGPlayerBackgroundModeAutoPlayAndPause,
    SGPlayerBackgroundModeContinue,
};


@protocol SGPlayer <NSObject>

- (NSInteger)tag;
- (NSURL *)contentURL;
- (SGPlayerPlaybackState)playbackState;
- (SGPlayerLoadState)loadState;
- (NSTimeInterval)duration;
- (NSTimeInterval)currentTime;
- (NSTimeInterval)loadedTime;
- (NSError *)error;
- (SGPlayerBackgroundMode)backgroundMode;
- (NSTimeInterval)minimumPlayableDuration;
- (void)play;
- (void)pause;
- (void)stop;

@end


#endif /* SGPlayerDefines_h */