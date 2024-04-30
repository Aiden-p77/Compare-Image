unit MainCompare;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.StdCtrls, Vcl.ExtCtrls,Math;
type
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = ARRAY[0..65536 - 1] OF TRGBTriple;
  TBit = 0..7;
  TBitSet = Set of TBit;

type
  TFMain = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Button1: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Button2: TButton;
    DifImg: TImage;
    Button7: TButton;
    LResult: TLabel;
    Button3: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  BPP = 8;
var
  FMain: TFMain;
  Val1,Val2,Val3,Javab:Real;
  IntX,IntY,IWid,Ihei,IntOff,MoCode:integer;
  BitmapOriginal,BitmapEncrypted: TBitmap;
  SAD:string;
implementation

{$R *.dfm}
function timeGetTime: DWord; stdcall; external 'winmm.dll' name 'timeGetTime';

function DifImage(nbmp:tbitmap;tbmp1,tbmp2:tbitmap):Boolean;
var r:TRect;
begin
   nbmp.Assign(tbmp1);
   R:= rect(0, 0,nbmp.Width, nbmp.Height);
   nbmp.Canvas.CopyMode:= cmSrcInvert;
   nbmp.Canvas.CopyRect(R, tbmp2.Canvas, R);
   result:=true;
end;

function IsSameBitmapUseMem(Bitmap1, Bitmap2: TBitmap): Boolean;
var
 Stream1, Stream2: TMemoryStream;
begin
  Assert((Bitmap1 <> nil) and (Bitmap2 <> nil), 'Params can''t be nil');
  Result:= False;
  if (Bitmap1.Height <> Bitmap2.Height) or (Bitmap1.Width <> Bitmap2.Width) then
     Exit;
  Stream1:= TMemoryStream.Create;
  try
    Bitmap1.SaveToStream(Stream1);
    Stream2:= TMemoryStream.Create;
    try
      Bitmap2.SaveToStream(Stream2);
      if Stream1.Size = Stream2.Size Then
        Result:= CompareMem(Stream1.Memory, Stream2.Memory, Stream1.Size);
    finally
      Stream2.Free;
    end;
  finally
    Stream1.Free;
  end;
end;

function IsSameBitmapUseScanLine(Bitmap1, Bitmap2: TBitmap): Boolean;
var
 i           : Integer;
 ScanBytes   : Integer;
begin
  Result:= (Bitmap1<>nil) and (Bitmap2<>nil);
  if not Result then exit;
  Result:=(bitmap1.Width=bitmap2.Width) and (bitmap1.Height=bitmap2.Height) and (bitmap1.PixelFormat=bitmap2.PixelFormat) ;

  if not Result then exit;

  ScanBytes := Abs(Integer(Bitmap1.Scanline[1]) - Integer(Bitmap1.Scanline[0]));
  for i:=0 to Bitmap1.Height-1 do
  Begin
    Result:=CompareMem(Bitmap1.ScanLine[i],Bitmap2.ScanLine[i],ScanBytes);
    if not Result then exit;
  End;
end;

procedure CropBitmap(InBitmap, OutBitMap : TBitmap; X, Y, W, H :Integer);
begin
  OutBitMap.PixelFormat := InBitmap.PixelFormat;
  OutBitMap.Width  := W;
  OutBitMap.Height := H;
  BitBlt(OutBitMap.Canvas.Handle, 0, 0, W, H, InBitmap.Canvas.Handle, X, Y, SRCCOPY);
end;

function ComparingByScanline(Img1In,Img2In : TBitmap;var PP:TPoint):Real;
var Bmp1,Bmp2:TBitmap;
    I:integer;
    Result_Compare:Boolean;
begin
  bmp1:=TBitmap.Create;
  Bmp2:=TBitmap.Create;
  for I := 0 to IWid-1 do
  begin
    if IntX >= IntOff then
      Break;
    if (Img1In.Empty = false) and (Img2In.Empty = false) then
    begin
      Result_Compare:=false;
      CropBitmap(Img1In,Bmp1,IntX,IntY,10,10);
      CropBitmap(Img2In,Bmp2,IntX,IntY,10,10);
  //    Result_Compare:=BitmapsAreSame(Bmp1,Bmp2,PP);
      Result_Compare:=IsSameBitmapUseScanLine(Bmp1,Bmp2);
    end;
    if Result_Compare = true then
    begin
      Javab:=Javab+1;
      Img2In.Canvas.Ellipse(IntX,IntY,IntX+10,IntY+10);
    end;
    IntX:=IntX+Bmp1.Width;
  end;
  Result:=Javab;
end;

function ComparingByMem(Img1In,Img2In : TBitmap;var PP:TPoint):Real;
var Bmp1,Bmp2:TBitmap;
    I:integer;
    Result_Compare:Boolean;
begin
  bmp1:=TBitmap.Create;
  Bmp2:=TBitmap.Create;
  for I := 0 to IWid-1 do
  begin
    if IntX >= IntOff then
      Break;
    if (Img1In.Empty = false) and (Img2In.Empty = false) then
    begin
      Result_Compare:=false;
      CropBitmap(Img1In,Bmp1,IntX,IntY,10,10);
      CropBitmap(Img2In,Bmp2,IntX,IntY,10,10);
  //    Result_Compare:=BitmapsAreSame(Bmp1,Bmp2,PP);
      Result_Compare:=IsSameBitmapUseMem(Bmp1,Bmp2);
    end;
    if Result_Compare = true then
    begin
      Javab:=Javab+1;
      Img2In.Canvas.Ellipse(IntX,IntY,IntX+10,IntY+10);
    end;
    IntX:=IntX+Bmp1.Width;
  end;
  Result:=Javab;
