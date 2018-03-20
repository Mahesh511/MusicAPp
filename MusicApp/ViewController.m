//
//  ViewController.m
//  AudioAndVideoApplication
//
//  Created by Jayasimha on 24/09/16.
//  Copyright © 2016 Jayasimha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize musicPlayerView,songImage,songName,artistName,albumname,playButton,forWardButton,backWardButton,volumeSlider,seekBar,muteButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    musicPlayer=[[MPMusicPlayerController alloc]init];
    
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    
    picker.delegate                     = self;
    picker.allowsPickingMultipleItems   = YES;
    picker.prompt                       = NSLocalizedString (@"Select any song from the list", @"Prompt to user to choose some songs to play");
    
    [self presentViewController:picker animated:YES completion:nil];
    
    arrSongNames=[[NSMutableArray alloc]init];
    arrSongImages=[[NSMutableArray alloc]init];
    
    
}

- (void)handle_NowPlayingItemChanged: (id) notification
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork)
    {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    
    [songImage setImage:artworkImage];

    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString)
    {
        songName.text = [NSString stringWithFormat:@"Title: %@",titleString];
    }
    else
    {
        songName.text = @"Title: Unknown title";
    }

    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString)
    {
        artistName.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    }
    else
    {
        artistName.text = @"Artist: Unknown artist";
    }

    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString)
    {
        albumname.text = [NSString stringWithFormat:@"Album: %@",albumString];
    }
    else
    {
        albumname.text = @"Album: Unknown album";
    }
   [self updateTime];
}
- (void)handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused)
    {
        [playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        
    }
    else if (playbackState == MPMusicPlaybackStatePlaying)
    {
        [playButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        
    }
    else if (playbackState == MPMusicPlaybackStateStopped)
    {
        
        [playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        [musicPlayer stop];
        
    }
    
}


- (IBAction)seekBarClicked
{
    [musicPlayer setCurrentPlaybackTime: [seekBar value]];
    
    [self updateTime];
}

- (void)updateTime
{
    seekBar.value = musicPlayer.currentPlaybackTime;
    seekBar.minimumValue = 0;
    
    NSNumber *duration = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    float totalTime = [duration floatValue];
    
    seekBar.maximumValue = totalTime;
    
   
}
-(IBAction)muteButton:(id)sender
{
    [musicPlayer setVolume:0.0];
    
    [self mute];
    
}
-(void)mute
{
    if ([musicPlayer volume]==0.0)
    {
        [muteButton setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
    }
    else
    {
        [muteButton setImage:[UIImage imageNamed:@"Volume"] forState:UIControlStateNormal];
    }
}
- (void)handle_VolumeChanged:(id) notification
{
    [volumeSlider setValue:[musicPlayer volume]];

}
- (IBAction)volumeChanged:(id)sender
{
   
    [musicPlayer setVolume:[volumeSlider value]];
    [self mute];
}
- (IBAction)playPause:(id)sender
{
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
    {
        [musicPlayer pause];
        
    }
    else
    {
        [musicPlayer play];
        
    }
}
- (IBAction)previousSong:(id)sender
{
    [musicPlayer skipToPreviousItem];
}
- (IBAction)nextSong:(id)sender
{
    [musicPlayer skipToNextItem];
}


#pragma UIMediapickerDelegate
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection)
    {
        
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [musicPlayer play];
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
   [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    
    
    [musicPlayer beginGeneratingPlaybackNotifications];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object: musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object: musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerVolumeDidChangeNotification
                                                  object: musicPlayer];
    
    
    [musicPlayer endGeneratingPlaybackNotifications];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

