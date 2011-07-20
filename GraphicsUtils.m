//
//  GraphicsUtils.m
//
//  Created by Craig Hupin on 09/08/10.
//  Copyright 2010 Anuman Interactive. All rights reserved.
//

#import "GraphicsUtils.h"

@implementation GraphicsUtils

//! General purpose method used to created a scaled copy of an image
//!
//! @param xScale The X scale in the range [0;1]
//! @param yScale The Y scale in the range [0;1]
//! @return A retained image (the user is responsible for releasing it)
//! 
+ (UIImage*)newScaledImage:(UIImage*)image WithXScale:(CGFloat)xScale YScale:(CGFloat)yScale
{
	//Compute output dimensions
	CGFloat finalWidth = image.size.width * xScale;
	CGFloat finalHeight = image.size.height * yScale;
	
	return [GraphicsUtils newScaledImage:image WithWidth:finalWidth Height:finalHeight];
}

//! General purpose method used to created a scaled copy of an image which fits the specified area (the ratio is kept)
//!
//! @param width The maximum width of the image
//! @param height The maximum height of the image
//! @return A retained image with kept ratio (the user is responsible for releasing it)
//! 
+ (UIImage*)newScaledImage:(UIImage*)image ToFitInWidth:(CGFloat)width Height:(CGFloat)height
{
	//Compute fits
	CGFloat wWidth = width;
	CGFloat wHeight = (image.size.height/image.size.width)*wWidth;
	
	CGFloat hHeight = height;
	CGFloat hWidth = (image.size.width/image.size.height)*hHeight;	
	
	//Determine best fit
	CGFloat destWidth = MIN( wWidth, hWidth );
	CGFloat destHeight = MIN( wHeight, hHeight );
	
	return [GraphicsUtils newScaledImage:image WithWidth:destWidth Height:destHeight];	
}

//! General purpose method used to created a scaled copy of an image which is resized to fit within a specified area, and centered inside of it (the ratio is kept)
//!
//! @param width The maximum width of the area in which to display the image
//! @param height The maximum height of the area in which to display the image
//! @return A retained image with kept ratio (the user is responsible for releasing it)
//! 
+ (UIImage*)newScaledImage:(UIImage*)image CenteredToFitInWidth:(CGFloat)width Height:(CGFloat)height
{
	//Scale the image to fit in the area
	UIImage* scaledImage = [GraphicsUtils newScaledImage:image ToFitInWidth:width Height:height];
	
	//Fetch image dimensions
	CGFloat imageWidth = scaledImage.size.width;
	CGFloat imageHeight = scaledImage.size.height;
	
	//Create a context in which to draw the centered image
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithSize:CGSizeMake(width,height)];
	
	//Draw the image at the center of the area
	CGContextDrawImage(context, CGRectMake((width-imageWidth)/2.0f, (height-imageHeight)/2.0f, imageWidth, imageHeight), scaledImage.CGImage );
	
	//Fetch the newly create image
	CGImageRef centeredImageRef = CGBitmapContextCreateImage(context);
	UIImage* centeredImage = [[UIImage alloc] initWithCGImage:centeredImageRef];
	CGImageRelease(centeredImageRef);
	
	//Release unused resources
	CGContextRelease(context);
	[scaledImage release];
	
	//Return the centered image
	return centeredImage;
}

//! General purpose method used to created a scaled copy of an image
//!
//! @param width The desired width (in pixels)
//! @param height The desired height (in pixels)
//! @return A retained image (the user is responsible for releasing it)
//!
+ (UIImage*)newScaledImage:(UIImage*)image WithWidth:(CGFloat)width Height:(CGFloat)height
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	//Fetch context
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithSize:CGSizeMake(width,height)];	
	
	//Lower interpolation quality in the case of a magnification
	if( image.size.width > width && image.size.height > height )
		CGContextSetInterpolationQuality(context, kCGInterpolationDefault);
	else
		CGContextSetInterpolationQuality(context, kCGInterpolationLow);
	
	//Draw the scaled image in context and create the associated UIImage
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), image.CGImage);
	
	CGImageRef ref = CGBitmapContextCreateImage(context);
	UIImage* scaledImage = [[ UIImage alloc ] initWithCGImage:ref];
	CGImageRelease(ref);
	
	//Release context
	CGContextRelease(context);
	
	[pool release];
	pool = nil;
	
	//Return the rescaled image
	return scaledImage;	
}

