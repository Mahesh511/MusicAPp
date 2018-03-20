//
//  ViewController.h
//  AudioAndVideoApplication
//
//  Created by Jayasimha on 24/09/16.
//  Copyright © 2016 Jayasimha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController<MPMediaPickerControllerDelegate>
{
    
    MPMusicPlayerController *musicPlayer;
    NSMutableArray *arrSongImages,*arrSongNames;
    
    
}

@property (weak,nonatomic) IBOutlet UIView *musicPlayerView;

@property (weak,nonatomic) IBOutlet UIImageView *songImage;
@property (weak,nonatomic) IBOutlet UILabel *songName;
@property (weak,nonatomic) IBOutlet UILabel *artistName;
@property (weak,nonatomic) IBOutlet UILabel *albumname;

@property (weak,nonatomic) IBOutlet UIButton *playButton;
@property (weak,nonatomic) IBOutlet UIButton *forWardButton;
@property (weak,nonatomic) IBOutlet UIButton *backWardButton;
@property (weak,nonatomic) IBOutlet UIButton *muteButton;

@property (weak,nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak,nonatomic) IBOutlet UISlider *seekBar;



@end

