unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, IdHTTP,
  IdSSLOpenSSL, IdCompressorZLib, GoComicsAPI;



type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    IdCompressorZLib1: TIdCompressorZLib;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Memo1: TMemo;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
  private
    procedure ShowDownloadedComic(const FilePath: string);
    function GetComicsDailyDir: string;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.GetComicsDailyDir: string;
var
  HomeDir: string;
begin
  HomeDir := GetEnvironmentVariable('HOME');
  if HomeDir = '' then
    raise Exception.Create('Could not find home directory.');

  Result := IncludeTrailingPathDelimiter(HomeDir) + 'comics_daily';

  if not DirectoryExists(Result) then
    if not CreateDir(Result) then
      raise Exception.Create('Could not create comics_daily directory.');
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  GoComics: TGoComics;
  ComicDate: TDateTime;
  FilePath: string;
begin
  Memo1.Lines.Add('Starting comic download...');
  try
    GoComics := TGoComics.Create('calvinandhobbes');
    try
      ComicDate := Now;  // or specify a specific date like EncodeDate(2024, 1, 1);
      FilePath := IncludeTrailingPathDelimiter(GetComicsDailyDir) + 'calvinandhobbes.png';
      GoComics.DownloadComic(ComicDate, FilePath);
      Memo1.Lines.Add('Comic downloaded successfully!');
      ShowDownloadedComic(FilePath);
    finally
      GoComics.Free;
    end;
  except
    on E: Exception do
      Memo1.Lines.Add('Error: ' + E.Message);
  end;
end;
procedure TForm1.ShowDownloadedComic(const FilePath: string);
begin
  if FileExists(FilePath) then
  begin
    Image1.Picture.LoadFromFile(FilePath);
    Memo1.Lines.Add('Comic displayed successfully!');
  end
  else
  begin
    Memo1.Lines.Add('Error: File not found - ' + FilePath);
  end;
end;

end.