+ (UIImage*)newScaledImage:(UIImage*)image toFitHeight:(CGFloat)height
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	int width = (image.size.width*height)/image.size.height;
	
	//Fetch context
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithSize:CGSizeMake(width,height)];	
	
	//Lower interpolation quality in the case of a magnification
	if( image.size.width > width && image.size.height > height )
		CGContextSetInterpolationQuality(context, kCGInterpolationDefault);
	else
		CGContextSetInterpolationQuality(context, kCGInterpolationLow);
	
	//Draw the scaled image in context and create the associated UIImage
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), image.CGImage);
	
	CGImageRef ref = CGBitmapContextCreateImage(context);
	UIImage* scaledImage = [[ UIImage alloc ] initWithCGImage:ref];
	CGImageRelease(ref);
	
	//Release context
	CGContextRelease(context);
	
	[pool release];
	pool = nil;
	
	//Return the rescaled image
	return scaledImage;	
}

+ (UIImage*)scaledImage:(UIImage*)image WithWidth:(CGFloat)width Height:(CGFloat)height
{	
	//Return the rescaled image
	return [[GraphicsUtils newScaledImage:image WithWidth:width Height:height] autorelease];
}


//! Main purpose method which creates an ARGB context compatible with the specified image 
//! (retains the same size, and colour space)
//!
//! @param image The source image to use as a basis (uses the same dimensions and colour space)
//! @return A retained context (the user is responsible for releasing it)
//!
+ (CGContextRef)newARGBBitmapContextWithImage:(CGImageRef)image
{
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;	
	int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(image);
	size_t pixelsHigh = CGImageGetHeight(image);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	// Use the generic RGB color space.
	colorSpace = CGImageGetColorSpace(image);
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL) 
	{
		fprintf (stderr, "Memory not allocated!");
		return NULL;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
	// per component. Regardless of what the source image format is 
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	return context;	
}

+ (CGContextRef)newRGBABitmapContextWithSize:(CGSize)imageSize
{
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	size_t pixelsWide = imageSize.width;
	size_t pixelsHigh = imageSize.height;
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// allocate the bitmap & create context
	bitmapData = malloc( bitmapByteCount );
	
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	RGBA* pixel = (RGBA*)bitmapData;
	unsigned int srcIndex = 0;
	for(unsigned int y = 0 ; y < pixelsHigh ; y++ )
	{
		for(unsigned int x = 0 ; x < pixelsWide ; x++ )
		{
			srcIndex = x + y * pixelsWide;
			pixel[srcIndex].r = 0;
			pixel[srcIndex].g = 0;
			pixel[srcIndex].b = 0;
			pixel[srcIndex].a = 0;
		}
	}
	
	context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8,
									 bitmapBytesPerRow, colorSpace,
									 kCGImageAlphaPremultipliedLast);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	CGColorSpaceRelease( colorSpace );
	return context;
}


//! Main purpose method which creates an ARGB context for drawing
//!
//! @param width The desired context width (in pixels)
//! @param height The desired context height (in pixels)
//! @return A retained context (the user is responsible for releasing it)
//!
+ (CGContextRef)newARGBBitmapContextWithSize:(CGSize)imageSize
{
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	size_t pixelsWide = imageSize.width;
	size_t pixelsHigh = imageSize.height;
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// allocate the bitmap & create context
	bitmapData = malloc( bitmapByteCount );
	
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	ARGB* pixel = (ARGB*)bitmapData;
	unsigned int srcIndex = 0;
	for(unsigned int y = 0 ; y < pixelsHigh ; y++ )
	{
		for(unsigned int x = 0 ; x < pixelsWide ; x++ )
		{
			srcIndex = x + y * pixelsWide;
			pixel[srcIndex].r = 0;
			pixel[srcIndex].g = 0;
			pixel[srcIndex].b = 0;
			pixel[srcIndex].a = 0;
		}
	}
	
	context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8,
									 bitmapBytesPerRow, colorSpace,
									 kCGImageAlphaPremultipliedFirst);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	CGColorSpaceRelease( colorSpace );
	return context;
}


//! Main purpose method which creates an ARGB context for drawing
//!
//! @param width The desired context width (in pixels)
//! @param height The desired context height (in pixels)
//! @return A retained context (the user is responsible for releasing it)
//!
+ (CGContextRef)newARGBBitmapDataContextWithWidth:(NSInteger)width Height:(NSInteger)height
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
	
	// Define bytes per row - here we have a 32-bit RGBA bitmap context
	NSInteger bitmapBytesPerRow = (width * 4);	
	NSInteger bitmapByteCount = bitmapBytesPerRow * height;
	
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }	
	
	// Create the bitmap context
	void* bitmapData = malloc( bitmapByteCount );
    context = CGBitmapContextCreate (bitmapData, width, height, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	
	if (context == NULL)
	{
        fprintf (stderr, "Context not created!");
		free(bitmapData);
	}
	
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );	
	
	return context;
}