end;


procedure TFMain.Button1Click(Sender: TObject);
var s:string;
begin
  OpenPictureDialog1.Execute;
  s:=ExtractFileExt(OpenPictureDialog1.FileName);
  if s = '.bmp' then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end
  else
    ShowMessage('Please Select Bitmap Image');
end;

procedure TFMain.Button2Click(Sender: TObject);
var s:string;
begin
  OpenPictureDialog1.Execute;
  s:=ExtractFileExt(OpenPictureDialog1.FileName);
  if s = '.bmp' then
  begin
    Image2.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end
  else
    ShowMessage('Please Select Bitmap Image');

end;

procedure TFMain.Button3Click(Sender: TObject);
var i:integer;
    KolPix,Darsad,Res:real;
    Time:DWord;
    PosPix:TPoint;
begin
  Javab:=0;
  IntX:=0;
  IntY:=0;
  IWid:= (Image1.Picture.Width) Div 10 ;
  Ihei:= (Image2.Picture.Height) Div 10 ;
  KolPix:=IWid*Ihei;
  IntOff:=Image1.Picture.Bitmap.Width-10;
  DifImage(DifImg.Picture.Bitmap,Image1.Picture.Bitmap,Image2.Picture.Bitmap);
  Time:=timeGetTime;
  for I := 0 to Ihei-1 do
  begin
    Res:=ComparingByScanline(Image1.Picture.Bitmap,Image2.Picture.Bitmap,PosPix);
    IntX:=0;
    IntY:=IntY+10;
  end;
  Time:=timeGetTime - Time;
  Darsad:=(Res*100) / KolPix;
  if Darsad < 50 then
  begin
    LResult.Font.Color:=clRed;
    LResult.Caption:='Result: '+FloatToStr(Darsad)+'% Not Similar Completed in '+IntToStr(Time)+' Ms By Scanline Way';
  end;
  if (Darsad > 50) and (Darsad < 80) then
  begin
    LResult.Font.Color:=clOlive;
    LResult.Caption:='Result: '+FloatToStr(Darsad)+'% Same Similar Completed in '+IntToStr(Time)+' Ms By Scanline Way';
  end;
  if (Darsad > 80) and (Darsad < 95) then
  begin
    LResult.Font.Color:=clGreen;
    LResult.Caption:='Result: '+FloatToStr(Darsad)+'% A Lot Similar Completed in '+IntToStr(Time)+' Ms By Scanline Way';
  end;
  if  (Darsad > 95) then
  begin
    LResult.Font.Color:=clGreen;
    LResult.Caption:='Result: '+FloatToStr(Darsad)+'% Similar Completed in '+IntToStr(Time)+' Ms By Scanline Way';
  end;
end;

procedure TFMain.Button7Click(Sender: TObject);
var i:integer;
    KolPix,Darsad,Res:real;
    Time:DWord;
    PosPix:TPoint;
begin
  Javab:=0;
  IntX:=0;
  IntY:=0;
  IWid:= (Image1.Picture.Width) Div 10 ;
  Ihei:= (Image2.Picture.Height) Div 10 ;
  KolPix:=IWid*Ihei;
  IntOff:=Image1.Picture.Bitmap.Width-10;
  DifImage(DifImg.Picture.Bitmap,Image1.Picture.Bitmap,Image2.Picture.Bitmap);
  Time:=timeGetTime;
  for I := 0 to Ihei-1 do
  begin
    Res:=ComparingByMem(Image1.Picture.Bitmap,Image2.Picture.Bitmap,PosPix);
    IntX:=0;
    IntY:=IntY+10;
  end;
  Time:=timeGetTime - Time;
  Darsad:=(Res*100) / KolPix;
  if Darsad < 50 then
  begin
    LResult.Font.Color:=clRed;
    LResult.Caption:='Result: '+FloatToStr(Darsad)+'% Not Similar Completed in '+IntToStr(Time)+' Ms By Memory Stream Way';
  end;
  if (Darsad > 50) and (Darsad < 80) then
  begin
    LResult.Font.Color:=clOlive;
    LResult.Caption:='Result: '+FloatToStr(Darsad)+'% Same Similar Completed in '+IntToStr(Time)+' Ms By Memory Stream Way';
  end;
  if (Darsad > 80) and (Darsad < 95) then
  begin
    LResult.Font.Color:=clGreen;
    LResult.Caption:='Result: '+FloatToStr(Darsad)+'% A Lot Similar Completed in '+IntToStr(Time)+' Ms By Memory Stream Way';
  end;
  if  (Darsad > 95) then
  begin
    LResult.Font.Color:=clGreen;
    LResult.Caption:='Result: '+FloatToStr(Darsad)+'% Similar Completed in '+IntToStr(Time)+' Ms By Memory Stream Way';
  end;
end;

end.
