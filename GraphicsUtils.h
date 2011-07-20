//
//  GraphicsUtils.h
//
//  Created by Craig Hupin on 09/08/10.
//  Copyright 2010 Anuman Interactive. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

typedef struct 
{
	unsigned char a;
	unsigned char r;
	unsigned char g;
	unsigned char b;
	
}ARGB;

typedef struct 
{
	unsigned char a;
	unsigned char r;
	unsigned char g;
	unsigned char b;

}RGBA;

typedef enum
{
	Channel_None = 0x0,
	Channel_Grayscale = 0x1,
	Channel_Red = 0x2,
	Channel_Green = 0x4,
	Channel_Blue = 0x8,
	Channel_Alpha = 0x16,
	Channel_RGB = Channel_Red | Channel_Green | Channel_Blue,
	Channel_RGBA = Channel_Red | Channel_Green | Channel_Blue | Channel_Alpha
} Channel;

typedef enum
{
	Flip_Horizontally,
	Flip_Vertically, 
	Flip_90_Clockwise,
	Flip_90_CounterClockwise
}FlipMode;

@interface GraphicsUtils : NSObject 

//General purpose methods
+ (CGContextRef)newARGBBitmapDataContextWithWidth:(NSInteger)width Height:(NSInteger)height;
+ (CGContextRef)newRGBABitmapContextWithSize:(CGSize)imageSize;
+ (CGContextRef)newARGBBitmapContextWithSize:(CGSize)imageSize;
+ (CGContextRef)newARGBBitmapContextWithImage:(CGImageRef)image;

+ (UIImage*)newScaledImage:(UIImage*)image toFitHeight:(CGFloat)height;
+ (UIImage*)newScaledImage:(UIImage*)image WithXScale:(CGFloat)xScale YScale:(CGFloat)yScale;
+ (UIImage*)newScaledImage:(UIImage*)image WithWidth:(CGFloat)width Height:(CGFloat)height;
+ (UIImage*)scaledImage:(UIImage*)image WithWidth:(CGFloat)width Height:(CGFloat)height;
+ (UIImage*)newScaledImage:(UIImage*)image ToFitInWidth:(CGFloat)width Height:(CGFloat)height;
+ (UIImage*)newScaledImage:(UIImage*)image CenteredToFitInWidth:(CGFloat)width Height:(CGFloat)height;
+ (UIImage*)newColorizedImage:(UIImage*)image WithColor:(UIColor*)color;
+ (UIImage*)colorizedImage:(UIImage*)image WithColor:(UIColor*)colour;
+ (UIImage*)newPastedImage:(UIImage*)srcImage IntoImage:(UIImage*)destImage;

+ (UIImage*)newSobelEdgeDetectionOnImage:(UIImage*)image Threshold:(CGFloat)threshold;
+ (UIImage*)newSolidSobelEdgeDetectionOnImage:(UIImage*)image Threshold:(CGFloat)threshold;
+ (UIImage*)newBlackEdgeDetectionOnImage:(UIImage*)image;
+ (UIImage*)newEmbossOnImage:(UIImage*)image;
+ (UIImage*)newContrastBrightnessOnImage:(UIImage*)image Contrast:(CGFloat)contrast Brightness:(CGFloat)brightness;

+ (UIImage*)newBlurredImage:(UIImage*)image WithFactor:(CGFloat)factor;

+ (UIImage*)newMaskedImage:(UIImage*)image WithMask:(UIImage*)mask;

+ (UIImage*)newFlippedImage:(UIImage*)srcImage Mode:(FlipMode)mode;


+ (CGRect)rectDetectionWithImage:(UIImage*)image;

@end