//! Applies a colour filter to the specified image (mask-like : this method masks the colour in place rather 
//! than modulating it with the source image)
//!
//! @param image The source image to colorize
//! @param colour The desired colour
//! @return An autoreleased image (the user should retain the object if he/she wishes to keep it beyond the scope of its creation)
//!
+ (UIImage*)newColorizedImage:(UIImage*)image WithColor:(UIColor*)colour
{
	CGImageRef maskRef = image.CGImage; 
	
	NSInteger width = image.size.width;
	NSInteger height = image.size.height;
	
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithSize:CGSizeMake(width,height)];
	
	CGColorRef colourRef = [colour CGColor];
	const CGFloat* components = CGColorGetComponents(colourRef);	
	CGContextSetRGBFillColor(context, components[0], components[1], components[2], CGColorGetAlpha(colourRef));
	CGContextFillRect(context, CGRectMake(0, 0, width, height));
	
	CGImageRef baseColour = CGBitmapContextCreateImage(context);
	
	CGImageRef mask = CGImageMaskCreate(width, height, CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), NULL, false);
	CGImageRef masked = CGImageCreateWithMask(baseColour, mask);
	
	UIImage* newImage = [[UIImage alloc] initWithCGImage:masked];
	
	CGImageRelease(masked);
	CGImageRelease(baseColour);
	CGImageRelease(mask);
	
	CGContextRelease(context);
	
	return newImage;
}

+ (UIImage*)colorizedImage:(UIImage*)image WithColor:(UIColor*)colour
{
	return [[GraphicsUtils newColorizedImage:image WithColor:colour] autorelease];//newImage;
}

//! Pastes an image (source) into another one (destination)
//! (Handles alpha)
//!
//! @param srcImage The source image (front image)
//! @param destImage The destination image (background image)
//! @return A retained image (the user is responsible for releasing the image after use)
//!
+ (UIImage*)newPastedImage:(UIImage*)srcImage IntoImage:(UIImage*)destImage
{
	//Begin drawing
	UIGraphicsBeginImageContext( CGSizeMake(destImage.size.width,destImage.size.height) );
	
	CGImageRef srcRef = srcImage.CGImage;
	CGImageRef destRef = destImage.CGImage;
	
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithSize:CGSizeMake(destImage.size.width,destImage.size.height)];
	
	//Render source image
	CGContextDrawImage(context, CGRectMake(0, 0, destImage.size.width, destImage.size.height), destRef);
	
	//Render secondary image
	CGContextDrawImage(context, CGRectMake(0, 0, srcImage.size.width, srcImage.size.height), srcRef);
	
	CGImageRef finalRef = CGBitmapContextCreateImage(context);	
	UIImage* finalImage = [[UIImage alloc] initWithCGImage:finalRef];
	CGImageRelease(finalRef);
	
	CGContextRelease(context);
	
	UIGraphicsEndImageContext();
	
	return finalImage;
}

//! Flips the image around the given axis
//!
//! @param srcImage The source image
//! @param mode The flipping mode (either Flip_Horizontally or Flip_Vertically)
//! @return A retained image (the user is responsible for releasing it)
//!
+ (UIImage*)newFlippedImage:(UIImage*)srcImage Mode:(FlipMode)mode
{
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithSize:CGSizeMake(srcImage.size.width,srcImage.size.height)];
	
	//Flip the context according to the desired mode
	switch( mode )
	{
		case Flip_Vertically :
			CGContextTranslateCTM(context, 0, srcImage.size.height);
			CGContextScaleCTM(context, 1, -1);	
			break;
			
		case Flip_Horizontally :
			CGContextTranslateCTM(context, srcImage.size.width, 0);
			CGContextScaleCTM(context, -1, 1);		
			break;
			
		case Flip_90_Clockwise :
			CGContextTranslateCTM(context, srcImage.size.width/2.0f, srcImage.size.height/2.0f);
			CGContextRotateCTM(context, -1.57f);
			CGContextTranslateCTM(context, -srcImage.size.height/2.0f, -srcImage.size.width/2.0f);
			break;
			
		case Flip_90_CounterClockwise:
			CGContextTranslateCTM(context, srcImage.size.width/2.0f, srcImage.size.height/2.0f);
			CGContextRotateCTM(context, 1.57f);
			CGContextTranslateCTM(context, -srcImage.size.height/2.0f, -srcImage.size.width/2.0f);
			break;
	}
	
	//Draw the image in the flipped context
	CGContextDrawImage(context, CGRectMake(0, 0, srcImage.size.width, srcImage.size.height), srcImage.CGImage);
	
	//Fetch image ref and create destination image
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage* destImage = [[UIImage alloc] initWithCGImage:imageRef];
	
	//Release unused resources
	CGImageRelease(imageRef);
	CGContextRelease(context);
	
	//Return the retained image
	return destImage;
}

