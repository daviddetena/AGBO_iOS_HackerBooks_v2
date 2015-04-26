//
//  DTCAsyncImage.h
//  HackerBooks_v2
//
//  Created by David de Tena on 25/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//
//  This class acts as a wrapper to download a remote image
//  in background while a local image is displayed.
//  When the new image is downloaded we inform our delegate
//  with a method of a custom protocol and send a notification
//  through the Notification Center
//

#define IMAGE_DID_CHANGE_NOTIFICATION @"DTCAsyncImageImageDidChange"
#define IMAGE_CHANGE_KEY @"newImageKey"

@import Foundation;
@import UIKit;
@class DTCAsyncImage;

@protocol DTCAsyncImageDelegate <NSObject>

-(void) asyncImageDidChange:(DTCAsyncImage *) anImage;

@end


@interface DTCAsyncImage : NSObject

#pragma mark - Properties
//@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSData *imageData;
// Delegate
@property (weak,nonatomic) id<DTCAsyncImageDelegate> delegate;

#pragma mark - Factory init
+(instancetype) asyncImageWithURL:(NSURL *) url
                     defaultImage:(UIImage *) image;

#pragma mark - Instance init
-(id) initWithURL:(NSURL *) url
     defaultImage:(UIImage *) image;

@end
