/*
 *  SliderHeader.h
 *  testslider
 *
 *  Created by Jean-Pascal Coutris on 22/07/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

struct PageIndex {
	uint index1;
	uint index2;
};
typedef struct PageIndex PageIndex;

CG_INLINE PageIndex
PageIndexMake(uint index1, uint index2)
{
	PageIndex page; page.index1 = index1; page.index2 = index2; return page;
}