//! Applies an edge detection algorithm (Sobel algorithm) to extract the outlines from a given image
//!
//! @param image The source image
//! @param threshold The threshold value which determines how likely edges are to be detected ( 0 : very likely, 1 : less likely - default )
//! @return A retained image (the user is responsible for releasing it)
//!
+ (UIImage*)newSobelEdgeDetectionOnImage:(UIImage*)image Threshold:(CGFloat)threshold
{
	NSInteger width = image.size.width;
    NSInteger height = image.size.height;
	NSInteger srcIndex = 0;
	NSInteger srcIndex2 = 0;
	NSInteger sumX = 0;
	NSInteger sumY = 0;
	NSInteger sum = 0;
	
	//Create the bitmap context
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithImage:image.CGImage];
	
	//Render the source image
    CGContextDrawImage(context, CGRectMake(0,0,width,height), image.CGImage); 
	
	//Initialize matrices (Sobel operators)
	NSInteger GX[3][3] = { {-1.0f ,0.0f, 1.0f},
		{-2.0f ,0.0f, 2.0f},
		{-1.0f ,0.0f, 1.0f} }; 	
	
	NSInteger GY[3][3] = { { 1.0f , 2.0f, 1.0f},
		{ 0.0f , 0.0f, 0.0f},
		{-1.0f ,-2.0f, -1.0f} };
	
	//Initialize the temporary pixel matrix
	NSInteger temp[3][3];
	
	//Initialize the arrays	
	RGBA* filteredImage = malloc( sizeof(RGBA) * width * height );
	
	// Fetch the pixel data
    void *data = CGBitmapContextGetData (context);
	RGBA* pixel = (RGBA*)data;
	
    if (data != NULL)
    {
		//Perform sobel algorithm		
		for(unsigned int y = 0 ; y < height ; y++ )
		{
			for(unsigned int x = 0 ; x < width ; x++ )
			{
				srcIndex = x + y * width;
				
				if( y == 0 || y == height-1 || x == 0 || x == width-1 )
					sum = 0;
				else
				{
					//Build pixel matrix					
					for(int j = -1 ; j <= 1 ; j++ )
					{
						for(int i = -1 ; i <= 1 ; i++ )
						{
							srcIndex2 = (x + i) + (y + j) * width;
							temp[i+1][j+1] = ( pixel[srcIndex2].r + pixel[srcIndex2].g + pixel[srcIndex2].b ) / 3;	
						}
					}
					
					//Apply GX filter
					sumX = ( temp[0][0] * GX[0][0] ) + ( temp[1][0] * GX[1][0] ) + ( temp[2][0] * GX[2][0] ) + ( temp[0][1] * GX[0][1] ) + ( temp[1][1] * GX[1][1] ) + ( temp[2][1] * GX[2][1] ) + ( temp[0][2] * GX[0][2] ) + ( temp[1][2] * GX[1][2] ) + ( temp[2][2] * GX[2][2] );		
					
					//Apply GY filter
					sumY = ( temp[0][0] * GY[0][0] ) + ( temp[1][0] * GY[1][0] ) + ( temp[2][0] * GY[2][0] ) + ( temp[0][1] * GY[0][1] ) + ( temp[1][1] * GY[1][1] ) + ( temp[2][1] * GY[2][1] ) + ( temp[0][2] * GY[0][2] ) + ( temp[1][2] * GY[1][2] ) + ( temp[2][2] * GY[2][2] );		
					
					//Compute gradient (using the square root is actually faster than the absolute version)
					sum = ABS(sumX) + ABS(sumY);//sqrt( sumX*sumX + sumY*sumY );
					
					//Clamp sum
					if(sum > 255 * threshold) 
						sum=255;
					if(sum < 0) 
						sum=0;
				}				
				
				filteredImage[srcIndex].r = ABS(255 - sum);		
				filteredImage[srcIndex].g = filteredImage[srcIndex].r;
				filteredImage[srcIndex].b = filteredImage[srcIndex].r;	
				filteredImage[srcIndex].a = 255;
			}
		}	
	}
	
	//Copy filtered image back into the context
	for(unsigned int y = 0 ; y < height ; y++ )
	{
		for(unsigned int x = 0 ; x < width ; x++ )
		{
			srcIndex = x + (y * width);
			memcpy(&pixel[srcIndex], &filteredImage[srcIndex], sizeof( RGBA ) );
		}
	}
	
	//Create the image
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage* stenciledImage = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	if( data != NULL )
		free(data);
	
	//Release unused resources
	CGContextRelease(context);
	free(filteredImage);
	
	//Finally, return the image
	return stenciledImage;
}

