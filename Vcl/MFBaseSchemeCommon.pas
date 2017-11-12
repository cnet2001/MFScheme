{*******************************************************************************

��Ŀ���� :ThinkWide������
��Ȩ���� (c) 2005 ThinkWide
+-------------------------------------------------------------------------------
��Ŀ:


�汾: 1


��������:2005-1-5 19:02:09


����: �³�

+-------------------------------------------------------------------------------
����:

����:   -2005-1-5 19:02:09  ������˼
	Ŀ�� 1) ʵ�ֿ�Ƭʽ   ���̿��ƻ�����  (����ʵ��)
	     2) ʵ�ָ���ͼʽ ���̿��ƻ�����  (�Ժ�ʵ��)
	     3) ��Windows VCL ���ʵ��
	     4) ʵ�����ܻ����Ÿ��㷨

	-2005-1-7  ��д  TGraphScrollBar  ��
	-2005-1-10 ���  TGraphScrollBar  �� 
	-2005-1-20 ��д  TPlanCrockCenter �� �Ÿ׽���ʵ����
	-2005-2-8  ���  TPlanCrockCenter ��
	-2005-2-9  ��д  TMFMacList,TMFCard �Ÿ׿�����
	����:�����̴��붼���Լ�ʵ�ֵ�û�������κε���������ʹ���

�ع�:   -2006-6-10     �ع��� �Լ� ���ϵ



ToDo:

*******************************************************************************}


unit MFBaseSchemeCommon;

interface

uses
  Windows, Messages, SysUtils, Classes,Graphics;
type
  TRangePath=array of TPoint;

  TRegisteredType=(rgtDefault,rgtDB);

  TViewType=(tvText,tvColor,tvBackColor,tvDateTime);

  TPlaceType=(ptAutoLine,ptAfter,ptPlace);

  TNodeType=(tnpItem,tnpFolder);

  TSpreadType = (sAuto,sFix);

  TCaptionPosition = (cpCenter,cpRight,cpLeft);

  TPercentPosition=(ppCenter,ppTop,ppBottom,ppAll);

  TPercentColorType=(pctAuto,pctUser);

  TItemFontColorType=(fctAuto,fctUser);

  TItemTimeChangeType=(tctBegin,tctInterval);

  TMFSchemeShapeType=(stNone,stPolygonUp,stPolygonDown,stRotundity,stTriangleUp,stTriangleDown,stDiamond);

  TSchemeFeildType=(tfpNone,tfpBegin,tfpEnd,tfpInterval,tfpBackColor,tfpPercent,tfpText);

  TMFSchemeTreeNotify = (tnAdd, tnDelete, tnVisible, tnLevel, tnExpand, tnData,
    tnSync, tnMove, tnSelect,tnCollapse,tnHeight,tnHide,tnChange,tnCaption,
    tnColor,tnPercent,tnCaptionPosition,tnSharp,tnImageIndex);

  TDataItemType = (iParent,iChild);

  TNodeMoveType=(nmtAdd, nmtAddFirst, nmtAddChild, nmtAddChildFirst, nmtInsert);

  TItemMoveType=(imtAdd, imtAddFirst,imtInsert);

  TAdjustMoveType=(amtDefault,amtStand,amtAfterItem,amtTouchMove,
    amtAfterItemTouchMove,amtAfterItemAll,amtTouchMoveAll);

  TEventType =(eNode,eItem,eItemLink);


  TMFHitType=(pNone,pContent,pNodePlus,pTreeRight,pIndicateTop,pIndicateBottom,
    pItemTop,pItemBottom,pItemLeft,pItemRight,pItem);

  THintType=(htText,htImage,htDrag);

  TMouseType=(mtDown,mtMove,mtUp);

  TPaintType=(tPaint,tPaintRow);

  TBrushHandle = HBRUSH;

  TRectArray = array of TRect;

  TDrawColorPart = -100..100;

  TDrawGridLines = (dglBoth, dglNone, dglVertical, dglHorizontal);

  TDrawViewParams = record
    Bitmap: TBitmap;
    Color: TColor;
    Font: TFont;
    TextColor: TColor;
  end;

  TDrawBorder = (dLeft, dTop, dRight, dBottom);
  TDrawBorders = set of TDrawBorder;


  TDrawRegionHandle = HRGN;
  TDrawRegionOperation = (roSet, roAdd, roSubtract, roIntersect);
  TMFBrushType=(bSystem,bCustom);

  TItemSeleMFype=(istLeft,istRight,istMiddle,istAll);

const
  gAlignLeft = 1;
  gAlignRight = 2;
  gAlignHCenter = 4;
  gAlignTop = 8;
  gAlignBottom = 16;
  gAlignVCenter = 32;
  gAlignCenter = 36;
  gSingleLine = 64;
  gDontClip = 128;
  gExpandTabs = 256;
  gShowPrefix = 512;
  gWordBreak = 1024;
  gShowEndEllipsis = 2048;
  gDontPrint = 4096;
  gShowPathEllipsis = 8192;
  clMoneyGreen = TColor($C0DCC0);
  clSkyBlue = TColor($F0CAA6);
  clCream = TColor($F0FBFF);
  clMedGray = TColor($A4A0A0);
  DrawBordersAll = [dLeft, dTop, dRight, dBottom];
const
  CS_DROPSHADOW = $20000;
  WM_SchemeBase=WM_USER+1800;
  WM_ScrollUpdate =WM_SchemeBase+1;
  WM_ActiveViewChange= WM_SchemeBase+2;
  
implementation

end.