//! Applies an edge detection algorithm (Sobel algorithm) to extract the outlines from a given image
//!	Similar to the other sobel edge detection method expect it will also fill the outlines with black
//!
//! @param image The source image
//! @param threshold The threshold value which determines how likely edges are to be detected ( 0 : very likely, 1 : less likely - default )
//! @return A retained image (the user is responsible for releasing it)
//!
+ (UIImage*)newSolidSobelEdgeDetectionOnImage:(UIImage*)image Threshold:(CGFloat)threshold
{
	unsigned int width = image.size.width;
    unsigned int height = image.size.height;
	unsigned int srcIndex = 0;
	unsigned int srcIndex2 = 0;
	int sumX = 0;
	int sumY = 0;
	int sum = 0;
	int computedThreshold = 255 * threshold;
	
	//Create the bitmap context
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithImage:image.CGImage];
	
	//Render the source image
    CGContextDrawImage(context, CGRectMake(0,0,width,height), image.CGImage); 
	
	//Initialize matrices (Sobel operators)
	NSInteger GX[3][3] = { {-1 ,0, 1},
		{-2 ,0, 2},
		{-1 ,0, 1} }; 	
	
	NSInteger GY[3][3] = { { 1 , 2, 1},
		{ 0 , 0, 0},
		{-1 ,-2,-1} }; 
	
	//Initialize the temporary pixel matrix
	unsigned char temp[3][3];
	
	//Initialize the arrays	
	RGBA* filteredImage = malloc( sizeof(RGBA) * width * height );
	
	// Fetch the pixel data
    void *data = CGBitmapContextGetData (context);
	RGBA* pixel = (RGBA*)data;
	
    if (data != NULL)
    {
		//NSTimeInterval start3 = [NSDate timeIntervalSinceReferenceDate];
		
		//Perform sobel algorithm		
		for(unsigned int y = 0 ; y < height ; y++ )
		{
			for(unsigned int x = 0 ; x < width ; x++ ) //REQ OPTIMIZATION
			{
				if( y == 0 || y == height-1 || x == 0 || x == width-1 ) //REQ OPTIMIZATION
					sum = 0;
				else
				{
					//Build pixel matrix					
					for(int j = -1 ; j <= 1 ; j++ )
					{
						for(int i = -1 ; i <= 1 ; i++ )
						{
							srcIndex2 = (x + i) + (y + j) * width;
							
							//Optimized version, add the alpha channel, and divide by 4 (bitshift twice)
							temp[i+1][j+1] = pixel[srcIndex2].r + pixel[srcIndex2].g + pixel[srcIndex2].b;		//( pixel[srcIndex2].r + pixel[srcIndex2].g + pixel[srcIndex2].b + 255 ) >> 2;											  
						}
					}					
					
					//Apply GX filter
					sumX = ( temp[0][0] * GX[0][0] ) + ( temp[1][0] * GX[1][0] ) + ( temp[2][0] * GX[2][0] ) + ( temp[0][1] * GX[0][1] ) + ( temp[1][1] * GX[1][1] ) + ( temp[2][1] * GX[2][1] ) + ( temp[0][2] * GX[0][2] ) + ( temp[1][2] * GX[1][2] ) + ( temp[2][2] * GX[2][2] );		
					
					//Apply GY filter
					sumY = ( temp[0][0] * GY[0][0] ) + ( temp[1][0] * GY[1][0] ) + ( temp[2][0] * GY[2][0] ) + ( temp[0][1] * GY[0][1] ) + ( temp[1][1] * GY[1][1] ) + ( temp[2][1] * GY[2][1] ) + ( temp[0][2] * GY[0][2] ) + ( temp[1][2] * GY[1][2] ) + ( temp[2][2] * GY[2][2] );		
					
					//Compute gradient (using the square root is actually faster than the absolute version)
					sum = ABS(sumX/3) + ABS(sumY/3);//sqrt( sumX*sumX + sumY*sumY );
					
					//Clamp sum
					if(sum > computedThreshold) //REQ OPTIMIZATION
						sum=255;
					if(sum < 0) 
						sum=0;
				}				
				
				srcIndex = x + y * width;
				filteredImage[srcIndex].r = ABS(255 - sum);		
				filteredImage[srcIndex].g = filteredImage[srcIndex].r;
				filteredImage[srcIndex].b = filteredImage[srcIndex].r;	
				filteredImage[srcIndex].a = 255;
			}
		}	
		
		//NSTimeInterval duration3 = [NSDate timeIntervalSinceReferenceDate] - start3;
		//NSLog(@"sobel - Computing sobel : %f", duration3);
		
		//Copy filtered image back into the context
		for(unsigned int y = 0 ; y < height ; y++ )
		{
			for(unsigned int x = 0 ; x < width ; x++ )
			{
				srcIndex = x + (y * width);			
				
				//if( pixel[srcIndex].r > 140 && filteredImage[srcIndex].r > 0 )//
				if( (pixel[srcIndex].r + pixel[srcIndex].g + pixel[srcIndex].b ) / 3 > 140 && filteredImage[srcIndex].r > 0 )
					memcpy(&pixel[srcIndex], &filteredImage[srcIndex], sizeof( RGBA ) );
				else
				{
					pixel[srcIndex].r = 0;
					pixel[srcIndex].g = 0;
					pixel[srcIndex].b = 0;
					pixel[srcIndex].a = 255;
				}
			}
		}
	}
	
	//Create the image
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage* stenciledImage = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	if( data != NULL )
		free(data);	
	
	//Release unused resources
	CGContextRelease(context);
	free(filteredImage);
	
	//Finally, return the image
	return stenciledImage;
}

+ (UIImage*)newEmbossOnImage:(UIImage*)image
{
	NSInteger width = image.size.width;
    NSInteger height = image.size.height;
	NSInteger srcIndex = 0;
	NSInteger srcIndex2 = 0;
	NSInteger sumX = 0;
	NSInteger sum = 0;
	
	//Create the bitmap context
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithImage:image.CGImage];
	
	//Render the source image
    CGContextDrawImage(context, CGRectMake(0,0,width,height), image.CGImage); 
	
	//Initialize matrices (Sobel operators)
	NSInteger GX[3][3] = { {2 ,0 , 0},
		{0 ,-1, 0},
		{0 ,0, -1} };	
	
	//Comput normalizingFactor
	CGFloat normalizingFactor = 0;
	for(unsigned int j = 0 ; j < 3 ; j++ )
		for(unsigned int i = 0 ; i < 3 ; i++ )
			normalizingFactor += GX[i][j];
	
	if( normalizingFactor == 0 )
		normalizingFactor = 1.0f;
	else
		normalizingFactor = 1.0f/normalizingFactor;
	
	//Initialize the temporary pixel matrix
	NSInteger temp[3][3];
	
	//Initialize the arrays	
	RGBA* filteredImage = malloc( sizeof(RGBA) * width * height );
	
	// Fetch the pixel data
    void *data = CGBitmapContextGetData (context);
	RGBA* pixel = (RGBA*)data;
	
    if (data != NULL)
    {
		//Perform sobel algorithm		
		for(unsigned int y = 0 ; y < height ; y++ )
		{
			for(unsigned int x = 0 ; x < width ; x++ )
			{
				srcIndex = x + y * width;
				
				if( y == 0 || y == height-1 || x == 0 || x == width-1 )
					sum = 0;
				else
				{
					//Build pixel matrix					
					for(int j = -1 ; j <= 1 ; j++ )
					{
						for(int i = -1 ; i <= 1 ; i++ )
						{
							srcIndex2 = (x + i) + (y + j) * width;
							temp[i+1][j+1] = ( pixel[srcIndex2].r + pixel[srcIndex2].g + pixel[srcIndex2].b ) / 3;	
						}
					}
					
					//Apply GX filter
					sumX = ( temp[0][0] * GX[0][0] ) + ( temp[1][0] * GX[1][0] ) + ( temp[2][0] * GX[2][0] ) + ( temp[0][1] * GX[0][1] ) + ( temp[1][1] * GX[1][1] ) + ( temp[2][1] * GX[2][1] ) + ( temp[0][2] * GX[0][2] ) + ( temp[1][2] * GX[1][2] ) + ( temp[2][2] * GX[2][2] );		
					
					//Apply GY filter
					//sumY = ( temp[0][0] * GY[0][0] ) + ( temp[1][0] * GY[1][0] ) + ( temp[2][0] * GY[2][0] ) + ( temp[0][1] * GY[0][1] ) + ( temp[1][1] * GY[1][1] ) + ( temp[2][1] * GY[2][1] ) + ( temp[0][2] * GY[0][2] ) + ( temp[1][2] * GY[1][2] ) + ( temp[2][2] * GY[2][2] );		
					
					//Compute gradient (using the square root is actually faster than the absolute version)
					sum = sumX; //+ ABS(sumY);//sqrt( sumX*sumX + sumY*sumY );
					sum += 128;
					
					//Clamp sum
					if(sum > 255) 
						sum=255;
					if(sum < 0) 
						sum=0;
				}				
				
				filteredImage[srcIndex].r = normalizingFactor * sum;		
				filteredImage[srcIndex].g = filteredImage[srcIndex].r;
				filteredImage[srcIndex].b = filteredImage[srcIndex].r;	
				filteredImage[srcIndex].a = 255;
			}
		}	
	}
	
	//Copy filtered image back into the context
	for(unsigned int y = 0 ; y < height ; y++ )
	{
		for(unsigned int x = 0 ; x < width ; x++ )
		{
			srcIndex = x + (y * width);
			memcpy(&pixel[srcIndex], &filteredImage[srcIndex], sizeof( RGBA ) );
		}
	}
	
	//Create the image
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage* stenciledImage = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	if( data != NULL )
		free(data);
	
	//Release unused resources
	CGContextRelease(context);
	free(filteredImage);
	
	//Finally, return the image
	return stenciledImage;
}

+ (UIImage*)newBlackEdgeDetectionOnImage:(UIImage*)image 
{
	
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithImage:image.CGImage];
	if (context == NULL) return NULL;
	
	int height = (int) image.size.height;
	int width = (int) image.size.width;
	
	
	CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
	
	CGContextDrawImage(context, rect, image.CGImage);
	
	void *data = CGBitmapContextGetData (context);
	
	RGBA* filteredImage = malloc( sizeof(RGBA) * width * height );
	RGBA* pixel = (RGBA*)data;
	
	int tolerance = 15;
	int limit = 250;
	int srcIndex = 0;
	int dif;
	int absR;
	int absG;
	int absB;
	
	for(unsigned int y = 0 ; y < height ; y++ )
	{
		for(unsigned int x = 0 ; x < width ; x++ )
		{
			srcIndex = x + y * width;
			
			dif = (pixel[srcIndex].r + pixel[srcIndex].g + pixel[srcIndex].b)/3.0;
			absR = abs(pixel[srcIndex].r - dif);
			absG = abs(pixel[srcIndex].g - dif);
			absB = abs(pixel[srcIndex].b - dif);
			
			if (absR < tolerance && absG < tolerance && absB < tolerance && dif < limit) {
				filteredImage[srcIndex].r = dif;//pixel[srcIndex].r;		
				filteredImage[srcIndex].g = dif;//pixel[srcIndex].g;
				filteredImage[srcIndex].b = dif;//pixel[srcIndex].b;	
				filteredImage[srcIndex].a = 255;
			} else {
				filteredImage[srcIndex].r = 255;		
				filteredImage[srcIndex].g = 255;
				filteredImage[srcIndex].b = 255;	
				filteredImage[srcIndex].a = 255;
			}
		}
	}
	
	//Copy filtered image back into the context
	for(unsigned int y = 0 ; y < height ; y++ )
	{
		for(unsigned int x = 0 ; x < width ; x++ )
		{
			srcIndex = x + (y * width);
			memcpy(&pixel[srcIndex], &filteredImage[srcIndex], sizeof( RGBA ) );
		}
	}
	
	//Create the image
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage* stenciledImage = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	if( data != NULL )
		free(data);
	
	//Release unused resources
	CGContextRelease(context);
	free(filteredImage);
	
	return stenciledImage;
}

//! Adjusts the contrast and brightness of an image 
//!
//! @param image The source image
//! @param contrast The contrast amount ( in the range [-1;1] - 0 is the default value )
//! @param brightness The brightness amount (in the range [-1;1] - 0 is the default value )
//! @return A retained image (the user is responsible for releasing it)
//!
+ (UIImage*)newContrastBrightnessOnImage:(UIImage*)image Contrast:(CGFloat)contrast Brightness:(CGFloat)brightness;
{
	NSInteger width = image.size.width;
    NSInteger height = image.size.height;
	NSInteger srcIndex = 0;
	NSInteger red = 0;
	NSInteger green = 0;
	NSInteger blue = 0;
	NSInteger offset = 255*0.5f;
	
	//Translate values into [0;255];
	brightness *= 255;	
	
	CGFloat computedContrast = (1.0f+contrast);
	CGFloat computedContrastBrightness = (offset * contrast) + brightness;
	
	//Create the bitmap context
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithImage:image.CGImage];
	
	//Render the source image
    CGContextDrawImage(context, CGRectMake(0,0,width,height), image.CGImage); 
	
	// Fetch the pixel data
    void *data = CGBitmapContextGetData (context);
	RGBA* pixel = (RGBA*)data;
	
    if (data != NULL)
    {
		//Copy filtered image back into the context
		for(unsigned int y = 0 ; y < height ; y++ )
		{
			for(unsigned int x = 0 ; x < width ; x++ )
			{
				srcIndex = x + (y * width);
				
				//Compute brightness and contrast
				red = ((pixel[srcIndex].r)*computedContrast) - computedContrastBrightness;//((pixel[srcIndex].r)*(1.0f+contrast)) - (offset * contrast) + brightness;
				green = ((pixel[srcIndex].g)*computedContrast) - computedContrastBrightness;//((pixel[srcIndex].g)*(1.0f+contrast)) - (offset * contrast) + brightness;
				blue = ((pixel[srcIndex].b)*computedContrast) - computedContrastBrightness;//((pixel[srcIndex].b)*(1.0f+contrast)) - (offset * contrast) + brightness;
				
				//Clamp values
				if( red > 255 )
					red = 255;
				else if( red < 0 )
					red = 0;
				
				if( green > 255 )
					green = 255;
				else if( green < 0 )
					green = 0;
				
				if( blue > 255 )
					blue = 255;
				else if( blue < 0 )
					blue = 0;
				
				//Apply values
				pixel[srcIndex].r = red ;
				pixel[srcIndex].g = green;
				pixel[srcIndex].b = blue;	
			}
		}		
	}
	
	//Create the image
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage* contrastedImage = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	if( data != NULL )
		free(data);
	
	//Release unused resources
	CGContextRelease(context);
	
	//Finally, return the image
	return contrastedImage;	
}

//! Blurs out an image by the given factor
//!
//! @param image The source image
//! @param factor The blurring factor ( 2, 4, etc. )
//! @return A retained image (the user is responsible for releasing it)
//!
+ (UIImage*)newBlurredImage:(UIImage*)image WithFactor:(CGFloat)factor
{
	CGFloat width = image.size.width / factor;
	CGFloat height = image.size.height / factor;
	
	//Render the image in the desired blurring mode
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithSize:CGSizeMake(width,height)];
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	
	CGContextRelease(context);
	
	//Now render the scaled image again with the default size
	
	CGContextRef defaultContext = [GraphicsUtils newARGBBitmapContextWithSize:CGSizeMake(image.size.width,image.size.height)];
	
	CGContextDrawImage(defaultContext, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
	CGImageRelease(imageRef);
	
	CGImageRef defaultImageRef = CGBitmapContextCreateImage(context);
	UIImage* outputImage = [[UIImage alloc] initWithCGImage:defaultImageRef];
	CGImageRelease(defaultImageRef);
	
	CGContextRelease(defaultContext);
	
	//Finally, return the image
	return outputImage;
}

//! Masks out an image given a mask image (black is full opacity - white is transparent )
//!
//! @param image The source image
//! @param mask The mask image (typically, in grey scale )
//! @return A retained image (the user is responsible for releasing it)
//!
+ (UIImage*)newMaskedImage:(UIImage*)image WithMask:(UIImage*)mask
{
	//NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
	
	NSInteger mapSize = MAX( image.size.width, image.size.height );
	UIImage* resizedMask = [GraphicsUtils newScaledImage:mask WithWidth:mapSize Height:mapSize];
	
	CGImageRef maskRef = CGImageMaskCreate( (NSInteger)resizedMask.size.width, (NSInteger)resizedMask.size.height, CGImageGetBitsPerComponent(resizedMask.CGImage), CGImageGetBitsPerPixel(resizedMask.CGImage), CGImageGetBytesPerRow(resizedMask.CGImage), CGImageGetDataProvider(resizedMask.CGImage), CGImageGetDecode(resizedMask.CGImage), false);
	CGImageRef maskedImageRef = CGImageCreateWithMask(image.CGImage, maskRef);
	
	[resizedMask release];
	
	UIImage* maskedImage = [[UIImage alloc] initWithCGImage:maskedImageRef];
	
	//Release unused resources
	CGImageRelease(maskRef);
	CGImageRelease(maskedImageRef);
	
	//Finally, return the image
	return maskedImage;
}


+ (CGRect)rectDetectionWithImage:(UIImage*)image
{
	
	float scale = image.scale;
	
	int height = (int) image.size.height * scale;
	int width =  (int) image.size.width  * scale;
	
	CGContextRef context = [GraphicsUtils newARGBBitmapContextWithSize:CGSizeMake(width, height)];
	
	if (context == NULL) 
	{
		return CGRectZero;
	}
	
	CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
	
	CGContextDrawImage(context, rect, image.CGImage);
	
	
	void *data = CGBitmapContextGetData (context);
	
	RGBA* pixel = (RGBA*)data;
	unsigned int y = 0 ;
	unsigned int srcIndex = 0;
	unsigned int beginY = height, beginX = width, endY = 0, endX = 0;
	
	while ( y < height)
	{
		unsigned int x = 0 ;
		while ( x < width)
		{
			srcIndex = x + (y * width);
			
			if (pixel[srcIndex].a > 0) {
				if (y < beginY) {
					beginY = y;
				}
				if (y > endY) {
					endY = y;
				}
				if (x < beginX) {
					beginX = x;
				}
				if (x > endX) {
					endX = x;
				}
			} 
			x++;
		}
		y++;
	}
	
	if( data != NULL )
		free(data);
	
	//Release unused resources
	CGContextRelease(context);
	return CGRectMake(beginX, beginY, endX-beginX+1, endY-beginY+1);
}


@end
